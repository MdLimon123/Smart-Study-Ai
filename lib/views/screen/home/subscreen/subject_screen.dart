import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/profile_controller.dart';
import 'package:flutter_extension/data/model/scan_history_item_model.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SubjectScreen extends StatefulWidget {
  const SubjectScreen({super.key});

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  int? _expandedIndex;
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  /// True while waiting for debounce or in-flight `?subject=` request.
  bool _searchSubjectPending = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<ProfileController>()) {
        Get.find<ProfileController>().fetchScanHistory();
      }
    });
  }

  void _onSearchChanged() {
    final q = _searchController.text.trim();
    if (q.isEmpty) {
      _searchDebounce?.cancel();
      setState(() {
        _expandedIndex = null;
        _searchSubjectPending = false;
      });
      return;
    }
    setState(() {
      _expandedIndex = null;
      _searchSubjectPending = true;
    });
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 450), () async {
      if (!mounted) return;
      final trimmed = _searchController.text.trim();
      if (trimmed.isEmpty) {
        if (mounted) {
          setState(() => _searchSubjectPending = false);
        }
        return;
      }
      await Get.find<ProfileController>().fetchScanHistory(subject: trimmed);
      if (mounted) {
        setState(() => _searchSubjectPending = false);
      }
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

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
            Obx(() {
              final pc = Get.find<ProfileController>();
              final n = pc.scanHistory.length;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Subjects',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor,
                    ),
                  ),
                  Text(
                    n == 0
                        ? 'Your scan history'
                        : '$n from scan history',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor.withValues(alpha: 0.50),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.borderColor,
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: AppColors.textColor, fontSize: 14.sp),
                  decoration: InputDecoration(
                    hintText: 'Search by subject (e.g. math)',
                    hintStyle: TextStyle(
                      color: AppColors.textColor.withValues(alpha: 0.35),
                      fontSize: 14.sp,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.textColor.withValues(alpha: 0.35),
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                final pc = Get.find<ProfileController>();
                final hasSearch = _searchController.text.trim().isNotEmpty;
                final items =
                    hasSearch ? pc.scanHistoryQuery : pc.scanHistory;
                final searchBusy =
                    hasSearch &&
                    (_searchSubjectPending || pc.isScanHistoryLoading.value);

                if (pc.isScanHistoryLoading.value &&
                    !hasSearch &&
                    pc.scanHistory.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFA78BFA),
                    ),
                  );
                }
                if (hasSearch && searchBusy) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFA78BFA),
                    ),
                  );
                }

                final err = pc.scanHistoryError.value;
                final listEmptyForMode =
                    hasSearch ? pc.scanHistoryQuery.isEmpty : pc.scanHistory.isEmpty;
                if (err != null && err.isNotEmpty && listEmptyForMode) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            err,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textColor.withValues(alpha: 0.70),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          TextButton(
                            onPressed: () {
                              final q = _searchController.text.trim();
                              if (q.isNotEmpty) {
                                pc.fetchScanHistory(subject: q);
                              } else {
                                pc.fetchScanHistory();
                              }
                            },
                            child: Text(
                              'Retry',
                              style: TextStyle(
                                color: AppColors.textColor.withValues(
                                  alpha: 0.90,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (items.isEmpty) {
                  return Center(
                    child: Text(
                      hasSearch
                          ? 'No results for this subject'
                          : 'No scan history yet',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textColor.withValues(alpha: 0.45),
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => SizedBox(height: 10.h),
                  itemBuilder: (context, index) {
                    return _buildScanHistoryCard(items[index], index);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanHistoryCard(ScanHistoryItemModel item, int index) {
    final isExpanded = _expandedIndex == index;
    final accent = _accentForSubject(item.subject);

    return GestureDetector(
      onTap: () {
        setState(() {
          _expandedIndex = isExpanded ? null : index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isExpanded
                ? accent.withValues(alpha: 0.35)
                : AppColors.borderColor,
          ),
          boxShadow: AppColors.isDark ? [] : [
            BoxShadow(
              color: const Color(0xFF000000).withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _subjectIconWidget(item.subject),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatSubjectLabel(item.subject),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                      if (item.question.trim().isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Text(
                          item.question,
                          maxLines: isExpanded ? null : 2,
                          overflow: isExpanded
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textColor.withValues(alpha: 0.45),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: isExpanded ? 0.25 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.chevron_right,
                    color: AppColors.textColor.withValues(alpha: 0.4),
                    size: 20,
                  ),
                ),
              ],
            ),
            if (isExpanded) ...[
              SizedBox(height: 14.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.textColor.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.textColor.withValues(alpha: 0.08),
                  ),
                ),
                child: SelectableText(
                  item.aiResponse.isEmpty ? '—' : item.aiResponse,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.45,
                    color: AppColors.textColor.withValues(alpha: 0.88),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _accentForSubject(String raw) {
    final s = raw.toLowerCase();
    if (s.contains('math')) return const Color(0xFF7C3AED);
    if (s.contains('phys')) return const Color(0xFFEAB308);
    if (s.contains('chem')) return const Color(0xFF22C55E);
    if (s.contains('bio')) return const Color(0xFFF97316);
    return const Color(0xFFA78BFA);
  }


  Widget _subjectIconWidget(String rawSubject) {
    final s = rawSubject.toLowerCase().trim();
    if (s.contains('math')) {
      return Container(
        height: 44.w,
        width: 44.w,
        decoration: BoxDecoration(
          color: AppColors.isDark
              ? const Color(0xFF26213A)
              : const Color(0xFFEEF2FF),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Center(
          child: Text(
            "√x",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4F46E5),
              fontFamily: 'Lato',
            ),
          ),
        ),
      );
    }
    
    // Chemistry
    if (s.contains('chem') || s.contains('che')) {
      return Container(
        height: 44.w,
        width: 44.w,
        decoration: BoxDecoration(
          color: AppColors.isDark
              ? const Color(0xFF1B2B2C)
              : const Color(0xFFECFDF5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Image.asset(
            'assets/images/che.png',
            height: 22,
            width: 22,
            color: const Color(0xFF047857),
          ),
        ),
      );
    }
    
    // Physics
    if (s.contains('phys') || s.contains('phy')) {
      return Container(
        height: 44.w,
        width: 44.w,
        decoration: BoxDecoration(
          color: AppColors.isDark
              ? const Color(0xFF1E293B)
              : const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Image.asset(
            'assets/images/phy.png',
            height: 22,
            width: 22,
            color: const Color(0xFF2563EB),
          ),
        ),
      );
    }
    
    // Biology
    if (s.contains('bio') || s.contains('tree')) {
      return Container(
        height: 44.w,
        width: 44.w,
        decoration: BoxDecoration(
          color: AppColors.isDark
              ? const Color(0xFF2D2A1E)
              : const Color(0xFFFEF3C7),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Image.asset(
            'assets/images/tree.png',
            height: 22,
            width: 22,
            color: const Color(0xFFD97706),
          ),
        ),
      );
    }
    
    // Default fallback
    return Container(
      height: 44.w,
      width: 44.w,
      decoration: BoxDecoration(
        color: AppColors.isDark
            ? const Color(0xFF1F2937)
            : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Icon(
          Icons.description,
          color: AppColors.isDark
              ? const Color(0xFF9CA3AF)
              : const Color(0xFF4B5563),
          size: 20,
        ),
      ),
    );
  }

  String _formatSubjectLabel(String raw) {
    final t = raw.trim();
    if (t.isEmpty) return 'Scan';
    return t
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .map(
          (w) =>
              '${w[0].toUpperCase()}${w.length > 1 ? w.substring(1).toLowerCase() : ''}',
        )
        .join(' ');
  }
}
