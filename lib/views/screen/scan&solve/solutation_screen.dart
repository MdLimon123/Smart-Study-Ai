import 'package:flutter/material.dart';
import 'package:flutter_extension/data/model/scan_result_model.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

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
                      fontSize: 24,
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
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor.withValues(alpha: 0.40),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: AppColors.textColor.withValues(alpha: 0.07),
                shape: BoxShape.circle,
              ),
              child: Center(child: SvgPicture.asset('assets/icon/touch.svg')),
            ),
            const SizedBox(width: 8),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: AppColors.textColor.withValues(alpha: 0.07),
                shape: BoxShape.circle,
              ),
              child: Center(child: SvgPicture.asset('assets/icon/attch.svg')),
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
                    Text(
                      "Subject",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor.withValues(alpha: 0.40),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subjectLabel,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
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
                              fontSize: 12,
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
                  fontSize: 17,
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 24),
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
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor.withValues(alpha: 0.70),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Expanded(
            //   child: SizedBox(
            //     height: 50,
            //     child: DecoratedBox(
            //       decoration: BoxDecoration(
            //         gradient: const LinearGradient(
            //           colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
            //         ),
            //         borderRadius: BorderRadius.circular(14),
            //       ),
            //       child: ElevatedButton(
            //         onPressed: () {},
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor: Colors.transparent,
            //           shadowColor: Colors.transparent,
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(16),
            //           ),
            //         ),
            //         child: FittedBox(
            //           fit: BoxFit.scaleDown,
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               Text(
            //                 "Save to Library",
            //                 style: TextStyle(
            //                   fontSize: 15,
            //                   fontWeight: FontWeight.w700,
            //                   color: AppColors.textColor,
            //                 ),
            //               ),
            //               const SizedBox(width: 2),
            //               Icon(
            //                 Icons.chevron_right,
            //                 color: AppColors.textColor,
            //                 size: 18,
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
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
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.55,
      color: baseColor,
    );

    return GptMarkdownTheme(
      gptThemeData: GptMarkdownThemeData(
        brightness: Brightness.dark,
        h1: baseStyle.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          height: 1.35,
        ),
        h2: baseStyle.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          height: 1.4,
        ),
        h3: baseStyle.copyWith(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          height: 1.45,
        ),
        h4: baseStyle.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          height: 1.45,
        ),
        h5: baseStyle.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          height: 1.45,
        ),
        h6: baseStyle.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.45,
        ),
        linkColor: const Color(0xFF93C5FD),
      ),
      child: GptMarkdown(
        text.trim().isEmpty ? '_No solution text._' : text,
        style: baseStyle,
        textAlign: TextAlign.start,
        latexBuilder: (context, tex, textStyle, inline) {
          final screenWidth = MediaQuery.sizeOf(context).width;
          final safeWidth = (screenWidth - 80).clamp(160.0, screenWidth);
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

          // Prevent RenderLine horizontal overflow on long equations.
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
