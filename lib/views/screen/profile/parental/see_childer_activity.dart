import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/profile_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';
import 'package:get/get.dart';
import 'package:markdown/markdown.dart' as md;

class SeeChilderActivity extends StatefulWidget {
  const SeeChilderActivity({super.key});

  @override
  State<SeeChilderActivity> createState() => _SeeChilderActivityState();
}

class _SeeChilderActivityState extends State<SeeChilderActivity> with SingleTickerProviderStateMixin {
  late final ProfileController _profileController;
  late final TabController _tabController;

  // Track expanded cards
  final RxSet<String> _expandedItemIds = <String>{}.obs;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _profileController = Get.find<ProfileController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadData();
    });
  }

  Future<void> _loadData() async {
    await Future.wait([
      _profileController.fetchChildScans(),
      _profileController.fetchChildChats(),
    ]);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleExpanded(String id) {
    if (_expandedItemIds.contains(id)) {
      _expandedItemIds.remove(id);
    } else {
      _expandedItemIds.add(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
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
                "Children's Activity",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ─── Custom Premium Switch TabBar ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Container(
                height: 48,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.textColor.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.textColor.withValues(alpha: 0.06),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  labelColor: const Color(0xFF7C3AED),
                  unselectedLabelColor: AppColors.textColor.withValues(alpha: 0.50),
                  labelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: const [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.qr_code_scanner_rounded, size: 16),
                          SizedBox(width: 6),
                          Text("Scans"),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat_bubble_outline_rounded, size: 16),
                          SizedBox(width: 6),
                          Text("Chats"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ─── Tab Views ───
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildScanTab(),
                  _buildChatTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanTab() {
    return Obx(() {
      if (_profileController.isChildScansLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF7C3AED)),
        );
      }

      final error = _profileController.childScansError.value;
      if (error != null) {
        return _buildErrorState(error, () => _profileController.fetchChildScans());
      }

      final scans = _profileController.childScans;

      if (scans.isEmpty) {
        return _buildEmptyState("No scan activity found.");
      }

      return RefreshIndicator(
        color: const Color(0xFF7C3AED),
        onRefresh: () => _profileController.fetchChildScans(),
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          itemCount: scans.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final scan = Map<String, dynamic>.from(scans[index] as Map);
            final String id = scan['id']?.toString() ?? index.toString();
            final String subject = scan['subject']?.toString() ?? 'General';
            final String question = scan['question']?.toString() ?? '';
            final String aiResponse = scan['ai_response']?.toString() ?? '';
            final String? imageUrl = scan['image_url']?.toString();
            final String? childEmail = scan['child_email']?.toString();
            final isExpanded = _expandedItemIds.contains(id);

            return _buildActivityCard(
              id: id,
              childEmail: childEmail,
              subject: subject,
              title: question,
              aiResponse: aiResponse,
              imageUrl: imageUrl,
              isExpanded: isExpanded,
              isScanType: true,
            );
          },
        ),
      );
    });
  }

  Widget _buildChatTab() {
    return Obx(() {
      if (_profileController.isChildChatsLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF7C3AED)),
        );
      }

      final error = _profileController.childChatsError.value;
      if (error != null) {
        return _buildErrorState(error, () => _profileController.fetchChildChats());
      }

      final chats = _profileController.childChats;

      if (chats.isEmpty) {
        return _buildEmptyState("No chat activity found.");
      }

      return RefreshIndicator(
        color: const Color(0xFF7C3AED),
        onRefresh: () => _profileController.fetchChildChats(),
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          itemCount: chats.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final chat = Map<String, dynamic>.from(chats[index] as Map);
            final String id = chat['id']?.toString() ?? index.toString();
            final String prompt = chat['prompt']?.toString() ?? '';
            final String aiResponse = chat['ai_response']?.toString() ?? '';
            final String? imageUrl = chat['image_url']?.toString();
            final String? fileUrl = chat['file_url']?.toString();
            final String? childEmail = chat['child_email']?.toString();
            final isExpanded = _expandedItemIds.contains(id);

            // Handle prompt fallback
            String displayTitle = prompt;
            if (displayTitle.isEmpty) {
              if (fileUrl != null) {
                displayTitle = "Sent a document attachment";
              } else if (imageUrl != null) {
                displayTitle = "Sent an image attachment";
              } else {
                displayTitle = "Chat Message";
              }
            }

            return _buildActivityCard(
              id: id,
              childEmail: childEmail,
              subject: null,
              title: displayTitle,
              aiResponse: aiResponse,
              imageUrl: imageUrl,
              fileUrl: fileUrl,
              isExpanded: isExpanded,
              isScanType: false,
            );
          },
        ),
      );
    });
  }

  Widget _buildActivityCard({
    required String id,
    required String? childEmail,
    required String? subject,
    required String title,
    required String aiResponse,
    String? imageUrl,
    String? fileUrl,
    required bool isExpanded,
    required bool isScanType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.textColor.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.textColor.withValues(alpha: 0.06),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            key: PageStorageKey<String>(id),
            initiallyExpanded: isExpanded,
            onExpansionChanged: (val) => _toggleExpanded(id),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (subject != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C3AED).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
                          ),
                        ),
                        child: Text(
                          subject.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF7C3AED),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor.withValues(alpha: 0.9),
                  ),
                  maxLines: isExpanded ? 50 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            trailing: Icon(
              isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
              color: AppColors.textColor.withValues(alpha: 0.4),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(height: 24, thickness: 1),

                    // Media Attachments
                    if (imageUrl != null && imageUrl.isNotEmpty) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          imageUrl,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 120,
                            color: Colors.grey.withValues(alpha: 0.1),
                            child: const Center(
                              child: Icon(Icons.image_not_supported_rounded, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    if (fileUrl != null && fileUrl.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C3AED).withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.description_outlined, color: Color(0xFF7C3AED), size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                fileUrl.split('/').last,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textColor.withValues(alpha: 0.8),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // AI Response title
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 14,
                          decoration: BoxDecoration(
                            color: const Color(0xFF7C3AED),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "AI Response",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Markdown response
                    MarkdownBody(
                      data: aiResponse,
                      selectable: true,
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                          fontSize: 13,
                          color: AppColors.textColor.withValues(alpha: 0.85),
                          height: 1.5,
                        ),
                        strong: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textColor.withValues(alpha: 0.85),
                        ),
                        em: TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          color: AppColors.textColor.withValues(alpha: 0.85),
                        ),
                        code: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          backgroundColor: AppColors.textColor.withValues(alpha: 0.08),
                          color: AppColors.textColor.withValues(alpha: 0.85),
                        ),
                      ),
                      builders: {
                        'latex': LatexElementBuilder(
                          textStyle: TextStyle(
                            fontSize: 13,
                            color: AppColors.textColor.withValues(alpha: 0.85),
                          ),
                          textScaleFactor: 1.0,
                        ),
                      },
                      extensionSet: md.ExtensionSet(
                        [LatexBlockSyntax()],
                        [LatexInlineSyntax()],
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

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.textColor.withValues(alpha: 0.03),
              ),
              child: Icon(
                Icons.history_toggle_off_rounded,
                size: 48,
                color: AppColors.textColor.withValues(alpha: 0.3),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textColor.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textColor.withValues(alpha: 0.70),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: onRetry,
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
}