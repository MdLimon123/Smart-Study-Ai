import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/library_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/screen/library/folderDetails/folder_create_notes_screen.dart';
import 'package:flutter_extension/views/screen/library/folderDetails/folder_file_upload.dart';
import 'package:flutter_extension/views/screen/library/folderDetails/folder_image_upload.dart';
import 'package:flutter_extension/views/screen/library/library_content_ui.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class FolderDetails extends StatefulWidget {
  final String id;

  const FolderDetails({super.key, required this.id});

  @override
  State<FolderDetails> createState() => _FolderDetailsState();
}

class _FolderDetailsState extends State<FolderDetails> {
  late final LibraryController _libraryController;

  Future<void> _refresh() => _libraryController.fetchFolderContents(widget.id);

  @override
  void initState() {
    super.initState();
    _libraryController = Get.find<LibraryController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refresh();
    });
  }

  @override
  void dispose() {
    _libraryController.clearFolderDetail();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.textColor.withValues(alpha: 0.04),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_back,
                          color: AppColors.textColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Obx(() {
                      final name =
                          _libraryController.folderDetailFolder.value?.name ??
                          'Folder';
                      return Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textColor,
                        ),
                      );
                    }),
                  ),
                  GestureDetector(
                    onTap: () => _showAddToLibrarySheet(context),
                    child: Container(
                      width: 76,
                      height: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: AppColors.textColor, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            'Add',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Obx(() {
                        if (_libraryController.isFolderDetailLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFA78BFA),
                            ),
                          );
                        }
                        final err =
                            _libraryController.folderDetailError.value;
                        if (err != null && err.isNotEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    err,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textColor.withValues(
                                        alpha: 0.70,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextButton(
                                    onPressed: _refresh,
                                    child: Text(
                                      'Retry',
                                      style: TextStyle(
                                        color: AppColors.textColor.withValues(
                                          alpha: 0.90,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return RefreshIndicator(
                          color: const Color(0xFFA78BFA),
                          onRefresh: _refresh,
                          child: _buildFolderList(),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onAfterDelete() =>
      _libraryController.fetchFolderContents(widget.id);

  Widget _buildFolderList() {
    final notes = _libraryController.folderDetailNotes;
    final images = _libraryController.folderDetailImages;
    final files = _libraryController.folderDetailFiles;

    if (notes.isEmpty && images.isEmpty && files.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Center(
              child: Text(
                'This folder is empty',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textColor.withValues(alpha: 0.45),
                ),
              ),
            ),
          ),
        ],
      );
    }
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        if (notes.isNotEmpty) ...[
          _sectionHeader('Notes'),
          ...notes.map(
            (n) => LibraryContentUi.noteTile(
              context,
              _libraryController,
              n,
              afterDelete: _onAfterDelete,
              afterRename: _onAfterDelete,
            ),
          ),
        ],
        if (images.isNotEmpty) ...[
          _sectionHeader('Images'),
          ...images.map(
            (img) => LibraryContentUi.imageTile(
              context,
              _libraryController,
              img,
              afterDelete: _onAfterDelete,
              afterRename: _onAfterDelete,
            ),
          ),
        ],
        if (files.isNotEmpty) ...[
          _sectionHeader('Uploads'),
          ...files.map(
            (f) => LibraryContentUi.fileTile(
              context,
              _libraryController,
              f,
              afterDelete: _onAfterDelete,
              afterRename: _onAfterDelete,
            ),
          ),
        ],
      ],
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.textColor.withValues(alpha: 0.45),
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  void _showAddToLibrarySheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1B2E),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Add to Library',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _addOption(
                    backgroundColor: const Color(0xFFA78BFA),
                    icon: 'assets/icon/notes.svg',
                    label: 'Create Note',
                    borderColor: const Color(0xFFA78BFA),
                    iconColor: const Color(0xFF6366F1),
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => FolderCreateNotesScreen(id: widget.id))
                          ?.then((_) => _refresh());
                    },
                  ),
                  const SizedBox(width: 12),
                  _addOption(
                    backgroundColor: const Color(0xFF60A5FA),
                    icon: 'assets/icon/uplaod_image.svg',
                    label: 'Upload Image',
                    borderColor: const Color(0xFF60A5FA),
                    iconColor: const Color(0xFF10B981),
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => FolderImageUpload(id: widget.id))
                          ?.then((_) => _refresh());
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _addOption(
                    backgroundColor: const Color(0xFF34D399),
                    icon: 'assets/icon/upload_file.svg',
                    label: 'Upload File',
                    borderColor: const Color(0xFF34D399),
                    iconColor: const Color(0xFFF59E0B),
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => FolderFileUpload(id: widget.id))
                          ?.then((_) => _refresh());
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _addOption({
    required String icon,
    required String label,
    required Color borderColor,
    required Color backgroundColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 46,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor.withValues(alpha: 0.30)),
            color: backgroundColor.withValues(alpha: 0.07),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(icon),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
