import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/library_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_text_field.dart';
import 'package:flutter_extension/views/screen/library/create_note_screen.dart';
import 'package:flutter_extension/views/screen/library/image_upload.dart';
import 'package:flutter_extension/views/screen/library/problem_solution_screen.dart';
import 'package:flutter_extension/views/screen/library/uplaod_folder.dart';
import 'package:flutter_extension/views/screen/library/upload_file.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class LibraryItem {
  final String title;
  final String subject;
  final Color subjectColor;
  final String date;
  final String size;
  final IconData? icon;
  final String? svgIcon;
  final Color iconColor;
  final String type;

  LibraryItem({
    required this.title,
    required this.subject,
    required this.subjectColor,
    required this.date,
    required this.size,
    this.icon,
    this.svgIcon,
    required this.iconColor,
    required this.type,
  });
}

// ─── Sample Data ───
final List<LibraryItem> allItems = [
  LibraryItem(
    title: 'Calculus Chapter 5',
    subject: 'Mathematics',
    subjectColor: const Color(0xFF6366F1),
    date: 'Today',
    size: '12 KB',
    svgIcon: 'assets/icon/math.svg',
    iconColor: const Color(0xFF6366F1),
    type: 'note',
  ),
  LibraryItem(
    title: 'Chemistry Lab Notes',
    subject: 'Chemistry',
    subjectColor: const Color(0xFF10B981),
    date: 'Yesterday',
    size: '2.4 MB',
    icon: Icons.science,
    iconColor: Color(0xFF10B981),
    type: 'note',
  ),
  LibraryItem(
    title: "Newton's Laws Summary",
    subject: 'Physics',
    subjectColor: Color(0xFFF59E0B),
    date: 'Feb 22',
    size: '8 KB',
    icon: Icons.bolt,
    iconColor: Color(0xFFF59E0B),
    type: 'note',
  ),
  LibraryItem(
    title: 'Biology Textbook Ch3',
    subject: 'Biology',
    subjectColor: Color(0xFFEF4444),
    date: 'Feb 20',
    size: '4.1 MB',
    icon: Icons.rocket_launch,
    iconColor: Color(0xFFEF4444),
    type: 'upload',
  ),
  LibraryItem(
    title: 'WWII Timeline',
    subject: 'History',
    subjectColor: Color(0xFF8B5CF6),
    date: 'Feb 18',
    size: '15 KB',
    icon: Icons.menu_book,
    iconColor: Color(0xFF8B5CF6),
    type: 'image',
  ),
  LibraryItem(
    title: 'Organic Structure Diagrams',
    subject: 'Chemistry',
    subjectColor: Color(0xFF10B981),
    date: 'Feb 15',
    size: '1.8 MB',
    icon: Icons.science,
    iconColor: Color(0xFF10B981),
    type: 'image',
  ),
  LibraryItem(
    title: 'Physics Lab Report',
    subject: 'Physics',
    subjectColor: Color(0xFFF59E0B),
    date: 'Feb 12',
    size: '3.2 MB',
    icon: Icons.bolt,
    iconColor: Color(0xFFF59E0B),
    type: 'upload',
  ),
];

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  int _selectedTab = 0; // 0=All, 1=Notes, 2=Images, 3=Uploads, 4=Folder
  final List<String> _tabs = ['All', 'Notes', 'Images', 'Uploads', 'Folder'];
  late final LibraryController _libraryController;

  @override
  void initState() {
    super.initState();
    _libraryController = Get.find<LibraryController>();
  }

  String _folderDateLabel(String iso) {
    final t = iso.indexOf('T');
    if (t > 0) return iso.substring(0, t);
    if (iso.length >= 10) return iso.substring(0, 10);
    return iso.isEmpty ? '—' : iso;
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    final kb = bytes / 1024;
    if (kb < 1024) {
      return kb < 10 ? '${kb.toStringAsFixed(1)} KB' : '${kb.round()} KB';
    }
    final mb = kb / 1024;
    return mb < 10 ? '${mb.toStringAsFixed(1)} MB' : '${mb.round()} MB';
  }

  Color _subjectAccentColor(String raw) {
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

  List<LibraryItem> get _filteredItems {
    switch (_selectedTab) {
      case 1:
        return allItems.where((e) => e.type == 'note').toList();
      case 2:
        return allItems.where((e) => e.type == 'image').toList();
      case 3:
        return allItems.where((e) => e.type == 'upload').toList();
      case 4:
        return allItems.where((e) => e.type == 'folder').toList();
      default:
        return allItems;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: SafeArea(
        child: Column(
          children: [
            // ─── App Bar ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Text(
                    "My Library",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textColor,
                    ),
                  ),
                  const Spacer(),

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
                            "Add",
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    CustomTextField(
                      hintText: "Search materials...",
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SvgPicture.asset('assets/icon/search.svg'),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        _customContainer(
                          icon: 'assets/icon/files.svg',
                          title: "24",
                          subtitle: "Files",
                        ),
                        const SizedBox(width: 8),
                        Obx(
                          () => _customContainer(
                            icon: 'assets/icon/folder.svg',
                            title: '${_libraryController.folders.length}',
                            subtitle: 'Folders',
                          ),
                        ),
                        const SizedBox(width: 8),
                        _customContainer(
                          icon: 'assets/icon/book_mark.svg',
                          title: "12",
                          subtitle: "Bookmarks",
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    Row(
                      children: List.generate(_tabs.length, (index) {
                        final isSelected = _selectedTab == index;
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index < _tabs.length - 1 ? 8 : 0,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _selectedTab = index);
                              if (index == 1) {
                                _libraryController.fetchNotes();
                              }
                              if (index == 2) {
                                _libraryController.fetchImages();
                              }
                              if (index == 3) {
                                _libraryController.fetchFiles();
                              }
                              if (index == 4) {
                                _libraryController.fetchFolders();
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: isSelected
                                    ? const Color(
                                        0xFFA78BFA,
                                      ).withValues(alpha: 0.20)
                                    : AppColors.textColor.withValues(
                                        alpha: 0.06,
                                      ),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(
                                          0xFFA78BFA,
                                        ).withValues(alpha: 0.30)
                                      : const Color(
                                          0xFF000000,
                                        ).withValues(alpha: 0.00),
                                ),
                              ),
                              child: Text(
                                _tabs[index],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: isSelected
                                      ? const Color(0xFFA78BFA)
                                      : AppColors.textColor.withValues(
                                          alpha: 0.45,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: _selectedTab == 4
                          ? _buildFoldersList()
                          : _selectedTab == 1
                          ? _buildNotesList()
                          : _selectedTab == 2
                          ? _buildImagesList()
                          : _selectedTab == 3
                          ? _buildFilesList()
                          : ListView.builder(
                              itemCount: _filteredItems.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                final item = _filteredItems[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 4),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: AppColors.textColor.withValues(
                                      alpha: 0.04,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: item.iconColor.withValues(
                                            alpha: 0.15,
                                          ),
                                        ),
                                        child: Center(
                                          child: item.svgIcon != null
                                              ? SvgPicture.asset(
                                                  item.svgIcon!,
                                                  width: 20,
                                                  height: 20,
                                                  colorFilter: ColorFilter.mode(
                                                    item.iconColor,
                                                    BlendMode.srcIn,
                                                  ),
                                                )
                                              : Icon(
                                                  item.icon,
                                                  color: item.iconColor,
                                                  size: 20,
                                                ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.title,
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
                                                  item.subject,
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w500,
                                                    color: item.subjectColor,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                      ),
                                                  child: Icon(
                                                    Icons.circle,
                                                    size: 3,
                                                    color: AppColors.textColor
                                                        .withValues(
                                                          alpha: 0.25,
                                                        ),
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.access_time,
                                                  size: 12,
                                                  color: AppColors.textColor
                                                      .withValues(alpha: 0.35),
                                                ),
                                                const SizedBox(width: 3),
                                                Text(
                                                  item.date,
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: AppColors.textColor
                                                        .withValues(
                                                          alpha: 0.35,
                                                        ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                      ),
                                                  child: Icon(
                                                    Icons.circle,
                                                    size: 3,
                                                    color: AppColors.textColor
                                                        .withValues(
                                                          alpha: 0.25,
                                                        ),
                                                  ),
                                                ),
                                                Text(
                                                  item.size,
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: AppColors.textColor
                                                        .withValues(
                                                          alpha: 0.35,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () =>
                                            _showItemMenu(context, item),
                                        child: Icon(
                                          Icons.more_vert,
                                          color: AppColors.textColor.withValues(
                                            alpha: 0.35,
                                          ),
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
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

  String _subjectLabel(String raw) {
    final s = raw.trim().toLowerCase();
    if (s.isEmpty) return '—';
    return s[0].toUpperCase() + (s.length > 1 ? s.substring(1) : '');
  }

  String _notePreview(String text) {
    final t = text.trim();
    if (t.isEmpty) return 'No content';
    if (t.length <= 80) return t;
    return '${t.substring(0, 80)}…';
  }

  Widget _buildNotesList() {
    return Obx(() {
      if (_libraryController.isNotesLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFFA78BFA)),
        );
      }
      final err = _libraryController.notesError.value;
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
                    color: AppColors.textColor.withValues(alpha: 0.70),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => _libraryController.fetchNotes(),
                  child: Text(
                    'Retry',
                    style: TextStyle(
                      color: AppColors.textColor.withValues(alpha: 0.90),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      final list = _libraryController.notes;
      if (list.isEmpty) {
        return Center(
          child: Text(
            'No notes yet',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textColor.withValues(alpha: 0.45),
            ),
          ),
        );
      }
      return ListView.builder(
        itemCount: list.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final n = list[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: AppColors.textColor.withValues(alpha: 0.04),
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
                        _notePreview(n.text),
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
                            _subjectLabel(n.subject),
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
                              color: AppColors.textColor.withValues(
                                alpha: 0.25,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.access_time,
                            size: 12,
                            color: AppColors.textColor.withValues(alpha: 0.35),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            _folderDateLabel(n.createdAt),
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textColor.withValues(
                                alpha: 0.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _showLibraryActionsMenu(
                    context,
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
                        '${_subjectLabel(n.subject)} · ${_folderDateLabel(n.createdAt)}',
                    renameItem: LibraryItem(
                      title: n.title.isEmpty ? 'Untitled' : n.title,
                      subject: _subjectLabel(n.subject),
                      subjectColor: const Color(0xFF6366F1),
                      date: _folderDateLabel(n.createdAt),
                      size: 'Note',
                      svgIcon: 'assets/icon/notes.svg',
                      iconColor: const Color(0xFF6366F1),
                      type: 'note',
                    ),
                    onDelete: () async {
                      final result = await _libraryController.deleteNote(n.id);
                      if (!context.mounted) return;
                      Future.microtask(() {
                        showCustomSnackBar(
                          result.message,
                          isError: !result.success,
                          getXSnackBar: true,
                        );
                      });
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
        },
      );
    });
  }

  Widget _buildImagesList() {
    return Obx(() {
      if (_libraryController.isImagesLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFFA78BFA)),
        );
      }
      final err = _libraryController.imagesError.value;
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
                    color: AppColors.textColor.withValues(alpha: 0.70),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => _libraryController.fetchImages(),
                  child: Text(
                    'Retry',
                    style: TextStyle(
                      color: AppColors.textColor.withValues(alpha: 0.90),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      final list = _libraryController.images;
      if (list.isEmpty) {
        return Center(
          child: Text(
            'No images yet',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textColor.withValues(alpha: 0.45),
            ),
          ),
        );
      }
      return ListView.builder(
        itemCount: list.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final img = list[index];
          final accent = _subjectAccentColor(img.subject);
          return Container(
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: AppColors.textColor.withValues(alpha: 0.04),
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
                              color: AppColors.textColor.withValues(
                                alpha: 0.06,
                              ),
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
                            _subjectLabel(img.subject),
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
                              color: AppColors.textColor.withValues(
                                alpha: 0.25,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.access_time,
                            size: 12,
                            color: AppColors.textColor.withValues(alpha: 0.35),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            _folderDateLabel(img.createdAt),
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textColor.withValues(
                                alpha: 0.35,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Icon(
                              Icons.circle,
                              size: 3,
                              color: AppColors.textColor.withValues(
                                alpha: 0.25,
                              ),
                            ),
                          ),
                          Text(
                            _formatFileSize(img.fileSizeBytes),
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textColor.withValues(
                                alpha: 0.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _showLibraryActionsMenu(
                    context,
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
                                  color: AppColors.textColor.withValues(
                                    alpha: 0.06,
                                  ),
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
                        '${_subjectLabel(img.subject)} · ${_formatFileSize(img.fileSizeBytes)}',
                    renameItem: LibraryItem(
                      title: img.title.isEmpty ? 'Untitled' : img.title,
                      subject: _subjectLabel(img.subject),
                      subjectColor: accent,
                      date: _folderDateLabel(img.createdAt),
                      size: _formatFileSize(img.fileSizeBytes),
                      svgIcon: 'assets/icon/uplaod_image.svg',
                      iconColor: const Color(0xFF10B981),
                      type: 'image',
                    ),
                    onDelete: () async {
                      final result = await _libraryController.deleteImage(
                        img.id,
                      );
                      if (!context.mounted) return;
                      Future.microtask(() {
                        showCustomSnackBar(
                          result.message,
                          isError: !result.success,
                          getXSnackBar: true,
                        );
                      });
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
        },
      );
    });
  }

  Widget _buildFilesList() {
    const fileAccent = Color(0xFF10B981);
    return Obx(() {
      if (_libraryController.isFilesLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFFA78BFA)),
        );
      }
      final err = _libraryController.filesError.value;
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
                    color: AppColors.textColor.withValues(alpha: 0.70),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => _libraryController.fetchFiles(),
                  child: Text(
                    'Retry',
                    style: TextStyle(
                      color: AppColors.textColor.withValues(alpha: 0.90),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      final list = _libraryController.files;
      if (list.isEmpty) {
        return Center(
          child: Text(
            'No uploads yet',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textColor.withValues(alpha: 0.45),
            ),
          ),
        );
      }
      return ListView.builder(
        itemCount: list.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final file = list[index];
          final accent = _subjectAccentColor(file.subject);
          return Container(
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: AppColors.textColor.withValues(alpha: 0.04),
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
                            _subjectLabel(file.subject),
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
                              color: AppColors.textColor.withValues(
                                alpha: 0.25,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.access_time,
                            size: 12,
                            color: AppColors.textColor.withValues(alpha: 0.35),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            _folderDateLabel(file.createdAt),
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textColor.withValues(
                                alpha: 0.35,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Icon(
                              Icons.circle,
                              size: 3,
                              color: AppColors.textColor.withValues(
                                alpha: 0.25,
                              ),
                            ),
                          ),
                          Text(
                            _formatFileSize(file.fileSizeBytes),
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textColor.withValues(
                                alpha: 0.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _showLibraryActionsMenu(
                    context,
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
                        '${_subjectLabel(file.subject)} · ${_formatFileSize(file.fileSizeBytes)}',
                    renameItem: LibraryItem(
                      title: file.title.isEmpty ? 'Untitled' : file.title,
                      subject: _subjectLabel(file.subject),
                      subjectColor: accent,
                      date: _folderDateLabel(file.createdAt),
                      size: _formatFileSize(file.fileSizeBytes),
                      svgIcon: 'assets/icon/upload_file.svg',
                      iconColor: fileAccent,
                      type: 'upload',
                    ),
                    onDelete: () async {
                      final result = await _libraryController.deleteFile(
                        file.id,
                      );
                      if (!context.mounted) return;
                      Future.microtask(() {
                        showCustomSnackBar(
                          result.message,
                          isError: !result.success,
                          getXSnackBar: true,
                        );
                      });
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
        },
      );
    });
  }

  Widget _buildFoldersList() {
    return Obx(() {
      if (_libraryController.isFoldersLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFFA78BFA)),
        );
      }
      final err = _libraryController.foldersError.value;
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
                    color: AppColors.textColor.withValues(alpha: 0.70),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => _libraryController.fetchFolders(),
                  child: Text(
                    'Retry',
                    style: TextStyle(
                      color: AppColors.textColor.withValues(alpha: 0.90),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      final list = _libraryController.folders;
      if (list.isEmpty) {
        return Center(
          child: Text(
            'No folders yet',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textColor.withValues(alpha: 0.45),
            ),
          ),
        );
      }
      return ListView.builder(
        itemCount: list.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final f = list[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: AppColors.textColor.withValues(alpha: 0.04),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFA78BFA).withValues(alpha: 0.15),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icon/folder.svg',
                      width: 22,
                      height: 22,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFA78BFA),
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
                        f.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Created · ${_folderDateLabel(f.createdAt)}',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textColor.withValues(alpha: 0.35),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _showLibraryActionsMenu(
                    context,
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: const Color(0xFFA78BFA).withValues(alpha: 0.09),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icon/folder.svg',
                          width: 20,
                          height: 20,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFFA78BFA),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    title: f.name,
                    subtitle: 'Created · ${_folderDateLabel(f.createdAt)}',
                    renameItem: LibraryItem(
                      title: f.name,
                      subject: 'Folder',
                      subjectColor: const Color(0xFFA78BFA),
                      date: _folderDateLabel(f.createdAt),
                      size: 'Folder',
                      svgIcon: 'assets/icon/folder.svg',
                      iconColor: const Color(0xFFA78BFA),
                      type: 'folder',
                    ),
                    onDelete: () async {
                      final result = await _libraryController.deleteFolder(
                        f.id,
                      );
                      if (!context.mounted) return;
                      Future.microtask(() {
                        showCustomSnackBar(
                          result.message,
                          isError: !result.success,
                          getXSnackBar: true,
                        );
                      });
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
        },
      );
    });
  }

  void _showItemMenu(BuildContext context, LibraryItem item) {
    _showLibraryActionsMenu(
      context,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: const Color(0xFFA78BFA).withValues(alpha: 0.09),
        ),
        child: Center(
          child: item.svgIcon != null
              ? SvgPicture.asset(
                  item.svgIcon!,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    item.iconColor,
                    BlendMode.srcIn,
                  ),
                )
              : Icon(item.icon, color: item.iconColor, size: 20),
        ),
      ),
      title: item.title,
      subtitle: '${item.subject} · ${item.size}',
      renameItem: item,
    );
  }

  void _showLibraryActionsMenu(
    BuildContext context, {
    required Widget leading,
    required String title,
    required String subtitle,
    required LibraryItem renameItem,
    Future<void> Function()? onDelete,
  }) {
    showModalBottomSheet(
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
                icon: "assets/icon/visiable.svg",
                iconColor: const Color(0xFF60A5FA),
                backgroundColor: const Color(
                  0xFF60A5FA,
                ).withValues(alpha: 0.12),
                label: 'Open',
                onTap: () {
                  Get.to(() => const ProblemSolutionScreen());
                },
              ),
              _menuOption(
                icon: "assets/icon/edit.svg",
                iconColor: const Color(0xFFA78BFA),
                backgroundColor: const Color(
                  0xFFA78BFA,
                ).withValues(alpha: 0.12),
                label: 'Rename',
                onTap: () {
                  Navigator.pop(context);
                  _showRenameSheet(context, renameItem);
                },
              ),
              _menuOption(
                icon: "assets/icon/delete.svg",
                iconColor: const Color(0xFFF87171),
                backgroundColor: const Color(
                  0xFFF87171,
                ).withValues(alpha: 0.12),
                label: 'Delete',
                onTap: () {
                  Navigator.pop(context);
                  final pending = onDelete;
                  if (pending != null) {
                    pending();
                  }
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showAddToLibrarySheet(BuildContext context) {
    showModalBottomSheet(
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
                    icon: "assets/icon/notes.svg",
                    label: 'Create Note',
                    borderColor: const Color(0xFFA78BFA),
                    iconColor: const Color(0xFF6366F1),
                    onTap: () {
                      Get.to(() => const CreateNoteScreen());
                    },
                  ),
                  const SizedBox(width: 12),
                  _addOption(
                    backgroundColor: const Color(0xFF60A5FA),
                    icon: "assets/icon/uplaod_image.svg",
                    label: 'Upload Image',
                    borderColor: const Color(0xFF60A5FA),
                    iconColor: const Color(0xFF10B981),
                    onTap: () {
                      Get.to(() => const ImageUpload());
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _addOption(
                    backgroundColor: const Color(0xFF34D399),
                    icon: "assets/icon/upload_file.svg",
                    label: 'Upload File',
                    borderColor: const Color(0xFF34D399),
                    iconColor: const Color(0xFFF59E0B),
                    onTap: () {
                      Get.to(() => const UploadFile());
                    },
                  ),
                  const SizedBox(width: 12),
                  _addOption(
                    backgroundColor: const Color(0xFFF59E0B),
                    icon: "assets/icon/folder.svg",
                    label: 'New Folder',
                    borderColor: const Color(0xFFF59E0B),
                    iconColor: const Color(0xFFF59E0B),
                    onTap: () {
                      Get.to(() => const UplaodFolder());
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

  void _showRenameSheet(BuildContext context, LibraryItem item) {
    final controller = TextEditingController(text: item.title);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
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
                  controller: controller,
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
                        onTap: () => Navigator.pop(context),
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
                        onTap: () {
                          Navigator.pop(context);
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

  Widget _menuOption({
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

  _customContainer({
    required String icon,
    required String title,
    required String subtitle,
  }) {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: AppColors.textColor.withValues(alpha: 0.05),
          border: Border.all(
            color: AppColors.textColor.withValues(alpha: 0.06),
          ),
        ),
        child: Column(
          children: [
            SvgPicture.asset(icon),
            const SizedBox(height: 7),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor.withValues(alpha: 0.40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
