import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/library_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
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

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  late final LibraryController _libraryController;

  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  int _selectedSubject = 0;
  int _wordCount = 0;
  int _charCount = 0;

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

  void _updateCounts(String text) {
    setState(() {
      _charCount = text.length;
      _wordCount = text.trim().isEmpty
          ? 0
          : text.trim().split(RegExp(r'\s+')).length;
    });
  }

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<LibraryController>()) {
      Get.put(LibraryController());
    }
    _libraryController = Get.find<LibraryController>();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    FocusScope.of(context).unfocus();
    final title = _titleController.text;
    final bodyText = _bodyController.text;
    final subject = _subjects[_selectedSubject].label;
    if (title.trim().isEmpty) {
      showCustomSnackBar(
        'Please enter a title',
        isError: true,
        getXSnackBar: true,
      );
      return;
    }
    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Color(0xFFA78BFA))),
      barrierDismissible: false,
    );
    try {
      final result = await _libraryController.createNote(
        title: title,
        content: bodyText,
        subject: subject,
      );
      if (Get.isDialogOpen ?? false) {
        Get.back(closeOverlays: false);
      }
      if (result.success && mounted) {
        Get.back(closeOverlays: false);
        _libraryController.fetchNotes();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 56,
        leading: InkWell(
          onTap: () => Get.back(),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.textColor.withValues(alpha: 0.04),
            ),
            child: Icon(Icons.arrow_back, color: AppColors.textColor),
          ),
        ),
        title: Text(
          'Create Note',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textColor,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _saveNote,
                  borderRadius: BorderRadius.circular(14),
                  child: Ink(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, color: AppColors.textColor, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          'Save',
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
              ),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title field
              TextFormField(
                
                controller: _titleController,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
                decoration: InputDecoration(
                  hintText: "Note title...",
                  hintStyle: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor.withValues(alpha: 0.25),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 12),

              // Subject label
              Text(
                'SUBJECT',
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
              const SizedBox(height: 18),

              // Formatting toolbar
              Row(
                children: [
                  _toolbarButton(Icons.format_bold),
                  _toolbarButton(Icons.format_italic),
                  _toolbarButton(Icons.format_list_bulleted),
                  _toolbarButton(Icons.title),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      '$_wordCount words · $_charCount chars',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textColor.withValues(alpha: 0.25),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _bodyController,
                        maxLines: null,
                        onChanged: _updateCounts,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: AppColors.textColor.withValues(alpha: 0.80),
                        ),
                        decoration: InputDecoration(
                          filled: false,
                          hintText: "Start writing your note here...",
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor.withValues(alpha: 0.25),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tips:',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor.withValues(alpha: 0.50),
                        ),
                      ),
                      const SizedBox(height: 6),
                      _tipText('Use **text** for bold'),
                      _tipText('Use _text_ for italic'),
                      _tipText('Use • for bullet points'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _toolbarButton(IconData icon) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 36,
        height: 36,
        margin: const EdgeInsets.only(right: 2),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Icon(
            icon,
            size: 20,
            color: AppColors.textColor.withValues(alpha: 0.50),
          ),
        ),
      ),
    );
  }

  Widget _tipText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Text(
        '• $text',
        style: TextStyle(
          fontSize: 12,
          color: AppColors.textColor.withValues(alpha: 0.35),
        ),
      ),
    );
  }
}
