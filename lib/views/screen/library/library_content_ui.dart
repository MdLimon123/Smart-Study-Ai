import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/library_controller.dart';
import 'package:flutter_extension/data/model/library_file_model.dart';
import 'package:flutter_extension/data/model/library_image_model.dart';
import 'package:flutter_extension/data/model/library_note_model.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:flutter_extension/views/screen/library/folderDetails/folder_details.dart';
import 'package:flutter_extension/views/screen/library/library_item.dart';
import 'package:flutter_extension/views/screen/library/problem_solution_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

/// Shared list tiles + action sheets (library home + folder details).
class LibraryContentUi {
  LibraryContentUi._();

  static String dateLabel(String iso) {
    final t = iso.indexOf('T');
    if (t > 0) return iso.substring(0, t);
    if (iso.length >= 10) return iso.substring(0, 10);
    return iso.isEmpty ? '—' : iso;
  }

  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    final kb = bytes / 1024;
    if (kb < 1024) {
      return kb < 10 ? '${kb.toStringAsFixed(1)} KB' : '${kb.round()} KB';
    }
    final mb = kb / 1024;
    return mb < 10 ? '${mb.toStringAsFixed(1)} MB' : '${mb.round()} MB';
  }

  static Color subjectAccentColor(String raw) {
    switch (raw.trim().toLowerCase()) {
      case 'mathematics':
        return const Color(0xFFA78BFA);
      case 'physics':
        return const Color(0xFFF59E0B);
      case 'chemistry':
        return const Color(0xFF10B981);
      case 'biology':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF10B981);
    }
  }

  static String subjectLabel(String raw) {
    final s = raw.trim().toLowerCase();
    if (s.isEmpty) return '—';
    return s[0].toUpperCase() + (s.length > 1 ? s.substring(1) : '');
  }

  static String notePreview(String text) {
    final t = text.trim();
    if (t.isEmpty) return 'No content';
    if (t.length <= 80) return t;
    return '${t.substring(0, 80)}…';
  }

  static Future<void> showItemActionsMenu(
    BuildContext context, {
    required LibraryController libraryController,
    required Widget leading,
    required String title,
    required String subtitle,
    required LibraryItem renameItem,
    Future<void> Function()? onDelete,
    Future<void> Function()? afterRename,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1B2E),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    leading,
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textColor.withValues(
                                alpha: 0.40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: AppColors.textColor.withValues(alpha: 0.08),
                height: 1,
              ),
              _menuOption(
                icon: 'assets/icon/visiable.svg',
                iconColor: const Color(0xFF60A5FA),
                backgroundColor: const Color(
                  0xFF60A5FA,
                ).withValues(alpha: 0.12),
                label: 'Open',
                onTap: () {
                  Navigator.pop(context);
                  if (renameItem.type == 'folder') {
                    Get.to(() => FolderDetails(id: renameItem.id));
                  } else {
                    Get.to(
                      () => ProblemSolutionScreen(
                        id: renameItem.id,
                        itemType: renameItem.type,
                      ),
                    );
                  }
                },
              ),
              _menuOption(
                icon: 'assets/icon/edit.svg',
                iconColor: const Color(0xFFA78BFA),
                backgroundColor: const Color(
                  0xFFA78BFA,
                ).withValues(alpha: 0.12),
                label: 'Rename',
                onTap: () {
                  Navigator.pop(context);
                  showRenameSheet(
                    context,
                    renameItem,
                    libraryController,
                    afterRename: afterRename,
                  );
                },
              ),
              _menuOption(
                icon: 'assets/icon/delete.svg',
                iconColor: const Color(0xFFF87171),
                backgroundColor: const Color(
                  0xFFF87171,
                ).withValues(alpha: 0.12),
                label: 'Delete',
                onTap: () {
                  Navigator.pop(context);
                  onDelete?.call();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  static Widget _menuOption({
    required String icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
    required Color backgroundColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        child: Row(
          children: [
            Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: backgroundColor,
              ),
              child: Center(child: SvgPicture.asset(icon)),
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: label == 'Delete'
                    ? const Color(0xFFEF4444)
                    : AppColors.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void showRenameSheet(
    BuildContext context,
    LibraryItem item,
    LibraryController libraryController, {
    Future<void> Function()? afterRename,
  }) {
    final textController = TextEditingController(text: item.title);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: Container(
            margin: const EdgeInsets.all(16),
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
                  'Rename',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: textController,
                  autofocus: true,
                  style: TextStyle(fontSize: 14, color: AppColors.textColor),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.textColor.withValues(alpha: 0.06),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(sheetContext),
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: AppColors.textColor.withValues(alpha: 0.08),
                          ),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColor.withValues(
                                  alpha: 0.60,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final newTitle = textController.text.trim();
                          if (newTitle.isEmpty) {
                            showCustomSnackBar(
                              'Please enter a title',
                              isError: true,
                              getXSnackBar: true,
                            );
                            return;
                          }
                          Navigator.pop(sheetContext);
                          final result = await libraryController.renameLibraryItem(
                            id: item.id,
                            type: item.type,
                            title: newTitle,
                          );
                          Future.microtask(() {
                            showCustomSnackBar(
                              result.message,
                              isError: !result.success,
                              getXSnackBar: true,
                            );
                          });
                          if (result.success) {
                            if (afterRename != null) {
                              await afterRename();
                            } else {
                              await libraryController.fetchLibraryOverview();
                            }
                          }
                        },
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget noteTile(
    BuildContext context,
    LibraryController c,
    LibraryNoteModel n, {
    Future<void> Function()? afterDelete,
    Future<void> Function()? afterRename,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppColors.cardColor,
        border: Border.all(
          color: AppColors.borderColor,
          width: 1,
        ),
        boxShadow: AppColors.isDark ? [] : [
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF6366F1).withValues(alpha: 0.15),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icon/notes.svg',
                width: 22,
                height: 22,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF6366F1),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  n.title.isEmpty ? 'Untitled' : n.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notePreview(n.text),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.35,
                    color: AppColors.textColor.withValues(alpha: 0.45),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      subjectLabel(n.subject),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6366F1),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(
                        Icons.circle,
                        size: 3,
                        color: AppColors.textColor.withValues(alpha: 0.25),
                      ),
                    ),
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: AppColors.textColor.withValues(alpha: 0.35),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      dateLabel(n.createdAt),
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textColor.withValues(alpha: 0.35),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => showItemActionsMenu(
              context,
              libraryController: c,
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: const Color(0xFF6366F1).withValues(alpha: 0.09),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icon/notes.svg',
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF6366F1),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              title: n.title.isEmpty ? 'Untitled' : n.title,
              subtitle:
                  '${subjectLabel(n.subject)} · ${dateLabel(n.createdAt)}',
              renameItem: LibraryItem(
                id: n.id,
                title: n.title.isEmpty ? 'Untitled' : n.title,
                subject: subjectLabel(n.subject),
                subjectColor: const Color(0xFF6366F1),
                date: dateLabel(n.createdAt),
                size: 'Note',
                svgIcon: 'assets/icon/notes.svg',
                iconColor: const Color(0xFF6366F1),
                type: 'note',
              ),
              afterRename: afterRename,
              onDelete: () async {
                final result = await c.deleteNote(n.id);
                if (!context.mounted) return;
                Future.microtask(() {
                  showCustomSnackBar(
                    result.message,
                    isError: !result.success,
                    getXSnackBar: true,
                  );
                });
                if (result.success) await afterDelete?.call();
              },
            ),
            child: Icon(
              Icons.more_vert,
              color: AppColors.textColor.withValues(alpha: 0.35),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  static Widget imageTile(
    BuildContext context,
    LibraryController c,
    LibraryImageModel img, {
    Future<void> Function()? afterDelete,
    Future<void> Function()? afterRename,
  }) {
    final accent = subjectAccentColor(img.subject);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppColors.cardColor,
        border: Border.all(
          color: AppColors.borderColor,
          width: 1,
        ),
        boxShadow: AppColors.isDark ? [] : [
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 52,
              height: 52,
              child: img.imageUrl.isEmpty
                  ? ColoredBox(
                      color: accent.withValues(alpha: 0.12),
                      child: Icon(
                        Icons.image_outlined,
                        color: accent,
                        size: 26,
                      ),
                    )
                  : CachedNetworkImage(
                      imageUrl: img.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => ColoredBox(
                        color: AppColors.textColor.withValues(alpha: 0.06),
                        child: const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFFA78BFA),
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (_, __, ___) => ColoredBox(
                        color: accent.withValues(alpha: 0.12),
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: accent,
                          size: 26,
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  img.title.isEmpty ? 'Untitled' : img.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      subjectLabel(img.subject),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: accent,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(
                        Icons.circle,
                        size: 3,
                        color: AppColors.textColor.withValues(alpha: 0.25),
                      ),
                    ),
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: AppColors.textColor.withValues(alpha: 0.35),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      dateLabel(img.createdAt),
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textColor.withValues(alpha: 0.35),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(
                        Icons.circle,
                        size: 3,
                        color: AppColors.textColor.withValues(alpha: 0.25),
                      ),
                    ),
                    Text(
                      formatFileSize(img.fileSizeBytes),
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textColor.withValues(alpha: 0.35),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => showItemActionsMenu(
              context,
              libraryController: c,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: img.imageUrl.isEmpty
                      ? ColoredBox(
                          color: accent.withValues(alpha: 0.12),
                          child: Icon(
                            Icons.image_outlined,
                            color: accent,
                            size: 22,
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: img.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => ColoredBox(
                            color: AppColors.textColor.withValues(alpha: 0.06),
                            child: const Center(
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFFA78BFA),
                                ),
                              ),
                            ),
                          ),
                          errorWidget: (_, __, ___) => ColoredBox(
                            color: accent.withValues(alpha: 0.12),
                            child: Icon(
                              Icons.broken_image_outlined,
                              color: accent,
                              size: 22,
                            ),
                          ),
                        ),
                ),
              ),
              title: img.title.isEmpty ? 'Untitled' : img.title,
              subtitle:
                  '${subjectLabel(img.subject)} · ${formatFileSize(img.fileSizeBytes)}',
              renameItem: LibraryItem(
                id: img.id,
                title: img.title.isEmpty ? 'Untitled' : img.title,
                subject: subjectLabel(img.subject),
                subjectColor: accent,
                date: dateLabel(img.createdAt),
                size: formatFileSize(img.fileSizeBytes),
                svgIcon: 'assets/icon/uplaod_image.svg',
                iconColor: const Color(0xFF10B981),
                type: 'image',
              ),
              afterRename: afterRename,
              onDelete: () async {
                final result = await c.deleteImage(img.id);
                if (!context.mounted) return;
                Future.microtask(() {
                  showCustomSnackBar(
                    result.message,
                    isError: !result.success,
                    getXSnackBar: true,
                  );
                });
                if (result.success) await afterDelete?.call();
              },
            ),
            child: Icon(
              Icons.more_vert,
              color: AppColors.textColor.withValues(alpha: 0.35),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  static Widget fileTile(
    BuildContext context,
    LibraryController c,
    LibraryFileModel file, {
    Future<void> Function()? afterDelete,
    Future<void> Function()? afterRename,
  }) {
    const fileAccent = Color(0xFF10B981);
    final accent = subjectAccentColor(file.subject);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppColors.cardColor,
        border: Border.all(
          color: AppColors.borderColor,
          width: 1,
        ),
        boxShadow: AppColors.isDark ? [] : [
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: fileAccent.withValues(alpha: 0.15),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icon/upload_file.svg',
                width: 22,
                height: 22,
                colorFilter: const ColorFilter.mode(
                  fileAccent,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.title.isEmpty ? 'Untitled' : file.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                ),
                if (file.originalFilename.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    file.originalFilename,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textColor.withValues(alpha: 0.35),
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      subjectLabel(file.subject),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: accent,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(
                        Icons.circle,
                        size: 3,
                        color: AppColors.textColor.withValues(alpha: 0.25),
                      ),
                    ),
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: AppColors.textColor.withValues(alpha: 0.35),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      dateLabel(file.createdAt),
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textColor.withValues(alpha: 0.35),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(
                        Icons.circle,
                        size: 3,
                        color: AppColors.textColor.withValues(alpha: 0.25),
                      ),
                    ),
                    Text(
                      formatFileSize(file.fileSizeBytes),
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textColor.withValues(alpha: 0.35),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => showItemActionsMenu(
              context,
              libraryController: c,
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: fileAccent.withValues(alpha: 0.15),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icon/upload_file.svg',
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      fileAccent,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              title: file.title.isEmpty ? 'Untitled' : file.title,
              subtitle:
                  '${subjectLabel(file.subject)} · ${formatFileSize(file.fileSizeBytes)}',
              renameItem: LibraryItem(
                id: file.id,
                title: file.title.isEmpty ? 'Untitled' : file.title,
                subject: subjectLabel(file.subject),
                subjectColor: accent,
                date: dateLabel(file.createdAt),
                size: formatFileSize(file.fileSizeBytes),
                svgIcon: 'assets/icon/upload_file.svg',
                iconColor: fileAccent,
                type: 'upload',
              ),
              afterRename: afterRename,
              onDelete: () async {
                final result = await c.deleteFile(file.id);
                if (!context.mounted) return;
                Future.microtask(() {
                  showCustomSnackBar(
                    result.message,
                    isError: !result.success,
                    getXSnackBar: true,
                  );
                });
                if (result.success) await afterDelete?.call();
              },
            ),
            child: Icon(
              Icons.more_vert,
              color: AppColors.textColor.withValues(alpha: 0.35),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
