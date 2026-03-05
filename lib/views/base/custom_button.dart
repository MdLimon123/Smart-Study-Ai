import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../util/app_colors.dart';
import '../../util/style.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.color,
    this.textStyle,
    this.radius,
    this.margin = EdgeInsets.zero,
    required this.onTap,
    required this.text,
    this.loading = false,
    this.width,
    this.height,
    this.gradient,
    this.border,
  });
  final Function() onTap;
  final String text;
  final bool loading;
  final double? height;
  final double? width;
  final Color? color;
  final double? radius;
  final EdgeInsetsGeometry margin;
  final TextStyle? textStyle;
  final Gradient? gradient;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius ?? 16);

    if (gradient != null) {
      return Padding(
        padding: margin,
        child: Container(
          width: width ?? Get.width,
          height: height ?? 56.h,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: borderRadius,
            border: border,
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                spreadRadius: 0,
                color: const Color(0xFF7C3AED).withValues(alpha: 0.40),
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: loading ? () {} : onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: borderRadius),
              minimumSize: Size(width ?? Get.width, height ?? 56.h),
            ),
            child: loading
                ? SizedBox(
                    height: 20.h,
                    width: 20.h,
                    child: const CircularProgressIndicator(color: Colors.white),
                  )
                : Text(
                    text,
                    style:
                        textStyle ??
                        AppStyles.h3(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                  ),
          ),
        ),
      );
    }

    return Padding(
      padding: margin,
      child: ElevatedButton(
        onPressed: loading ? () {} : onTap,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          backgroundColor: color ?? AppColors.primaryColor,
          minimumSize: Size(width ?? Get.width, height ?? 53.h),
        ),
        child: loading
            ? SizedBox(
                height: 20.h,
                width: 20.h,
                child: const CircularProgressIndicator(color: Colors.white),
              )
            : Text(
                text,
                style:
                    textStyle ??
                    AppStyles.h3(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
              ),
      ),
    );
  }
}
