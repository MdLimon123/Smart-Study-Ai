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
      body: SafeArea(
        child: Column(
        children: [
          // ─── App Bar ───
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Scan & Solve",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "3 scans remaining today",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor.withValues(alpha: 0.40),
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),

          // ─── Body ───
          Obx(() {
            if (controller.isAnalyzing.value) {
              return Column(
                children: [
                  const SizedBox(height: 40),
                  _buildAnalyzingView(),
                ],
              );
            }
            return Column(
              children: [
                _buildCameraSection(),
                _buildSubjectSection(),
                const SizedBox(height: 16),
                _buildScanButton(),
                const SizedBox(height: 20),
              ],
            );
          }),
        ],
        ),
      ),
    );
  }

  // ─── Camera Section ───
  Widget _buildCameraSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 8),
          SizedBox(
            height: 280,
            child: CustomPaint(
              painter: _CornerBracketPainter(
                color: const Color(0xFFA78BFA),
                cornerLength: 30,
                strokeWidth: 3,
                borderRadius: 16,
              ),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: const Color(0xFF050508),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFFA78BFA).withValues(alpha: 0.20),
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(23),
                  child: _buildCameraPreview(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    return Obx(() {
      if (controller.hasCameraError.value) {
        return _buildPlaceholder("Camera not available");
      }
      if (!controller.isCameraReady.value ||
          controller.cameraController == null) {
        return _buildPlaceholder(null);
      }
      return Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: controller
                        .cameraController!.value.previewSize?.height ??
                    1,
                height:
                    controller.cameraController!.value.previewSize?.width ?? 1,
                child: CameraPreview(controller.cameraController!),
              ),
            ),
          ),
          _buildScanLine(),
        ],
      );
    });
  }

  Widget _buildPlaceholder(String? message) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset('assets/icon/camera_fill.svg'),
              const SizedBox(height: 14),
              Text(
                message ?? "Point camera at your problem",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor.withValues(alpha: 0.30),
                ),
              ),
            ],
          ),
        ),
        _buildScanLine(),
      ],
    );
  }

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

  // ─── Subject Section ───
  Widget _buildSubjectSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            "Select subject (required)",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.textColor.withValues(alpha: 0.40),
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: controller.subjects.map((subject) {
                final isSelected =
                    controller.selectedSubject.value == subject;
                return GestureDetector(
                  onTap: () => controller
                      .selectSubject(isSelected ? null : subject),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFA78BFA).withValues(alpha: 0.20)
                          : AppColors.textColor.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFA78BFA)
                                .withValues(alpha: 0.30)
                            : AppColors.textColor.withValues(alpha: 0.08),
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
                            : AppColors.textColor.withValues(alpha: 0.50),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Scan Button ───
  Widget _buildScanButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF7C3AED).withValues(alpha: 0.40),
              width: 1,
            ),
          ),
          child: Obx(
            () => ElevatedButton.icon(
              onPressed: controller.isCameraReady.value
                  ? controller.captureAndScan
                  : null,
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
                  AppColors.textColor,
                  BlendMode.srcIn,
                ),
              ),
              label: Text(
                "Scan Problem",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
              ),
            ),
          ),
        ),
      ),
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
