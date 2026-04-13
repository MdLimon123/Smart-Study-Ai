import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_extension/controller/profile_controller.dart';
import 'package:flutter_extension/data/model/chat_history_item_model.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:file_saver/file_saver.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  late final ProfileController _profileController;

  @override
  void initState() {
    super.initState();
    _profileController = Get.find<ProfileController>();
    _profileController.fetchChatHistory();
  }

  String _dateLabel(String iso) {
    final t = iso.indexOf('T');
    if (t > 0) return iso.substring(0, t);
    if (iso.length >= 10) return iso.substring(0, 10);
    return iso.isEmpty ? '—' : iso;
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chat History',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor,
                    ),
                  ),
                  Text(
                    'View only — you cannot send new messages here',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (_profileController.isChatHistoryLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFA78BFA)),
            );
          }
          final err = _profileController.chatHistoryError.value;
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
                      onPressed: () => _profileController.fetchChatHistory(),
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
          final items = _profileController.chatHistory;
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (items.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 48),
                          child: Center(
                            child: Text(
                              'No chat history yet',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor.withValues(alpha: 0.45),
                              ),
                            ),
                          ),
                        )
                      else
                        ...items.map((e) => _historyCard(e)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Export all data
                    InkWell(
                      onTap: _showExportDialog,
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/icon/download.svg'),
                            const SizedBox(width: 14),
                            Text(
                              'Export all data',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Delete Chat History',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(() {
                      final n = _profileController.chatHistory.length;
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
                        child: Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color(
                                  0xFFA78BFA,
                                ).withValues(alpha: 0.12),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.chat_bubble_outline,
                                  color: Color(0xFFA78BFA),
                                  size: 18,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Chat History',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '$n conversations',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textColor.withValues(
                                        alpha: 0.40,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color(
                                  0xFFA78BFA,
                                ).withValues(alpha: 0.15),
                              ),
                              child: Text(
                                '$n',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFA78BFA),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 14),
                    InkWell(
                      onTap: _showDeleteConfirmDialog,
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
                            SvgPicture.asset('assets/icon/delete.svg'),
                            const SizedBox(width: 8),
                            const Text(
                              'Delete All Chat History',
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
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _historyCard(ChatHistoryItemModel e) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
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
          Text(
            'You',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              color: AppColors.textColor.withValues(alpha: 0.40),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            e.prompt.isEmpty ? '—' : e.prompt,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.35,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Assistant',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              color: const Color(0xFFA78BFA).withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            e.aiResponse.isEmpty ? '—' : e.aiResponse,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 1.45,
              color: AppColors.textColor.withValues(alpha: 0.82),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _dateLabel(e.createdAt),
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textColor.withValues(alpha: 0.35),
            ),
          ),
        ],
      ),
    );
  }

  void _showExportDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _ExportProgressDialog(
        items: _profileController.chatHistory.toList(),
      ),
    );
  }

  void _showDeleteConfirmDialog() {
    final n = _profileController.chatHistory.length;
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.warning,
                        color: Color(0xFFF59E0B),
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 2),
                        Text(
                          'This cannot be undone',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textColor.withValues(alpha: 0.50),
                            ),
                            children: [
                              const TextSpan(
                                text: 'You are about to permanently delete ',
                              ),
                              TextSpan(
                                text: '$n conversation${n == 1 ? '' : 's'}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textColor,
                                ),
                              ),
                              const TextSpan(
                                text:
                                    ' from your account. This action is irreversible.',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: AppColors.textColor.withValues(alpha: 0.07),
                        ),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textColor.withValues(alpha: 0.60),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        final deletedCount = n;
                        final isDeleted =
                            await _profileController.deleteAllChatHistory();
                        if (!mounted || !isDeleted) return;
                        _showDeleteSuccessDialog(deletedCount);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFFF87171).withValues(alpha: 0.20),
                          border: Border.all(
                            color: const Color(0xFFF87171).withValues(alpha: 0.35),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Yes, Continue',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFF87171),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteSuccessDialog(int count) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.textColor.withValues(alpha: 0.06),
                ),
                child: Center(
                  child: Icon(
                    Icons.delete_outline,
                    color: AppColors.textColor.withValues(alpha: 0.40),
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Chat History Deleted',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                count == 0
                    ? 'No conversations to remove.'
                    : 'All $count conversation${count == 1 ? '' : 's'} have been permanently removed from your account.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColor.withValues(alpha: 0.50),
                ),
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExportProgressDialog extends StatefulWidget {
  const _ExportProgressDialog({required this.items});

  final List<ChatHistoryItemModel> items;

  @override
  State<_ExportProgressDialog> createState() => _ExportProgressDialogState();
}

class _ExportProgressDialogState extends State<_ExportProgressDialog> {
  double _progress = 0;
  bool _isComplete = false;
  String? _exportFilePath;
  int _fileSizeBytes = 0;
  String? _exportError;

  static String _dateLabelForExport(String iso) {
    final t = iso.indexOf('T');
    if (t > 0) return iso.substring(0, t);
    if (iso.length >= 10) return iso.substring(0, 10);
    return iso.isEmpty ? '—' : iso;
  }

  static String _buildTxtContent(List<ChatHistoryItemModel> items) {
    final buf = StringBuffer();
    buf.writeln('Quick Question — Chat history export');
    buf.writeln('Exported: ${DateTime.now().toUtc().toIso8601String()}');
    buf.writeln('Conversations: ${items.length}');
    buf.writeln('');
    if (items.isEmpty) {
      buf.writeln('(No conversations to export.)');
      return buf.toString();
    }
    var i = 0;
    for (final e in items) {
      i++;
      buf.writeln(''.padRight(80, '='));
      buf.writeln('Conversation $i');
      buf.writeln('Date: ${_dateLabelForExport(e.createdAt)}');
      buf.writeln(''.padRight(80, '-'));
      buf.writeln('You:');
      buf.writeln(e.prompt.isEmpty ? '—' : e.prompt);
      buf.writeln('');
      buf.writeln('Assistant:');
      buf.writeln(e.aiResponse.isEmpty ? '—' : e.aiResponse);
      buf.writeln('');
    }
    return buf.toString();
  }

  static String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  void initState() {
    super.initState();
    _startExport();
  }

  Future<void> _startExport() async {
    setState(() {
      _progress = 0.15;
      _exportError = null;
    });
    try {
      final dir = await getTemporaryDirectory();
      final stamp = DateTime.now().toUtc().toIso8601String().replaceAll(
        RegExp(r'[:.]'),
        '-',
      );
      final path = '${dir.path}/chat_history_export_$stamp.txt';
      final file = File(path);
      final content = _buildTxtContent(widget.items);
      await file.writeAsString(content, flush: true);
      if (!mounted) return;
      final len = await file.length();
      setState(() {
        _progress = 1;
        _isComplete = true;
        _exportFilePath = path;
        _fileSizeBytes = len;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _exportError = e.toString();
        _progress = 0;
        _isComplete = true;
      });
    }
  }

  Future<void> _downloadTxtFile() async {
    final path = _exportFilePath;
    if (path == null) return;
    final bytes = await File(path).readAsBytes();
    final stamp = DateTime.now().toUtc().toIso8601String().replaceAll(
      RegExp(r'[:.]'),
      '-',
    );
    final baseName = 'chat_history_export_$stamp';

    try {
      final savedPath = await FileSaver.instance.saveAs(
        name: baseName,
        bytes: bytes,
        fileExtension: 'txt',
        mimeType: MimeType.text,
      );
      if (!mounted) return;
      if (savedPath == null || savedPath.isEmpty) {
        showCustomSnackBar('Download cancelled', isError: true);
        return;
      }
      if (savedPath.startsWith('Error') ||
          savedPath.contains('Something went wrong')) {
        showCustomSnackBar('Could not save file', isError: true);
        return;
      }
      _showSavedLocation(savedPath);
      Navigator.of(context).pop();
    } catch (e) {
      showCustomSnackBar('Could not save file: $e', isError: true);
    }
  }

  void _showSavedLocation(String filePath) {
    final folderPath = File(filePath).parent.path;
    Clipboard.setData(ClipboardData(text: filePath));
    showCustomSnackBar(
      'Downloaded in: $folderPath (full path copied)',
      isError: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isComplete) {
      if (_exportError != null) {
        return Dialog(
          backgroundColor: const Color(0xFF1A1A2E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: const Color(0xFFF87171).withValues(alpha: 0.9),
                ),
                const SizedBox(height: 16),
                Text(
                  'Export failed',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _exportError!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor.withValues(alpha: 0.50),
                  ),
                ),
                const SizedBox(height: 24),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: double.infinity,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: AppColors.textColor.withValues(alpha: 0.07),
                    ),
                    child: Center(
                      child: Text(
                        'Close',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor.withValues(alpha: 0.85),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return Dialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF34D399).withValues(alpha: 0.12),
                ),
                child: Center(child: Image.asset('assets/images/done.png')),
              ),
              const SizedBox(height: 16),
              const Text(
                'Export Ready!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF34D399),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your chat history is ready as a .txt file (${_formatFileSize(_fileSizeBytes)}). Tap Download to save it to your device.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColor.withValues(alpha: 0.45),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: AppColors.textColor.withValues(alpha: 0.07),
                        ),
                        child: Center(
                          child: Text(
                            'Close',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textColor.withValues(alpha: 0.60),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: _downloadTxtFile,
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: const Color(0xFF34D399),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icon/download.svg',
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF0F0F1A),
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 9),
                            const Text(
                              'Download',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F0F1A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Dialog(
      backgroundColor: const Color(0xFF1A1A2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              width: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFFA78BFA),
                ),
                backgroundColor: AppColors.textColor.withValues(alpha: 0.10),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Preparing Your Export...',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: AppColors.textColor.withValues(alpha: 0.10),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFFA78BFA),
                ),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${(_progress * 100).toInt()}% complete',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor.withValues(alpha: 0.40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
