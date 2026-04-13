import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/profile_controller.dart';
import 'package:flutter_extension/data/model/scan_history_item_model.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:get/get.dart';

class ScanHistoryScreen extends StatefulWidget {
  const ScanHistoryScreen({super.key});

  @override
  State<ScanHistoryScreen> createState() => _ScanHistoryScreenState();
}

class _ScanHistoryScreenState extends State<ScanHistoryScreen> {
  late final ProfileController _profileController;

  @override
  void initState() {
    super.initState();
    _profileController = Get.find<ProfileController>();
    _profileController.fetchScanHistory();
  }

  @override
  Widget build(BuildContext context) {
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
            Expanded(
              child: Text(
                'Scan History',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (_profileController.isScanHistoryLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF34D399)),
            );
          }
          final err = _profileController.scanHistoryError.value;
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
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => _profileController.fetchScanHistory(),
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
          final items = _profileController.scanHistory;
          if (items.isEmpty) {
            return Center(
              child: Text(
                'No scan history yet',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textColor.withValues(alpha: 0.45),
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            itemBuilder: (context, index) => _historyCard(items[index]),
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemCount: items.length,
          );
        }),
      ),
    );
  }

  Widget _historyCard(ScanHistoryItemModel e) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.textColor.withValues(alpha: 0.04),
        border: Border.all(
          color: AppColors.textColor.withValues(alpha: 0.07),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF34D399).withValues(alpha: 0.14),
                ),
                child: Text(
                  e.subject.isEmpty ? 'Unknown' : e.subject,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF34D399),
                  ),
                ),
              ),
            ],
          ),
          if (e.imageUrl.isNotEmpty) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                e.imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 150,
                  alignment: Alignment.center,
                  color: AppColors.textColor.withValues(alpha: 0.06),
                  child: Text(
                    'Image unavailable',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textColor.withValues(alpha: 0.50),
                    ),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            'AI Response',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              color: AppColors.textColor.withValues(alpha: 0.40),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            e.aiResponse.isEmpty ? '—' : e.aiResponse,
            maxLines: 8,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 1.45,
              color: AppColors.textColor.withValues(alpha: 0.82),
            ),
          ),
        ],
      ),
    );
  }
}