import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/library_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class _Subject {
  final String label;
  final String image;
  final Color color;
  final Color textColor;

  const _Subject({
    required this.label,
    required this.image,
    required this.color,
    required this.textColor,
  });
}

class UplaodFolder extends StatefulWidget {
  const UplaodFolder({super.key});

  @override
  State<UplaodFolder> createState() => _UplaodFolderState();
}

class _UplaodFolderState extends State<UplaodFolder> {
  late final LibraryController _libraryController;

  final _nameController = TextEditingController();
  int _selectedColor = 0;
  int _selectedSubject = 0;

  final List<Color> _folderColors = [
    const Color(0xFF7C3AED),
    const Color(0xFF3B82F6),
    const Color(0xFF10B981),
    const Color(0xFFF59E0B),
    const Color(0xFFEF4444),
    const Color(0xFFEC4899),
    const Color(0xFF06B6D4),
    const Color(0xFFF97316),
    const Color(0xFF38BDF8),
  ];

  final List<_Subject> _subjects = [
    _Subject(
      label: 'Mathematics',
      image: 'assets/images/math.png',
      color: const Color(0xFFA78BFA).withValues(alpha: 0.13),
      textColor: const Color(0xFFA78BFA),
    ),
    const _Subject(
      label: 'Physics',
      image: 'assets/images/phy.png',
      color: Color(0xFFF59E0B),
      textColor: Color(0xFFF59E0B),
    ),
    const _Subject(
      label: 'Chemistry',
      image: 'assets/images/che.png',
      color: Color(0xFF10B981),
      textColor: Color(0xFF10B981),
    ),
    const _Subject(
      label: 'Biology',
      image: 'assets/images/brian.png',
      color: Color(0xFFEF4444),
      textColor: Color(0xFFEF4444),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _libraryController = Get.find<LibraryController>();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedFolderColor = _folderColors[_selectedColor];
    final selectedSubject = _subjects[_selectedSubject];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
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
                  child: Icon(Icons.arrow_back, color: AppColors.textColor),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              "New Folder",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textColor,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () async {
                final name = _nameController.text;
                if (name.trim().isEmpty) {
                  showCustomSnackBar(
                    'Please enter a folder name',
                    isError: true,
                    getXSnackBar: true,
                  );
                  return;
                }
                Get.dialog(
                  const Center(child: CircularProgressIndicator()),
                  barrierDismissible: false,
                );
                try {
                  final result = await _libraryController.createFolder(name);
                  if (Get.isDialogOpen ?? false) {
                    Get.back(closeOverlays: false);
                  }
                  if (result.success && mounted) {
                    Get.back(closeOverlays: false);
                    _libraryController.fetchLibraryOverview();
                  }
                  if (result.message.isNotEmpty) {
                    Future.microtask(() {
                      showCustomSnackBar(
                        result.message,
                        isError: !result.success,
                        getXSnackBar: true,
                      );
                    });
                  }
                } catch (_) {
                  if (Get.isDialogOpen ?? false) {
                    Get.back(closeOverlays: false);
                  }
                }
              },
              child: Container(
                width: 92,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icon/folder.svg',
                      width: 16,
                      height: 16,
                      colorFilter: ColorFilter.mode(
                        AppColors.textColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Create",
                      style: TextStyle(
                        fontSize: 14,
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Folder preview card
              Container(
                width: double.infinity,
                height: 215,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: selectedFolderColor.withValues(alpha: 0.15),
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/images/book.png',
                          width: 36,
                          height: 36,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      _nameController.text.isEmpty
                          ? 'Folder Name'
                          : _nameController.text,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _nameController.text.isEmpty
                            ? AppColors.textColor.withValues(alpha: 0.30)
                            : AppColors.textColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: selectedSubject.color.withValues(alpha: 0.15),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: selectedSubject.textColor,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            selectedSubject.label,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: selectedSubject.textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Folder name label
              Text(
                'FOLDER NAME',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                  color: AppColors.textColor.withValues(alpha: 0.35),
                ),
              ),
              const SizedBox(height: 10),

              // Folder name field
              TextField(
                controller: _nameController,
                onChanged: (_) => setState(() {}),
                style: TextStyle(fontSize: 14, color: AppColors.textColor),
                decoration: InputDecoration(
                  hintText: 'e.g. Exam Prep 2026',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: AppColors.textColor.withValues(alpha: 0.25),
                  ),
                  filled: true,
                  fillColor: AppColors.textColor.withValues(alpha: 0.04),
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
              const SizedBox(height: 24),

              // Folder color label
              Text(
                'FOLDER COLOR',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                  color: AppColors.textColor.withValues(alpha: 0.35),
                ),
              ),
              const SizedBox(height: 12),

              // Color picker
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: List.generate(_folderColors.length, (index) {
                  final color = _folderColors[index];
                  final isSelected = _selectedColor == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = index),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                      ),
                      child: isSelected
                          ? Center(
                              child: Icon(
                                Icons.check,
                                color: AppColors.textColor,
                                size: 18,
                              ),
                            )
                          : null,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),

              // Subject category label
              Text(
                'SUBJECT CATEGORY',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                  color: AppColors.textColor.withValues(alpha: 0.35),
                ),
              ),
              const SizedBox(height: 10),

              // Subject chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_subjects.length, (index) {
                    final subject = _subjects[index];
                    final isSelected = _selectedSubject == index;
                    return Padding(
                      padding: EdgeInsets.only(
                        right: index < _subjects.length - 1 ? 8 : 0,
                      ),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedSubject = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: isSelected
                                ? subject.color.withValues(alpha: 0.18)
                                : AppColors.textColor.withValues(alpha: 0.06),
                            border: Border.all(
                              color: isSelected
                                  ? subject.color.withValues(alpha: 0.40)
                                  : Colors.transparent,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(subject.image, width: 16, height: 16),
                              const SizedBox(width: 6),
                              Text(
                                subject.label,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: isSelected
                                      ? subject.textColor
                                      : AppColors.textColor.withValues(
                                          alpha: 0.45,
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
