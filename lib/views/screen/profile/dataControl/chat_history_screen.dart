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
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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
      backgroundColor: AppColors.backgroundColor,
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
        backgroundColor: AppColors.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.borderColor),
        ),
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
        backgroundColor: AppColors.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.borderColor),
        ),
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

  static String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  List<pw.Widget> _splitLongText(String text, pw.TextStyle style) {
    final List<pw.Widget> result = [];
    final lines = text.split('\n');
    for (final line in lines) {
      if (line.trim().isEmpty) {
        result.add(pw.SizedBox(height: 4));
        continue;
      }
      if (line.length > 500) {
        var start = 0;
        while (start < line.length) {
          var end = start + 500;
          if (end > line.length) end = line.length;
          
          if (end < line.length) {
            final lastSpace = line.substring(start, end).lastIndexOf(' ');
            if (lastSpace > 100) {
              end = start + lastSpace + 1;
            }
          }
          
          result.add(
            pw.Text(
              line.substring(start, end),
              style: style,
            ),
          );
          start = end;
        }
      } else {
        result.add(
          pw.Text(
            line,
            style: style,
          ),
        );
      }
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    _startExport();
  }

  Future<void> _startExport() async {
    setState(() {
      _progress = 0.10;
      _exportError = null;
    });
    try {
      final pdf = pw.Document();

      // Load Lato font from assets so we support standard characters beautifully
      final fontData = await rootBundle.load("assets/fonts/Lato-Regular.ttf");
      final font = pw.Font.ttf(fontData);
      
      setState(() {
        _progress = 0.35;
      });

      final boldFontData = await rootBundle.load("assets/fonts/Lato-Bold.ttf");
      final boldFont = pw.Font.ttf(boldFontData);

      setState(() {
        _progress = 0.55;
      });

      final theme = pw.ThemeData.withFont(
        base: font,
        bold: boldFont,
      );

      pdf.addPage(
        pw.MultiPage(
          theme: theme,
          pageFormat: PdfPageFormat.a4,
          maxPages: 10000,
          margin: const pw.EdgeInsets.all(36),
          build: (pw.Context context) {
            final List<pw.Widget> widgets = [];
            
            // Beautiful Header Banner
            widgets.add(
              pw.Container(
                padding: const pw.EdgeInsets.only(bottom: 12),
                decoration: const pw.BoxDecoration(
                  border: pw.Border(
                    bottom: pw.BorderSide(color: PdfColors.purple100, width: 2),
                  ),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Quick Question AI',
                          style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColor.fromHex('#7C3AED'),
                          ),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          'Smart Study Companion — Chat History Export',
                          style: const pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.grey700,
                          ),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'Conversations: ${widget.items.length}',
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.grey700,
                          ),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          'Date: ${_dateLabelForExport(DateTime.now().toUtc().toIso8601String())}',
                          style: const pw.TextStyle(
                            fontSize: 8,
                            color: PdfColors.grey500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
            
            widgets.add(pw.SizedBox(height: 20));

            if (widget.items.isEmpty) {
              widgets.add(
                pw.Center(
                  child: pw.Text(
                    'No conversations to export.',
                    style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey500),
                  ),
                ),
              );
            } else {
              for (var index = 0; index < widget.items.length; index++) {
                final e = widget.items[index];
                
                // Add conversation title and date bar
                widgets.add(
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#F3F4F6'),
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                      border: pw.Border.all(color: PdfColor.fromHex('#E5E7EB'), width: 0.5),
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Conversation ${index + 1}',
                          style: pw.TextStyle(
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.grey900,
                          ),
                        ),
                        pw.Text(
                          _dateLabelForExport(e.createdAt),
                          style: const pw.TextStyle(
                            fontSize: 9,
                            color: PdfColors.grey500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
                
                widgets.add(pw.SizedBox(height: 8));
                
                // User Prompt
                widgets.add(
                  pw.Text(
                    'YOU',
                    style: pw.TextStyle(
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.grey600,
                      letterSpacing: 0.5,
                    ),
                  ),
                );
                widgets.add(pw.SizedBox(height: 3));
                widgets.addAll(
                  _splitLongText(
                    e.prompt.isEmpty ? '—' : e.prompt,
                    const pw.TextStyle(
                      fontSize: 11,
                      color: PdfColors.black,
                    ),
                  ),
                );
                widgets.add(pw.SizedBox(height: 12));

                // AI Response
                widgets.add(
                  pw.Text(
                    'ASSISTANT',
                    style: pw.TextStyle(
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex('#7C3AED'),
                      letterSpacing: 0.5,
                    ),
                  ),
                );
                widgets.add(pw.SizedBox(height: 3));
                widgets.addAll(
                  _splitLongText(
                    e.aiResponse.isEmpty ? '—' : e.aiResponse,
                    pw.TextStyle(
                      fontSize: 10.5,
                      color: PdfColor.fromHex('#1F2937'),
                    ),
                  ),
                );
                
                widgets.add(pw.SizedBox(height: 14));
                widgets.add(pw.Divider(color: PdfColor.fromHex('#E5E7EB'), thickness: 0.5));
                widgets.add(pw.SizedBox(height: 14));
              }
            }
            
            return widgets;
          },
        ),
      );

      setState(() {
        _progress = 0.85;
      });

      final dir = await getTemporaryDirectory();
      final stamp = DateTime.now().toUtc().toIso8601String().replaceAll(
        RegExp(r'[:.]'),
        '-',
      );
      final path = '${dir.path}/chat_history_export_$stamp.pdf';
      final file = File(path);
      final bytes = await pdf.save();
      await file.writeAsBytes(bytes, flush: true);

      if (!mounted) return;
      final len = await file.length();
      setState(() {
        _progress = 1.0;
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

  Future<void> _downloadPdfFile() async {
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
        fileExtension: 'pdf',
        mimeType: MimeType.pdf,
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
      await OpenFile.open(savedPath);
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
          backgroundColor: AppColors.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: AppColors.borderColor),
          ),
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
        backgroundColor: AppColors.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.borderColor),
        ),
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
                'Your chat history is ready as a PDF file (${_formatFileSize(_fileSizeBytes)}). Tap Download to save it to your device.',
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
                      onTap: _downloadPdfFile,
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
                              colorFilter: ColorFilter.mode(
                                AppColors.backgroundColor,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 9),
                            Text(
                              'Download',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.backgroundColor,
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
      backgroundColor: AppColors.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.borderColor),
      ),
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
              'Preparing Your PDF Export...',
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
