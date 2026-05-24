import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/ai_chat_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:get/get.dart';

class AiChatScreen extends StatefulWidget {
  final String controllerTag;

  const AiChatScreen({
    super.key,
    this.controllerTag = AiChatControllerTags.mainTab,
  });

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  late final AiChatController _aiChatController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _aiChatController = Get.put(
      AiChatController(),
      tag: widget.controllerTag,
    );
  }

  @override
  void dispose() {
    Get.delete<AiChatController>(tag: widget.controllerTag);
    _scrollController.dispose();
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
      color: AppColors.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.borderColor),
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
                            _aiChatController.selectedModel!.icon,
                            height: 16,
                            width: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _aiChatController.selectedModelName,
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

          // ─── Subject Chips ───
          Obx(() {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: _aiChatController.subjects.map((subject) {
                  final isSelected = _aiChatController.selectedSubject.value == subject;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () {
                        _aiChatController.selectSubject(isSelected ? null : subject);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF7C3AED).withValues(alpha: 0.12)
                              : AppColors.textColor.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF7C3AED)
                                : AppColors.textColor.withValues(alpha: 0.08),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          subject,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected
                                ? const Color(0xFF7C3AED)
                                : AppColors.textColor.withValues(alpha: 0.60),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }),

          const SizedBox(height: 16),

          // ─── Chat Messages ───
          Expanded(
            child: Obx(
              () => ListView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  ..._aiChatController.messages.map((m) {
                    final isUser = m.role == 'user';
                    if (isUser) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (m.imagePath != null)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.file(
                                          File(m.imagePath!),
                                          width: 200,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  if (m.filePath != null)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF7C3AED).withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: const Color(0xFF7C3AED).withValues(alpha: 0.25),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.picture_as_pdf_outlined,
                                              color: Color(0xFF7C3AED),
                                              size: 18,
                                            ),
                                            const SizedBox(width: 8),
                                            Flexible(
                                              child: Text(
                                                m.fileName ?? 'File',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.textColor.withValues(alpha: 0.8),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (m.content.isNotEmpty)
                                    Container(
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
                                      child: Text(
                                        m.content,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                ],
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
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.78,
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
                          child: _AiMarkdown(text: m.content),
                        ),
                      ),
                    );
                  }),
                  if (_aiChatController.isSending.value)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Thinking...',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textColor.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ─── Attachment Preview ───
          Obx(() {
            final path = _aiChatController.attachedFilePath.value;
            final name = _aiChatController.attachedFileName.value;
            final isImage = _aiChatController.attachedIsImage.value;
            if (path == null || name == null) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF7C3AED).withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  children: [
                    if (isImage)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.file(
                          File(path),
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.picture_as_pdf_outlined,
                          color: Color(0xFF7C3AED),
                          size: 20,
                        ),
                      ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textColor.withValues(alpha: 0.75),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: _aiChatController.clearAttachment,
                      child: Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: AppColors.textColor.withValues(alpha: 0.45),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          // ─── Input Field ───
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              constraints: const BoxConstraints(minHeight: 50),
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
                  // Image attach button
                  GestureDetector(
                    onTap: _aiChatController.pickImage,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                      child: Icon(
                        Icons.image_outlined,
                        size: 22,
                        color: AppColors.textColor.withValues(alpha: 0.45),
                      ),
                    ),
                  ),
                  // File attach button
                  GestureDetector(
                    onTap: _aiChatController.pickFile,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                      child: Icon(
                        Icons.attach_file_rounded,
                        size: 22,
                        color: AppColors.textColor.withValues(alpha: 0.45),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
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
                  GestureDetector(
                    onTap: () async {
                      await _aiChatController.sendMessage();
                      if (_scrollController.hasClients) {
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent + 120,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOut,
                        );
                      }
                    },
                    child: Container(
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
                  ),
                ],
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }
}

class _AiMarkdown extends StatelessWidget {
  const _AiMarkdown({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final baseColor = AppColors.textColor.withValues(alpha: 0.92);
    final baseStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.55,
      color: baseColor,
    );

    return GptMarkdownTheme(
      gptThemeData: GptMarkdownThemeData(
        brightness: Theme.of(context).brightness,
        h1: baseStyle.copyWith(fontSize: 20, fontWeight: FontWeight.w800),
        h2: baseStyle.copyWith(fontSize: 18, fontWeight: FontWeight.w800),
        h3: baseStyle.copyWith(fontSize: 17, fontWeight: FontWeight.w700),
        h4: baseStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
        h5: baseStyle.copyWith(fontSize: 15, fontWeight: FontWeight.w700),
        h6: baseStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
        linkColor: const Color(0xFF93C5FD),
      ),
      child: GptMarkdown(
        text.replaceAll(r'\n', '\n'),
        style: baseStyle,
        textAlign: TextAlign.start,
        latexBuilder: (context, tex, textStyle, inline) {
          final screenWidth = MediaQuery.sizeOf(context).width;
          final safeWidth = (screenWidth - 96).clamp(160.0, screenWidth);
          final math = Math.tex(
            tex,
            textStyle: textStyle,
            mathStyle: inline ? MathStyle.text : MathStyle.display,
            settings: const TexParserSettings(strict: Strict.ignore),
            options: MathOptions(
              color: baseColor,
              fontSize: baseStyle.fontSize,
            ),
          );
          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: safeWidth),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: math,
            ),
          );
        },
      ),
    );
  }
}
