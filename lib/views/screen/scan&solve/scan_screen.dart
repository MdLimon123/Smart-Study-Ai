import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/scan_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

/// [controllerTag] must be unique per route. Main shell tab and [Get.to] modal
/// each need their own [ScanController] — otherwise [Get.delete] from the modal
/// disposes the tab controller and breaks the bottom bar scan tab.
class ScanScreen extends StatefulWidget {
  final bool isActive;
  final String controllerTag;

  const ScanScreen({
    super.key,
    this.isActive = true,
    this.controllerTag = ScanControllerTags.mainTab,
  });

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  late final ScanController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      ScanController(isActive: widget.isActive),
      tag: widget.controllerTag,
    );
  }

  @override
  void didUpdateWidget(covariant ScanScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (!controller.isClosed) {
        controller.setActive(widget.isActive);
      }
    }
  }

  @override
  void dispose() {
    Get.delete<ScanController>(tag: widget.controllerTag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() {
        if (controller.isAnalyzing.value) {
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: _buildAnalyzingView(),
              ),
            ),
          );
        }

        return Stack(
          children: [
            // ─── Camera Preview Full Screen ───
            Positioned.fill(
              child: _buildCameraPreviewFullScreen(),
            ),

            // ─── Top App Bar Overlay ───
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                bottom: false,
                child: _buildTopBar(),
              ),
            ),

            // ─── Scan Target Box (Centered) ───
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: _buildScanFocusArea(),
              ),
            ),

            // ─── Bottom Controls Container (Glassmorphic) ───
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildBottomControls(),
            ),
          ],
        );
      }),
    );
  }

  // ─── Top App Bar ───
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Scan & Solve",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black38,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "3 scans remaining today",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.75),
                    shadows: const [
                      Shadow(
                        color: Colors.black38,
                        offset: Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Camera Preview Full Screen ───
  Widget _buildCameraPreviewFullScreen() {
    return Obx(() {
      if (controller.hasCameraError.value) {
        return _buildPlaceholderFullScreen("Camera not available");
      }
      if (!controller.isCameraReady.value ||
          controller.cameraController == null) {
        return _buildPlaceholderFullScreen(null);
      }
      return SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: controller.cameraController!.value.previewSize?.height ?? 1,
            height: controller.cameraController!.value.previewSize?.width ?? 1,
            child: CameraPreview(controller.cameraController!),
          ),
        ),
      );
    });
  }

  // ─── Full Screen Loading/Error Placeholder ───
  Widget _buildPlaceholderFullScreen(String? message) {
    return Container(
      color: const Color(0xFF09090E),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/icon/camera_fill.svg',
              colorFilter: ColorFilter.mode(
                Colors.white.withValues(alpha: 0.3),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              message ?? "Point camera at your problem",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.35),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Scan Focus Box (Middle of the screen) ───
  Widget _buildScanFocusArea() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        height: 280,
        width: double.infinity,
        child: CustomPaint(
          painter: _CornerBracketPainter(
            color: const Color(0xFFA78BFA),
            cornerLength: 30,
            strokeWidth: 3,
            borderRadius: 16,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildScanLine(),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Scan Line Animation ───
  Widget _buildScanLine() {
    return AnimatedBuilder(
      animation: controller.scanLineAnimation,
      builder: (context, child) {
        return Positioned(
          top: 20 + (controller.scanLineAnimation.value * 220),
          left: 0,
          right: 0,
          child: Center(child: child!),
        );
      },
      child: Container(
        height: 2,
        width: 180,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFA78BFA).withValues(alpha: 0.0),
              const Color(0xFFA78BFA),
              const Color(0xFFA78BFA).withValues(alpha: 0.0),
            ],
          ),
          borderRadius: BorderRadius.circular(2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFA78BFA).withValues(alpha: 0.4),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }

  // ─── Bottom Controls Panel ───
  Widget _buildBottomControls() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(32),
        topRight: Radius.circular(32),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.65), // Stronger dark overlay for premium high contrast
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pull indicator visual accent
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildSubjectSectionCustom(),
              const SizedBox(height: 16),
              _buildScanButtonCustom(),
              const SizedBox(height: 12),
              _buildUploadOptionsCustom(),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Custom Gallery & File Picker Row ───
  Widget _buildUploadOptionsCustom() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: controller.pickAndScanImage,
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_library_outlined,
                    color: Colors.white.withValues(alpha: 0.85),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Gallery",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: controller.pickAndScanFile,
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.picture_as_pdf_outlined,
                    color: Colors.white.withValues(alpha: 0.85),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Upload File",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Bottom Subject Tag List ───
  Widget _buildSubjectSectionCustom() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select subject (required)",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.50),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 38,
          child: Obx(
            () {
              final selected = controller.selectedSubject.value;
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.subjects.length,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final subject = controller.subjects[index];
                  final isSelected = selected == subject;
                  return GestureDetector(
                    onTap: () => controller.selectSubject(isSelected ? null : subject),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFA78BFA).withValues(alpha: 0.25)
                            : Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFA78BFA)
                              : Colors.white.withValues(alpha: 0.12),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        subject,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? const Color(0xFFA78BFA)
                              : Colors.white.withValues(alpha: 0.70),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // ─── Custom Scan Button ───
  Widget _buildScanButtonCustom() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: Obx(() {
        final isReady = controller.isCameraReady.value;
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: isReady
                ? const LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                  )
                : null,
            color: isReady ? null : Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            boxShadow: isReady
                ? [
                    BoxShadow(
                      color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: ElevatedButton.icon(
            onPressed: isReady ? controller.captureAndScan : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: SvgPicture.asset(
              'assets/icon/camera_fill.svg',
              colorFilter: ColorFilter.mode(
                isReady ? Colors.white : Colors.white.withValues(alpha: 0.35),
                BlendMode.srcIn,
              ),
            ),
            label: Text(
              "Scan Problem",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isReady ? Colors.white : Colors.white.withValues(alpha: 0.35),
              ),
            ),
          ),
        );
      }),
    );
  }


  // ─── Analyzing View ───
  Widget _buildAnalyzingView() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        controller.progressController,
        controller.pulseController,
      ]),
      builder: (context, _) {
        final percent = (controller.progressAnimation.value * 100).round();
        return Column(
          children: [
            SizedBox(
              height: 160,
              width: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.expand(
                    child: CustomPaint(
                      painter: _CircularProgressPainter(
                        progress: controller.progressAnimation.value,
                        backgroundColor:
                            const Color(0xFFA78BFA).withValues(alpha: 0.12),
                        progressColor: const Color(0xFFA78BFA),
                        strokeWidth: 8,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ScaleTransition(
                        scale: controller.pulseAnimation,
                        child: SvgPicture.asset('assets/icon/loader.svg'),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$percent%',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(
              "Analyzing...",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Text(
                controller.analyzingSteps[controller.currentStep.value],
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFA78BFA),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Obx(
                () => Column(
                  children: List.generate(
                    controller.analyzingSteps.length,
                    (index) {
                      final isActive =
                          index <= controller.currentStep.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: Row(
                          children: [
                            Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isActive
                                    ? const Color(0xFFA78BFA)
                                    : AppColors.textColor
                                        .withValues(alpha: 0.15),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Text(
                              controller.analyzingSteps[index],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isActive
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isActive
                                    ? AppColors.textColor
                                    : AppColors.textColor
                                        .withValues(alpha: 0.30),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─── Corner Bracket Painter ───
class _CornerBracketPainter extends CustomPainter {
  final Color color;
  final double cornerLength;
  final double strokeWidth;
  final double borderRadius;

  _CornerBracketPainter({
    required this.color,
    required this.cornerLength,
    required this.strokeWidth,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final r = borderRadius;
    final cl = cornerLength;
    final w = size.width;
    final h = size.height;

    final topLeft = Path()
      ..moveTo(0, cl + r)
      ..lineTo(0, r)
      ..arcToPoint(Offset(r, 0), radius: Radius.circular(r))
      ..lineTo(cl + r, 0);
    canvas.drawPath(topLeft, paint);

    final topRight = Path()
      ..moveTo(w - cl - r, 0)
      ..lineTo(w - r, 0)
      ..arcToPoint(Offset(w, r), radius: Radius.circular(r))
      ..lineTo(w, cl + r);
    canvas.drawPath(topRight, paint);

    final bottomLeft = Path()
      ..moveTo(0, h - cl - r)
      ..lineTo(0, h - r)
      ..arcToPoint(Offset(r, h), radius: Radius.circular(r))
      ..lineTo(cl + r, h);
    canvas.drawPath(bottomLeft, paint);

    final bottomRight = Path()
      ..moveTo(w - cl - r, h)
      ..lineTo(w - r, h)
      ..arcToPoint(Offset(w, h - r), radius: Radius.circular(r))
      ..lineTo(w, h - cl - r);
    canvas.drawPath(bottomRight, paint);
  }

  @override
  bool shouldRepaint(covariant _CornerBracketPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.cornerLength != cornerLength ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.borderRadius != borderRadius;
  }
}

// ─── Circular Progress Painter ───
class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
