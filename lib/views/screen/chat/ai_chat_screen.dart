import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/ai_chat_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final _aiChatController = Get.put(AiChatController());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<AiChatController>();
    super.dispose();
  }

  void _showModelPicker() {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu<int>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(button.size.width - 20, 100, 0, 0),
        Offset.zero & overlay.size,
      ),
      color: const Color(0xFF1A1A2E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.textColor.withValues(alpha: 0.10)),
      ),
      elevation: 12,
      items: List.generate(_aiChatController.models.length, (index) {
        final model = _aiChatController.models[index];
        return PopupMenuItem<int>(
          value: index,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Image.asset(model.icon, height: 24, width: 24),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                  Text(
                    model.subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor.withValues(alpha: 0.40),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    ).then((value) {
      if (value != null) {
        _aiChatController.selectModel(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                      "AI Chat",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textColor,
                      ),
                    ),
                    Text(
                      "Ask anything academic",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor.withValues(alpha: 0.40),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _showModelPicker,
                  child: Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(
                            0xFF10B981,
                          ).withValues(alpha: 0.20),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            _aiChatController.selectedModel.icon,
                            height: 16,
                            width: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _aiChatController.selectedModel.name,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 18,
                            color: AppColors.textColor.withValues(alpha: 0.50),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ─── Suggestion Chips ───
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children:
                  [
                    'Explain photosynthesis',
                    'Solve quadratics',
                    'Help with essay',
                  ].map((label) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.textColor.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: AppColors.textColor.withValues(alpha: 0.08),
                          ),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textColor.withValues(alpha: 0.50),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // ─── Chat Messages ───
          Expanded(
            child: Obx(
              () => ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  // Model label
                  Text(
                    _aiChatController.selectedModel.name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor.withValues(alpha: 0.30),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // AI welcome bubble
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.textColor.withValues(alpha: 0.07),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                          bottomLeft: Radius.circular(4),
                          bottomRight: Radius.circular(18),
                        ),
                      ),
                      child: Text(
                        "Hi! I'm your QQAI academic assistant 👋 I can help you understand complex topics, solve problems, and guide your studies. What would you like to learn today?",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Copy button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 28,
                        width: 28,
                        decoration: BoxDecoration(
                          color: AppColors.textColor.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset('assets/icon/cart.svg'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ─── User Message ───
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(18),
                              topRight: Radius.circular(18),
                              bottomLeft: Radius.circular(18),
                              bottomRight: Radius.circular(4),
                            ),
                          ),
                          child: const Text(
                            "Solve quadratics",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 28,
                        width: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.textColor.withValues(alpha: 0.10),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 16,
                          color: Color(0xFF7C3AED),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ─── AI Response ───
                  Text(
                    _aiChatController.selectedModel.name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor.withValues(alpha: 0.30),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.textColor.withValues(alpha: 0.07),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                          bottomLeft: Radius.circular(4),
                          bottomRight: Radius.circular(18),
                        ),
                      ),
                      child: Text(
                        "Great question! Let me break this down step by step for you.",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── Input Field ───
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: AppColors.textColor.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.textColor.withValues(alpha: 0.08),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Attach button
                SvgPicture.asset('assets/icon/file.svg'),
                const SizedBox(width: 8),
                // Text field
                Expanded(
                  child: TextField(
                    controller: _aiChatController.messageController,
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(fontSize: 14, color: AppColors.textColor),
                    decoration: InputDecoration(
                      hintText: "Ask a question...",
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor.withValues(alpha: 0.50),
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      isCollapsed: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 2),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Send button
                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.textColor.withValues(alpha: 0.08),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset('assets/icon/send.svg'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
