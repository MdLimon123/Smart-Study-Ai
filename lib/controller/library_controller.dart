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

  String? _messageFromBody(dynamic body) {
    if (body is Map) return body['message']?.toString();
    return null;
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
      final response = await ApiClient.getData(ApiConstant.getFilesEndpoint);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        if (body is Map && body['data'] is Map) {
          final data = body['data'] as Map;
          final results = data['results'];
          if (results is List) {
            files.assignAll(
              results
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
        }
      } else {
        filesError.value =
            _messageFromBody(response.body) ?? 'Could not load files';
      }
    } catch (e) {
      filesError.value = e.toString();
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

      final msg = _messageFromBody(response.body) ??
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
        {
          'subject': subject.trim().toLowerCase(),
          'title': t,
        },
        multipartBody: [MultipartBody('image', imageFile)],
      );

      final msg = _messageFromBody(response.body) ??
          response.statusText ??
          'Something went wrong';

      if (response.statusCode == 201 || response.statusCode == 200) {
        fetchImages();
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
        {
          'subject': subject.trim().toLowerCase(),
          'title': t,
        },
        multipartBody: [MultipartBody('file', file)],
      );

      final msg = _messageFromBody(response.body) ??
          response.statusText ??
          'Something went wrong';

      if (response.statusCode == 201 || response.statusCode == 200) {
        fetchFiles();
        return (success: true, message: msg);
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

      final msg = _messageFromBody(response.body) ??
          response.statusText ??
          'Something went wrong';

      final code = response.statusCode;
      if (code == 200 || code == 201 || code == 204) {
        fetchFolders();
        return (
          success: true,
          message: msg.isNotEmpty
              ? msg
              : 'Folder deleted successfully.',
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

      final msg = _messageFromBody(response.body) ??
          response.statusText ??
          'Something went wrong';

      final code = response.statusCode;
      if (code == 200 || code == 201 || code == 204) {
        fetchFiles();
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

      final msg = _messageFromBody(response.body) ??
          response.statusText ??
          'Something went wrong';

      final code = response.statusCode;
      if (code == 200 || code == 201 || code == 204) {
        fetchImages();
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

      final msg = _messageFromBody(response.body) ??
          response.statusText ??
          'Something went wrong';

      final code = response.statusCode;
      if (code == 200 || code == 201 || code == 204) {
        fetchNotes();
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
