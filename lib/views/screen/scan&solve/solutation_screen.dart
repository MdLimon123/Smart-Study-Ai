import 'package:flutter/material.dart';
import 'package:flutter_extension/data/model/scan_result_model.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:markdown/markdown.dart' as md;

class SolutationScreen extends StatefulWidget {
  final ScanResultModel result;

  const SolutationScreen({super.key, required this.result});

  @override
  State<SolutationScreen> createState() => _SolutationScreenState();
}

class _SolutationScreenState extends State<SolutationScreen> {
  String _subjectLabel(String raw) {
    final s = raw.trim().toLowerCase();
    if (s.isEmpty) return '—';
    return s[0].toUpperCase() + (s.length > 1 ? s.substring(1) : '');
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.result;
    final subjectLabel = _subjectLabel(r.subject);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leadingWidth: 56,
        leading: InkWell(
          onTap: () => Get.back(),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.textColor.withValues(alpha: 0.04),
            ),
            child: Icon(Icons.arrow_back, color: AppColors.textColor),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Scan & Solve",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "3 scans remaining today",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor.withValues(alpha: 0.40),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFFA78BFA).withValues(alpha: 0.08),
                  border: Border.all(
                    color: const Color(0xFFA78BFA).withValues(alpha: 0.20),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (r.subject.trim().isNotEmpty && r.subject.trim().toLowerCase() != 'general') ...[
                      Text(
                        "Subject",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor.withValues(alpha: 0.40),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subjectLabel,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    Row(
                      children: [
                        SvgPicture.asset('assets/icon/right.svg'),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            r.scanId.isNotEmpty
                                ? "AI analysis · ${r.scanId.length > 12 ? '${r.scanId.substring(0, 12)}…' : r.scanId}"
                                : "AI analysis complete",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF34D399),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                "Solution",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.textColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.textColor.withValues(alpha: 0.08),
                  ),
                ),
                child: _SolutionMarkdown(text: r.aiResponse),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 20),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.textColor.withValues(
                        alpha: 0.07,
                      ),
                      side: BorderSide(
                        color: AppColors.textColor.withValues(alpha: 0.15),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      "Scan Again",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor.withValues(alpha: 0.70),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}

/// Renders API `ai_response` as Markdown plus inline/display LaTeX from the model.
class _SolutionMarkdown extends StatelessWidget {
  const _SolutionMarkdown({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final baseColor = AppColors.textColor.withValues(alpha: 0.92);
    final baseStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.55,
      color: baseColor,
    );

    final data = text.trim().isEmpty ? '_No solution text._' : text;

    return SelectionArea(
      child: MarkdownBody(
        data: data,
        selectable: false,
        styleSheet: MarkdownStyleSheet(
          p: baseStyle,
          h1: baseStyle.copyWith(fontSize: 24, fontWeight: FontWeight.w800, height: 1.35),
          h2: baseStyle.copyWith(fontSize: 21, fontWeight: FontWeight.w800, height: 1.4),
          h3: baseStyle.copyWith(fontSize: 19, fontWeight: FontWeight.w800, height: 1.45),
          h4: baseStyle.copyWith(fontSize: 18, fontWeight: FontWeight.w700, height: 1.45),
          h5: baseStyle.copyWith(fontSize: 17, fontWeight: FontWeight.w700, height: 1.45),
          h6: baseStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w600, height: 1.45),
          strong: baseStyle.copyWith(fontWeight: FontWeight.w700),
          em: baseStyle.copyWith(fontStyle: FontStyle.italic),
          code: baseStyle.copyWith(
            fontFamily: 'monospace',
            fontSize: 15,
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
      ),
    );
  }
}
