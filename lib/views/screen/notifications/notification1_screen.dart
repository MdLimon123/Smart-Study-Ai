import 'package:flutter/material.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:get/get.dart';

class Notification1Screen extends StatefulWidget {
  const Notification1Screen({super.key});

  @override
  State<Notification1Screen> createState() => _Notification1ScreenState();
}

class _Notification1ScreenState extends State<Notification1Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () => Get.back(),
              borderRadius: BorderRadius.circular(12),
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
                    size: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Notifications",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: 6,
          padding: const EdgeInsets.only(top: 8),
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFDDDEE1),
                    ),
                    child: const Icon(
                      Icons.bolt,
                      color: Color(0xFF515669),
                      size: 20,
                    ),
                  ),
                  title: Text(
                    'New Account created',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                  subtitle: Text(
                    'Last Wednesday at 9:42 AM',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textColor.withValues(alpha: 0.40),
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                ),
                Divider(
                  color: AppColors.textColor.withValues(alpha: 0.06),
                  height: 1,
                  indent: 72,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
