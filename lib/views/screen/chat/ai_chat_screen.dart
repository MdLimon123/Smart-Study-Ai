import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/ai_chat_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:markdown/markdown.dart' as md;

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

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.textColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Add Attachment",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 16),
                _buildAttachmentOption(
                  context,
                  icon: Icons.camera_alt_outlined,
                  title: "Live Camera",
                  subtitle: "Take a picture of your question directly",
                  iconColor: const Color(0xFF10B981),
                  onTap: () {
                    Navigator.pop(context);
                    _aiChatController.pickImageFromCamera();
                  },
                ),
                const SizedBox(height: 12),
                _buildAttachmentOption(
                  context,
                  icon: Icons.photo_library_outlined,
                  title: "Image Upload",
                  subtitle: "Select images from your gallery",
                  iconColor: const Color(0xFF7C3AED),
                  onTap: () {
                    Navigator.pop(context);
                    _aiChatController.pickImage();
                  },
                ),
                const SizedBox(height: 12),
                _buildAttachmentOption(
                  context,
                  icon: Icons.picture_as_pdf_outlined,
                  title: "File/Document Upload",
                  subtitle: "Upload PDF, Word, or Text files",
                  iconColor: const Color(0xFFEF4444),
                  onTap: () {
                    Navigator.pop(context);
                    _aiChatController.pickFile();
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAttachmentOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.textColor.withValues(alpha: 0.08),
            width: 1,
          ),
          color: AppColors.textColor.withValues(alpha: 0.02),
        ),
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textColor.withValues(alpha: 0.35),
            ),
          ],
        ),
      ),
    );
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
                        if (isSelected) {
                          if (subject != 'All Subjects') _aiChatController.selectSubject('All Subjects');
                        } else {
                          _aiChatController.selectSubject(subject);
                        }
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
                                  if (m.imagePaths != null && m.imagePaths!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: Wrap(
                                        spacing: 6,
                                        runSpacing: 6,
                                        alignment: WrapAlignment.end,
                                        children: m.imagePaths!.map((path) => ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.file(
                                            File(path),
                                            width: 150,
                                            height: 150,
                                            fit: BoxFit.cover,
                                          ),
                                        )).toList(),
                                      ),
                                    )
                                  else if (m.imagePath != null)
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
            final images = _aiChatController.attachedImages;
            
            if (path == null && images.isEmpty) return const SizedBox.shrink();
            
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (path != null && name != null)
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C3AED).withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFF7C3AED).withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                            Text(
                              name.length > 15 ? '${name.substring(0, 15)}...' : name,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColor.withValues(alpha: 0.75),
                              ),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () {
                                _aiChatController.attachedFilePath.value = null;
                                _aiChatController.attachedFileName.value = null;
                              },
                              child: Icon(
                                Icons.close_rounded,
                                size: 16,
                                color: AppColors.textColor.withValues(alpha: 0.45),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ...images.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final imgPath = entry.value;
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C3AED).withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFF7C3AED).withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.file(
                                File(imgPath),
                                width: 36,
                                height: 36,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () => _aiChatController.removeImage(idx),
                              child: Icon(
                                Icons.close_rounded,
                                size: 16,
                                color: AppColors.textColor.withValues(alpha: 0.45),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
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
                  // File/Upload button
                  GestureDetector(
                    onTap: () => _showAttachmentOptions(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
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

    return MarkdownBody(
      data: text,
      selectable: true,
      styleSheet: MarkdownStyleSheet(
        p: baseStyle,
        h1: baseStyle.copyWith(fontSize: 20, fontWeight: FontWeight.w800),
        h2: baseStyle.copyWith(fontSize: 18, fontWeight: FontWeight.w800),
        h3: baseStyle.copyWith(fontSize: 17, fontWeight: FontWeight.w700),
        h4: baseStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
        h5: baseStyle.copyWith(fontSize: 15, fontWeight: FontWeight.w700),
        h6: baseStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
        strong: baseStyle.copyWith(fontWeight: FontWeight.w700),
        em: baseStyle.copyWith(fontStyle: FontStyle.italic),
        code: baseStyle.copyWith(
          fontFamily: 'monospace',
          fontSize: 13,
          backgroundColor: AppColors.textColor.withValues(alpha: 0.08),
        ),
        codeblockDecoration: BoxDecoration(
          color: AppColors.textColor.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
        ),
        blockquoteDecoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: const Color(0xFF7C3AED).withValues(alpha: 0.6),
              width: 3,
            ),
          ),
        ),
        listBullet: baseStyle,
        a: baseStyle.copyWith(
          color: const Color(0xFF93C5FD),
          decoration: TextDecoration.underline,
        ),
      ),
      builders: {
        'latex': LatexElementBuilder(
          textStyle: baseStyle,
          textScaleFactor: 1.0,
        ),
      },
      extensionSet: md.ExtensionSet(
        [LatexBlockSyntax()],
        [LatexInlineSyntax()],
      ),
    );
  }
}
