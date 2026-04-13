import 'package:flutter/material.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/screen/profile/dataControl/chat_history_screen.dart';
import 'package:flutter_extension/views/screen/profile/dataControl/scan_history_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class DataControlScreen extends StatefulWidget {
  const DataControlScreen({super.key});

  @override
  State<DataControlScreen> createState() => _DataControlScreenState();
}

class _DataControlScreenState extends State<DataControlScreen> {
  static const List<String> _exploreKeys = [
    'Chat History',
    'Scan History',
  ];

  final Map<String, String> _itemSubtitles = {
    'Chat History': '89 conversations · 2.4 MB',
    'Scan History': '67 scans · 8.3 MB',
  };

  final Map<String, Color> _itemColors = {
    'Chat History': const Color(0xFFA78BFA),
    'Scan History': const Color(0xFF34D399),
  };

  final Map<String, IconData> _itemIcons = {
    'Chat History': Icons.chat_bubble_outline,
    'Scan History': Icons.qr_code_scanner,
  };

  @override
  Widget build(BuildContext context) {
    final totalSize = _calculateTotalSize();

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),

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
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Data Control",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
                Text(
                  'Manage your personal data',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor.withValues(alpha: 0.50),
                  ),
                ),
              ],
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
              // Explore your Data
              Text(
                "Explore your Data",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 12),

              // Data items — tap opens the related screen (same card design as before)
              ..._exploreKeys.map(
                (key) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _dataItemCard(
                    title: key,
                    subtitle: _itemSubtitles[key]!,
                    color: _itemColors[key]!,
                    icon: _itemIcons[key]!,
                    onTap: () => _openExploreDestination(key),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Summary
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${_exploreKeys.length} categories",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor.withValues(alpha: 0.35),
                    ),
                  ),
                  Text(
                    "~$totalSize",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFA78BFA),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Clear Cache button
              InkWell(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: const Color(0xFFF87171).withValues(alpha: 0.08),
                    border: Border.all(
                      color: const Color(0xFFF87171).withValues(alpha: 0.20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/icon/delete.svg"),
                      const SizedBox(width: 8),
                      const Text(
                        "Clear Cache",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFF87171),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Privacy notice
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.shield_outlined,
                    size: 16,
                    color: AppColors.textColor.withValues(alpha: 0.30),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "QQA processes your data in accordance with our Privacy Policy. Exported data is encrypted. Deleted data is purged from all servers within 30 days.",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor.withValues(alpha: 0.30),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _calculateTotalSize() {
    const total = 2.4 + 8.3;
    return "${total.toStringAsFixed(1)} MB";
  }

  void _openExploreDestination(String key) {
    switch (key) {
      case 'Chat History':
        Get.to(() => const ChatHistoryScreen());
        break;

      case 'Scan History':
        Get.to(() => const ScanHistoryScreen());
        break;
    }
  }

  Widget _dataItemCard({
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.textColor.withValues(alpha: 0.04),
          border: Border.all(
            color: AppColors.textColor.withValues(alpha: 0.07),
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: color.withValues(alpha: 0.12),
              ),
              child: Center(child: Icon(icon, color: color, size: 18)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor.withValues(alpha: 0.35),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textColor.withValues(alpha: 0.35),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
