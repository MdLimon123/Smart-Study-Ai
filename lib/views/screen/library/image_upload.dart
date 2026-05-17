import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/library_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


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



class ImageUpload extends StatefulWidget {
  const ImageUpload({super.key});

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {

  
  late final LibraryController _libraryController;
  final _picker = ImagePicker();

  final _titleController = TextEditingController();
  int _selectedSubject = 0;
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<LibraryController>()) {
      Get.put(LibraryController());
    }
    _libraryController = Get.find<LibraryController>();
  }

  Future<void> _pickImage() async {
    final x = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 88,
    );
    if (x == null) return;
    setState(() => _pickedImage = File(x.path));
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    final title = _titleController.text;
    final subject = _subjects[_selectedSubject].label;
    if (title.trim().isEmpty) {
      showCustomSnackBar(
        'Please enter a title',
        isError: true,
        getXSnackBar: true,
      );
      return;
    }
    if (_pickedImage == null) {
      showCustomSnackBar(
        'Please select an image',
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
      final result = await _libraryController.uploadImage(
        subject: subject,
        title: title,
        imageFile: _pickedImage!,
      );
      if (Get.isDialogOpen ?? false) {
        Get.back(closeOverlays: false);
      }
      if (result.success && mounted) {
        Get.back(closeOverlays: false);
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
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              "Upload Image",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textColor,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: _save,
              child: Container(
                width: 82,
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
                    Icon(Icons.check, color: AppColors.textColor, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      "Save",
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
              // Document file label
              Text(
                "DOCUMENT FILE",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                  color: AppColors.textColor.withValues(alpha: 0.35),
                ),
              ),
              const SizedBox(height: 10),

              // Upload area
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 140),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: AppColors.textColor.withValues(alpha: 0.04),
                    border: Border.all(
                      color: const Color(0xFF10B981).withValues(alpha: 0.25),
                    ),
                  ),
                  child: _pickedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.file(
                              _pickedImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF10B981)
                                    .withValues(alpha: 0.12),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/icon/upload_file.svg',
                                  width: 22,
                                  height: 22,
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFF10B981),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Tap to select image',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'JPG, PNG, GIF, WEBP supported',
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    AppColors.textColor.withValues(alpha: 0.35),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Title label
              Text(
                "TITLE",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                  color: AppColors.textColor.withValues(alpha: 0.35),
                ),
              ),
              const SizedBox(height: 10),

              // Title field
              TextField(
                controller: _titleController,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textColor,
                ),
                decoration: InputDecoration(
                  hintText: 'e.g. Biology Textbook Ch3',
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
                              Image.asset(
                                subject.image,
                                width: 16,
                                height: 16,
                              ),
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
              const SizedBox(height: 24),

              // Info banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: const Color(0xFF10B981).withValues(alpha: 0.08),
                  border: Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: 0.20),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/icon/upload_file.svg',
                      width: 18,
                      height: 18,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF10B981),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Uploaded files are stored securely and available from any device. Premium users get unlimited storage and export options.',
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.5,
                          color: AppColors.textColor.withValues(alpha: 0.50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



}