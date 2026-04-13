import 'dart:io';

import 'package:flutter_extension/data/api/api_client.dart';
import 'package:flutter_extension/data/api/api_constant.dart';
import 'package:flutter_extension/data/model/library_file_model.dart';
import 'package:flutter_extension/data/model/library_folder_model.dart';
import 'package:flutter_extension/data/model/library_image_model.dart';
import 'package:flutter_extension/data/model/library_note_model.dart';
import 'package:get/get.dart';

class LibraryController extends GetxController {
  final isLoading = false.obs;
  final isFoldersLoading = false.obs;
  final folders = <LibraryFolderModel>[].obs;
  final foldersError = RxnString();

  final isNotesLoading = false.obs;
  final notes = <LibraryNoteModel>[].obs;
  final notesError = RxnString();

  final isImagesLoading = false.obs;
  final images = <LibraryImageModel>[].obs;
  final imagesError = RxnString();

  final isFilesLoading = false.obs;
  final files = <LibraryFileModel>[].obs;
  final filesError = RxnString();

  final isFolderDetailLoading = false.obs;
  final folderDetailError = RxnString();
  final folderDetailFolder = Rxn<LibraryFolderModel>();
  final folderDetailNotes = <LibraryNoteModel>[].obs;
  final folderDetailImages = <LibraryImageModel>[].obs;
  final folderDetailFiles = <LibraryFileModel>[].obs;
  final folderDetailTotalCount = 0.obs;

  void clearFolderDetail() {
    folderDetailFolder.value = null;
    folderDetailNotes.clear();
    folderDetailImages.clear();
    folderDetailFiles.clear();
    folderDetailTotalCount.value = 0;
    folderDetailError.value = null;
    isFolderDetailLoading.value = false;
  }

  Future<void> fetchFolderContents(String folderId) async {
    isFolderDetailLoading.value = true;
    folderDetailError.value = null;
    try {
      final response = await ApiClient.getData(
        ApiConstant.getFolderDetailsEndpoint(id: folderId),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        if (body is Map && body['data'] is Map) {
          final data = body['data'] as Map;

          final folderJson = data['folder'];
          if (folderJson is Map) {
            folderDetailFolder.value = LibraryFolderModel.fromJson(
              Map<String, dynamic>.from(folderJson),
            );
          } else {
            folderDetailFolder.value = null;
          }

          void parseSection<T>(
            String key,
            T Function(Map<String, dynamic>) fromJson,
            RxList<T> target,
          ) {
            final section = data[key];
            if (section is Map) {
              final items = section['items'];
              if (items is List) {
                target.assignAll(
                  items
                      .map(
                        (e) => fromJson(Map<String, dynamic>.from(e as Map)),
                      )
                      .toList(),
                );
              } else {
                target.clear();
              }
            } else {
              target.clear();
            }
          }

          parseSection('notes', LibraryNoteModel.fromJson, folderDetailNotes);
          parseSection(
            'images',
            LibraryImageModel.fromJson,
            folderDetailImages,
          );
          parseSection('files', LibraryFileModel.fromJson, folderDetailFiles);

          final tc = data['total_count'];
          if (tc is int) {
            folderDetailTotalCount.value = tc;
          } else if (tc is num) {
            folderDetailTotalCount.value = tc.toInt();
          } else {
            folderDetailTotalCount.value = folderDetailNotes.length +
                folderDetailImages.length +
                folderDetailFiles.length;
          }
        }
      } else {
        folderDetailError.value =
            _messageFromBody(response.body) ?? 'Could not load folder';
      }
    } catch (e) {
      folderDetailError.value = e.toString();
    } finally {
      isFolderDetailLoading.value = false;
    }
  }

  String? _messageFromBody(dynamic body) {
    if (body is Map) return body['message']?.toString();
    return null;
  }

  /// GET `/library/notes|images|files/:id/` — detail for [ProblemSolutionScreen].
  /// [type] is [LibraryItem.type]: `note`, `image`, or `upload` (file).
  Future<
      ({
        LibraryNoteModel? note,
        LibraryImageModel? image,
        LibraryFileModel? file,
        String? error,
      })> fetchLibraryItemDetail({
    required String id,
    required String type,
  }) async {
    final tid = id.trim();
    if (tid.isEmpty) {
      return (
        note: null,
        image: null,
        file: null,
        error: 'Invalid id',
      );
    }
    switch (type) {
      case 'note':
        try {
          final response = await ApiClient.getData(
            ApiConstant.getSpecificNoteEndpoint(id: tid),
          );
          if (response.statusCode == 200 || response.statusCode == 201) {
            final body = response.body;
            if (body is Map && body['data'] is Map) {
              final data = Map<String, dynamic>.from(body['data'] as Map);
              return (
                note: LibraryNoteModel.fromJson(data),
                image: null,
                file: null,
                error: null,
              );
            }
          }
          return (
            note: null,
            image: null,
            file: null,
            error: _messageFromBody(response.body) ?? 'Could not load note',
          );
        } catch (e) {
          return (
            note: null,
            image: null,
            file: null,
            error: e.toString(),
          );
        }
      case 'image':
        try {
          final response = await ApiClient.getData(
            ApiConstant.getSpecificImageEndpoint(id: tid),
          );
          if (response.statusCode == 200 || response.statusCode == 201) {
            final body = response.body;
            if (body is Map && body['data'] is Map) {
              final data = Map<String, dynamic>.from(body['data'] as Map);
              return (
                note: null,
                image: LibraryImageModel.fromJson(data),
                file: null,
                error: null,
              );
            }
          }
          return (
            note: null,
            image: null,
            file: null,
            error: _messageFromBody(response.body) ?? 'Could not load image',
          );
        } catch (e) {
          return (
            note: null,
            image: null,
            file: null,
            error: e.toString(),
          );
        }
      case 'upload':
        try {
          final response = await ApiClient.getData(
            ApiConstant.getSpecificFileEndpoint(id: tid),
          );
          if (response.statusCode == 200 || response.statusCode == 201) {
            final body = response.body;
            if (body is Map && body['data'] is Map) {
              final data = Map<String, dynamic>.from(body['data'] as Map);
              return (
                note: null,
                image: null,
                file: LibraryFileModel.fromJson(data),
                error: null,
              );
            }
          }
          return (
            note: null,
            image: null,
            file: null,
            error: _messageFromBody(response.body) ?? 'Could not load file',
          );
        } catch (e) {
          return (
            note: null,
            image: null,
            file: null,
            error: e.toString(),
          );
        }
      default:
        return (
          note: null,
          image: null,
          file: null,
          error: 'Unsupported item type',
        );
    }
  }

  /// Overview may omit `files`; returns false so caller can use [GET /library/files/].
  bool _parseOverviewFilesSection(Map data) {
    dynamic section = data['files'];
    if (section is! Map) section = data['uploads'];
    if (section is! Map) return false;

    final items = section['items'];
    if (items is List) {
      files.assignAll(
        items
            .map(
              (e) => LibraryFileModel.fromJson(
                Map<String, dynamic>.from(e as Map),
              ),
            )
            .toList(),
      );
    } else {
      files.clear();
    }
    return true;
  }

  /// Populates [files] from the list endpoint ([data.results] or [data.items]).
  Future<void> _loadFilesFromListEndpoint() async {
    try {
      final response = await ApiClient.getData(ApiConstant.getFilesEndpoint);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        if (body is Map && body['data'] is Map) {
          final d = body['data'] as Map;
          final raw = d['results'] ?? d['items'];
          if (raw is List) {
            files.assignAll(
              raw
                  .map(
                    (e) => LibraryFileModel.fromJson(
                      Map<String, dynamic>.from(e as Map),
                    ),
                  )
                  .toList(),
            );
            filesError.value = null;
            return;
          }
        }
        files.clear();
        filesError.value = null;
        return;
      }
      files.clear();
      filesError.value =
          _messageFromBody(response.body) ?? 'Could not load files';
    } catch (e) {
      files.clear();
      filesError.value = e.toString();
    }
  }

  /// Single endpoint for library home: notes, images, folders (+ optional files).
  Future<void> fetchLibraryOverview() async {
    isNotesLoading.value = true;
    isImagesLoading.value = true;
    isFoldersLoading.value = true;
    isFilesLoading.value = true;
    notesError.value = null;
    imagesError.value = null;
    foldersError.value = null;
    filesError.value = null;
    try {
      final response = await ApiClient.getData(
        ApiConstant.getAllLibraryItemsEndpoint,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        if (body is Map && body['data'] is Map) {
          final data = body['data'] as Map;

          void parseSection<T>(
            String key,
            T Function(Map<String, dynamic>) fromJson,
            RxList<T> target,
          ) {
            final section = data[key];
            if (section is Map) {
              final items = section['items'];
              if (items is List) {
                target.assignAll(
                  items
                      .map(
                        (e) => fromJson(Map<String, dynamic>.from(e as Map)),
                      )
                      .toList(),
                );
              } else {
                target.clear();
              }
            } else {
              target.clear();
            }
          }

          parseSection('notes', LibraryNoteModel.fromJson, notes);
          parseSection('images', LibraryImageModel.fromJson, images);
          parseSection('folders', LibraryFolderModel.fromJson, folders);
          if (!_parseOverviewFilesSection(data)) {
            await _loadFilesFromListEndpoint();
          }
        }
      } else {
        final msg =
            _messageFromBody(response.body) ?? 'Could not load library';
        notesError.value = msg;
        imagesError.value = msg;
        foldersError.value = msg;
        filesError.value = msg;
      }
    } catch (e) {
      notesError.value = e.toString();
      imagesError.value = e.toString();
      foldersError.value = e.toString();
      filesError.value = e.toString();
    } finally {
      isNotesLoading.value = false;
      isImagesLoading.value = false;
      isFoldersLoading.value = false;
      isFilesLoading.value = false;
    }
  }

  Future<void> fetchFolders() async {
    isFoldersLoading.value = true;
    foldersError.value = null;
    try {
      final response = await ApiClient.getData(ApiConstant.getFoldersEndpoint);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        if (body is Map && body['data'] is Map) {
          final data = body['data'] as Map;
          final results = data['results'];
          if (results is List) {
            folders.assignAll(
              results
                  .map(
                    (e) => LibraryFolderModel.fromJson(
                      Map<String, dynamic>.from(e as Map),
                    ),
                  )
                  .toList(),
            );
          } else {
            folders.clear();
          }
        }
      } else {
        foldersError.value =
            _messageFromBody(response.body) ?? 'Could not load folders';
      }
    } catch (e) {
      foldersError.value = e.toString();
    } finally {
      isFoldersLoading.value = false;
    }
  }

  Future<void> fetchNotes() async {
    isNotesLoading.value = true;
    notesError.value = null;
    try {
      final response = await ApiClient.getData(ApiConstant.getNotesEndpoint);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        if (body is Map && body['data'] is Map) {
          final data = body['data'] as Map;
          final results = data['results'];
          if (results is List) {
            notes.assignAll(
              results
                  .map(
                    (e) => LibraryNoteModel.fromJson(
                      Map<String, dynamic>.from(e as Map),
                    ),
                  )
                  .toList(),
            );
          } else {
            notes.clear();
          }
        }
      } else {
        notesError.value =
            _messageFromBody(response.body) ?? 'Could not load notes';
      }
    } catch (e) {
      notesError.value = e.toString();
    } finally {
      isNotesLoading.value = false;
    }
  }

  Future<void> fetchImages() async {
    isImagesLoading.value = true;
    imagesError.value = null;
    try {
      final response = await ApiClient.getData(ApiConstant.getImagesEndpoint);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        if (body is Map && body['data'] is Map) {
          final data = body['data'] as Map;
          final results = data['results'];
          if (results is List) {
            images.assignAll(
              results
                  .map(
                    (e) => LibraryImageModel.fromJson(
                      Map<String, dynamic>.from(e as Map),
                    ),
                  )
                  .toList(),
            );
          } else {
            images.clear();
          }
        }
      } else {
        imagesError.value =
            _messageFromBody(response.body) ?? 'Could not load images';
      }
    } catch (e) {
      imagesError.value = e.toString();
    } finally {
      isImagesLoading.value = false;
    }
  }

  Future<void> fetchFiles() async {
    isFilesLoading.value = true;
    filesError.value = null;
    try {
      await _loadFilesFromListEndpoint();
    } finally {
      isFilesLoading.value = false;
    }
  }

  Future<({bool success, String message})> createFolder(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return (success: false, message: 'Please enter a folder name');
    }

    isLoading.value = true;
    try {
      final response = await ApiClient.postData(
        ApiConstant.folderCreateEndpoint,
        {'name': trimmed},
      );

      final msg =
          _messageFromBody(response.body) ??
          response.statusText ??
          'Something went wrong';

      if (response.statusCode == 201 || response.statusCode == 200) {
        return (success: true, message: msg);
      }

      return (success: false, message: msg);
    } catch (e) {
      return (success: false, message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<({bool success, String message})> createNote({
    required String title,
    required String content,
    required String subject,
  }) async {
    final t = title.trim();
    if (t.isEmpty) {
      return (success: false, message: 'Please enter a title');
    }

    isLoading.value = true;
    try {
      final response = await ApiClient.postData(
        ApiConstant.notesCreateEndpoint,
        {
          'title': t,
          'text': content.trim(),
          'subject': subject.trim().toLowerCase(),
        },
      );

      final msg =
          _messageFromBody(response.body) ??
          response.statusText ??
          'Something went wrong';

      if (response.statusCode == 201 || response.statusCode == 200) {
        return (success: true, message: msg);
      }

      return (success: false, message: msg);
    } catch (e) {
      return (success: false, message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<({bool success, String message})> createNoteInFolder({
    required String folderId,
    required String title,
    required String content,
    required String subject,
  }) async {
    final t = title.trim();
    if (t.isEmpty) {
      return (success: false, message: 'Please enter a title');
    }

    isLoading.value = true;
    try {
      final response =
          await ApiClient.postData(ApiConstant.notesCreateEndpoint, {
            'title': t,
            'text': content.trim(),
            'subject': subject.trim().toLowerCase(),
            'folder': folderId,
          });

      final msg =
          _messageFromBody(response.body) ??
          response.statusText ??
          'Something went wrong';

      if (response.statusCode == 201 || response.statusCode == 200) {
        return (success: true, message: msg);
      }

      return (success: false, message: msg);
    } catch (e) {
      return (success: false, message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<({bool success, String message})> uploadImage({
    required String subject,
    required String title,
    required File imageFile,
  }) async {
    final t = title.trim();
    if (t.isEmpty) {
      return (success: false, message: 'Please enter a title');
    }

    isLoading.value = true;
    try {
      final response = await ApiClient.postMultipartData(
        ApiConstant.imageUploadEndpoint,
        {'subject': subject.trim().toLowerCase(), 'title': t},
        multipartBody: [MultipartBody('image', imageFile)],
      );

      final msg =
          _messageFromBody(response.body) ??
          response.statusText ??
          'Something went wrong';

      if (response.statusCode == 201 || response.statusCode == 200) {
        fetchLibraryOverview();
        return (success: true, message: msg);
      }

      return (success: false, message: msg);
    } catch (e) {
      return (success: false, message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<({bool success, String message})> uploadImageInFolder({
    required String subject,
    required String title,
    required File imageFile,
    required String folderId,
  }) async {
    final t = title.trim();
    if (t.isEmpty) {
      return (success: false, message: 'Please enter a title');
    }

    isLoading.value = true;
    try {
      final response = await ApiClient.postMultipartData(
        ApiConstant.imageUploadEndpoint,
        {
          'subject': subject.trim().toLowerCase(),
          'title': t,
          'folder': folderId,
        },
        multipartBody: [MultipartBody('image', imageFile)],
      );

      final msg =
          _messageFromBody(response.body) ??
          response.statusText ??
          'Something went wrong';

      if (response.statusCode == 201 || response.statusCode == 200) {
        fetchLibraryOverview();
        return (success: true, message: msg);
      }

      return (success: false, message: msg);
    } catch (e) {
      return (success: false, message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<({bool success, String message})> uploadFile({
    required String subject,
    required String title,
    required File file,
  }) async {
    final t = title.trim();
    if (t.isEmpty) {
      return (success: false, message: 'Please enter a title');
    }

    isLoading.value = true;
    try {
      final response = await ApiClient.postMultipartData(
        ApiConstant.fileUploadEndpoint,
        {'subject': subject.trim().toLowerCase(), 'title': t},
        multipartBody: [MultipartBody('file', file)],
      );

      final msg =
          _messageFromBody(response.body) ??
          response.statusText ??
          'Something went wrong';

      if (response.statusCode == 201 || response.statusCode == 200) {
        fetchFiles();
        fetchLibraryOverview();
        return (success: true, message: msg);
      }

      return (success: false, message: msg);
    } catch (e) {
      return (success: false, message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<({bool success, String message})> uploadFileInFolder({
    required String subject,
    required String title,
    required File file,
    required String folderId,
  }) async {
    final t = title.trim();
    if (t.isEmpty) {
      return (success: false, message: 'Please enter a title');
    }

    isLoading.value = true;
    try {
      final response = await ApiClient.postMultipartData(
        ApiConstant.fileUploadEndpoint,
        {
          'subject': subject.trim().toLowerCase(),
          'title': t,
          'folder': folderId,
        },
        multipartBody: [MultipartBody('file', file)],
      );

      final msg =
          _messageFromBody(response.body) ??
          response.statusText ??
          'Something went wrong';

      if (response.statusCode == 201 || response.statusCode == 200) {
        fetchFiles();
        fetchLibraryOverview();
        return (success: true, message: msg);
      }

      return (success: false, message: msg);
    } catch (e) {
      return (success: false, message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Rename via PATCH — picks the correct endpoint per [type] (`note`, `image`, `upload`, `folder`).
  Future<({bool success, String message})> renameLibraryItem({
    required String id,
    required String type,
    required String title,
  }) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) {
      return (success: false, message: 'Please enter a title');
    }
    final trimmedId = id.trim();
    if (trimmedId.isEmpty) {
      return (success: false, message: 'Invalid item');
    }

    final String uri;
    switch (type) {
      case 'note':
        uri = ApiConstant.editNoteEndpoint(id: trimmedId);
        break;
      case 'image':
        uri = ApiConstant.editImageEndpoint(id: trimmedId);
        break;
      case 'upload':
        uri = ApiConstant.editFileEndpoint(id: trimmedId);
        break;
      case 'folder':
        uri = ApiConstant.editFolderEndpoint(id: trimmedId);
        break;
      default:
        return (success: false, message: 'Cannot rename this item');
    }

    return _patchItemTitle(uri: uri, title: trimmed);
  }

  /// PATCH rename: note/folder → JSON without `charset` in Content-Type; image/file →
  /// `application/x-www-form-urlencoded` (avoids 415 when those views omit JSONParser).
  Future<({bool success, String message})> _patchItemTitle({
    required String uri,
    required String title,
  }) async {
    isLoading.value = true;
    try {
      final response =
          uri.contains('/library/images/') || uri.contains('/library/files/')
              ? await ApiClient.patchUrlEncoded(uri, {'title': title})
              : await ApiClient.patchData(
                  uri,
                  <String, dynamic>{'title': title},
                  headers: const {'Content-Type': 'application/json'},
                );
      final msg =
          _messageFromBody(response.body) ??
          response.statusText ??
          'Something went wrong';
      final code = response.statusCode;
      if (code == 200 || code == 201 || code == 204) {
        return (
          success: true,
          message: msg.isNotEmpty ? msg : 'Updated successfully.',
        );
      }
      return (success: false, message: msg);
    } catch (e) {
      return (success: false, message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<({bool success, String message})> deleteFolder(String id) async {
    final trimmed = id.trim();
    if (trimmed.isEmpty) {
      return (success: false, message: 'Invalid folder');
    }

    isLoading.value = true;
    try {
      final response = await ApiClient.deleteData(
        ApiConstant.deleteFolderEndpoint(id: trimmed),
      );

      final msg =
          _messageFromBody(response.body) ??
          response.statusText ??
          'Something went wrong';

      final code = response.statusCode;
      if (code == 200 || code == 201 || code == 204) {
        fetchLibraryOverview();
        return (
          success: true,
          message: msg.isNotEmpty ? msg : 'Folder deleted successfully.',
        );
      }

      return (success: false, message: msg);
    } catch (e) {
      return (success: false, message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<({bool success, String message})> deleteFile(String id) async {
    final trimmed = id.trim();
    if (trimmed.isEmpty) {
      return (success: false, message: 'Invalid file');
    }

    isLoading.value = true;
    try {
      final response = await ApiClient.deleteData(
        ApiConstant.deleteFileEndpoint(id: trimmed),
      );

      final msg =
          _messageFromBody(response.body) ??
          response.statusText ??
          'Something went wrong';

      final code = response.statusCode;
      if (code == 200 || code == 201 || code == 204) {
        fetchFiles();
        fetchLibraryOverview();
        return (
          success: true,
          message: msg.isNotEmpty ? msg : 'File deleted successfully.',
        );
      }

      return (success: false, message: msg);
    } catch (e) {
      return (success: false, message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<({bool success, String message})> deleteImage(String id) async {
    final trimmed = id.trim();
    if (trimmed.isEmpty) {
      return (success: false, message: 'Invalid image');
    }

    isLoading.value = true;
    try {
      final response = await ApiClient.deleteData(
        ApiConstant.deleteImageEndpoint(id: trimmed),
      );

      final msg =
          _messageFromBody(response.body) ??
          response.statusText ??
          'Something went wrong';

      final code = response.statusCode;
      if (code == 200 || code == 201 || code == 204) {
        fetchLibraryOverview();
        return (
          success: true,
          message: msg.isNotEmpty ? msg : 'Image deleted successfully.',
        );
      }

      return (success: false, message: msg);
    } catch (e) {
      return (success: false, message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<({bool success, String message})> deleteNote(String id) async {
    final trimmed = id.trim();
    if (trimmed.isEmpty) {
      return (success: false, message: 'Invalid note');
    }

    isLoading.value = true;
    try {
      final response = await ApiClient.deleteData(
        ApiConstant.deleteNoteEndpoint(id: trimmed),
      );

      final msg =
          _messageFromBody(response.body) ??
          response.statusText ??
          'Something went wrong';

      final code = response.statusCode;
      if (code == 200 || code == 201 || code == 204) {
        fetchLibraryOverview();
        return (
          success: true,
          message: msg.isNotEmpty ? msg : 'Note deleted successfully.',
        );
      }

      return (success: false, message: msg);
    } catch (e) {
      return (success: false, message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
