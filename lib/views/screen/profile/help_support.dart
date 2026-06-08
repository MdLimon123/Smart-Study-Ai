import 'package:flutter/material.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:get/get.dart';

class HelpSupport extends StatefulWidget {
  const HelpSupport({super.key});

  @override
  State<HelpSupport> createState() => _HelpSupportState();
}

class _HelpSupportState extends State<HelpSupport> {
  final List<Map<String, String>> _faqs = [
    {
      'question': 'What is QUIZ QUESTION AI?',
      'answer': 'QUIZ QUESTION AI is an AI-powered educational assistant designed to help students solve homework problems, understand academic concepts, generate study materials, and improve learning across multiple subjects.\n\nThe platform supports subjects including:\n• Mathematics\n• Science\n• Physics\n• Chemistry\n• Biology\n• Literature\n• History\n• Business Studies\n• English Language\n• Social Sciences\n• And many more\n\nStudents can ask questions using text, screenshots, images, scanned documents, or AI chat conversations.',
    },
    {
      'question': 'How does QUIZ QUESTION AI work?',
      'answer': 'Using QUIZ QUESTION AI is simple:\n1. Type your question directly into the platform.\n2. Upload an image, screenshot, or document if needed.\n3. Our AI system analyzes the question instantly.\n4. Receive accurate answers, explanations, and learning guidance within seconds.\n\nThe platform is designed to provide both quick answers and deeper understanding.',
    },
    {
      'question': 'Is QUIZ QUESTION AI free to use?',
      'answer': 'Yes. QUIZ QUESTION AI offers free access to many features.\n\nPremium plans may include:\n• Unlimited AI questions\n• Faster responses\n• Advanced AI models\n• Unlimited image uploads\n• Extended document analysis\n• Priority support\n• Early access to new tools',
    },
    {
      'question': 'Which devices are supported?',
      'answer': 'QUIZ QUESTION AI works across multiple devices and platforms, including:\n• Web browsers\n• Android devices\n• iPhone & iPad\n• Tablets\n• Desktop computers',
    },
    {
      'question': 'Can I upload screenshots or photos of questions?',
      'answer': 'Yes. You can upload:\n• Homework screenshots\n• Math equations\n• PDF files\n• Worksheets\n• Handwritten notes\n• Camera images\n\nOur AI can analyze and solve problems directly from uploaded images and documents.',
    },
    {
      'question': 'Which subjects are supported?',
      'answer': 'QUIZ QUESTION AI supports a wide range of academic subjects including:\n• Algebra\n• Geometry\n• Calculus\n• Chemistry\n• Biology\n• Physics\n• Literature\n• History\n• Economics\n• Business\n• Computer Science\n• Grammar & Writing\n• Test Preparation',
    },
    {
      'question': 'Does the platform provide step-by-step explanations?',
      'answer': 'Yes. For many questions, QUIZ QUESTION AI provides detailed step-by-step solutions to help students understand the process, not just the final answer.\n\nThis helps improve learning, comprehension, and academic confidence.',
    },
    {
      'question': 'Can QUIZ QUESTION AI help with essays and writing?',
      'answer': 'Yes. The platform can assist with:\n• Essay generation\n• Grammar correction\n• Writing improvement\n• Content summarization\n• Research support\n• Citation guidance\n• Paragraph rewriting\n• Academic writing structure\n\nStudents should always review and personalize generated content before submission.',
    },
    {
      'question': 'Can the AI summarize textbooks or long documents?',
      'answer': 'Yes. QUIZ QUESTION AI can summarize:\n• PDFs\n• Articles\n• Research documents\n• Notes\n• Textbooks\n• Study materials\n\nThis helps students study more efficiently and save time.',
    },
    {
      'question': 'Does QUIZ QUESTION AI support multiple languages?',
      'answer': 'Yes. The platform supports multilingual learning and can assist users in many international languages.',
    },
    {
      'question': 'Do I need an account to use the platform?',
      'answer': 'Some features may be available without registration, but creating an account allows users to:\n• Save chat history\n• Access premium tools\n• Sync across devices\n• Store uploaded documents\n• Personalize learning experiences',
    },
    {
      'question': 'How do I reset my password?',
      'answer': 'Use the "Forgot Password" option on the login page and follow the instructions sent to your registered email address.\n\nIf you still experience issues, contact: feedback@quizquestionai.com',
    },
    {
      'question': 'How do I cancel my subscription?',
      'answer': 'You can manage or cancel your subscription through your account settings or through the platform where the subscription was purchased.\n\nAfter cancellation, premium access remains active until the end of the current billing cycle.',
    },
    {
      'question': 'Are payments secure?',
      'answer': 'Yes. QUIZ QUESTION AI uses secure payment technologies and encrypted systems to help protect user transactions and account information.',
    },
    {
      'question': 'Is my personal information safe?',
      'answer': 'Protecting user privacy is important to us. We use industry-standard security practices to help safeguard personal information and uploaded content.',
    },
    {
      'question': 'Are uploaded files stored permanently?',
      'answer': 'Uploaded files may be temporarily processed to improve user experience and AI functionality. Users may delete content from their accounts where supported.',
    },
    {
      'question': 'Does QUIZ QUESTION AI sell user data?',
      'answer': 'No. We do not sell personal user information to third parties.',
    },
    {
      'question': 'Why is my upload not working?',
      'answer': 'Common reasons include:\n• Unsupported file format\n• Large file size\n• Weak internet connection\n• Temporary server issues\n\nTry refreshing the page or uploading the file again.',
    },
    {
      'question': 'Why am I not receiving answers?',
      'answer': 'Possible reasons may include:\n• Network interruptions\n• Temporary platform maintenance\n• Unsupported question format\n• High server traffic\n\nPlease retry after a few moments.',
    },
    {
      'question': 'How can I report bugs or technical problems?',
      'answer': 'If you encounter any technical issues, errors, or unexpected behavior, please contact our support team:\nfeedback@quizquestionai.com\n\nInclude:\n• A description of the issue\n• Screenshots if available\n• Your device/browser information\n• Steps to reproduce the problem',
    },
    {
      'question': 'Should students rely entirely on AI-generated answers?',
      'answer': 'QUIZ QUESTION AI is designed to support learning and understanding. Students are encouraged to review explanations carefully and use the platform as an educational aid rather than a replacement for independent study.',
    },
    {
      'question': 'How can I contact QUIZ QUESTION AI?',
      'answer': 'Official Website: QUIZ QUESTION AI Official Website\nSupport Email: feedback@quizquestionai.com',
    },
  ];

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
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Help & Support",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
                Text(
                  'FAQ & contact',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor.withValues(alpha: 0.50),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Email Support
              // Text(
              //   "Email Support",
              //   style: TextStyle(
              //     fontSize: 16,
              //     fontWeight: FontWeight.w600,
              //     color: AppColors.textColor,
              //   ),
              // ),
              // const SizedBox(height: 12),

              // InkWell(
              //   onTap: () {},
              //   borderRadius: BorderRadius.circular(16),
              //   child: Container(
              //     width: double.infinity,
              //     padding: const EdgeInsets.all(14),
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(16),
              //       color: AppColors.textColor.withValues(alpha: 0.04),
              //       border: Border.all(
              //         color: AppColors.textColor.withValues(alpha: 0.07),
              //       ),
              //     ),
              //     child: Row(
              //       children: [
              //         Container(
              //           height: 40,
              //           width: 40,
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(12),
              //             color: const Color(
              //               0xFF34D399,
              //             ).withValues(alpha: 0.08),
              //           ),
              //           child: const Center(
              //             child: Icon(
              //               Icons.email_outlined,
              //               color: Color(0xFF34D399),
              //               size: 20,
              //             ),
              //           ),
              //         ),
              //         const SizedBox(width: 12),
              //         Expanded(
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(
              //                 "Email Support",
              //                 style: TextStyle(
              //                   fontSize: 14,
              //                   fontWeight: FontWeight.w500,
              //                   color: AppColors.textColor,
              //                 ),
              //               ),
              //               const SizedBox(height: 2),
              //               Text(
              //                 "Send us an email",
              //                 style: TextStyle(
              //                   fontSize: 11,
              //                   fontWeight: FontWeight.w400,
              //                   color: AppColors.textColor.withValues(
              //                     alpha: 0.40,
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //         Icon(
              //           Icons.navigate_next,
              //           color: AppColors.textColor.withValues(alpha: 0.25),
              //           size: 20,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              // const SizedBox(height: 24),

              // FAQ
              Text(
                "Frequently Asked Questions",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 12),

              ...List.generate(
                _faqs.length,
                (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(
                              0xFFA78BFA,
                            ).withValues(alpha: 0.10),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.help_outline,
                              color: Color(0xFFA78BFA),
                              size: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _faqs[i]['question']!,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _faqs[i]['answer']!,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textColor.withValues(
                                    alpha: 0.40,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // App Information's
              // Text(
              //   "App Information's",
              //   style: TextStyle(
              //     fontSize: 16,
              //     fontWeight: FontWeight.w600,
              //     color: AppColors.textColor,
              //   ),
              // ),
              // const SizedBox(height: 12),

              // Container(
              //   width: double.infinity,
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 16,
              //     vertical: 6,
              //   ),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(16),
              //     color: AppColors.textColor.withValues(alpha: 0.04),
              //     border: Border.all(
              //       color: AppColors.textColor.withValues(alpha: 0.07),
              //     ),
              //   ),
              //   child: Column(
              //     children: [
              //       _infoRow("Version", "2.4.1"),
              //       Divider(
              //         height: 1,
              //         color: AppColors.textColor.withValues(alpha: 0.05),
              //       ),
              //       _infoRow("Last Updated", "Feb 20, 2026"),
              //       Divider(
              //         height: 1,
              //         color: AppColors.textColor.withValues(alpha: 0.05),
              //       ),
              //       _infoRow("Build", "241.2024"),
              //     ],
              //   ),
              // ),

              // const SizedBox(height: 24),

              // // Rate Now banner
              // Container(
              //   width: double.infinity,
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 20,
              //     vertical: 16,
              //   ),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(16),
              //     gradient: const LinearGradient(
              //       colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
              //     ),
              //   ),
              //   child: Row(
              //     children: [
              //       const Icon(Icons.star, color: Color(0xFFFBBF24), size: 24),
              //       const SizedBox(width: 12),
              //       Expanded(
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               "Enjoying the app?",
              //               style: TextStyle(
              //                 fontSize: 14,
              //                 fontWeight: FontWeight.w600,
              //                 color: AppColors.textColor,
              //               ),
              //             ),
              //             const SizedBox(height: 2),
              //             Text(
              //               "Rate us on the app store",
              //               style: TextStyle(
              //                 fontSize: 11,
              //                 fontWeight: FontWeight.w400,
              //                 color: AppColors.textColor.withValues(
              //                   alpha: 0.60,
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //       InkWell(
              //         onTap: () {},
              //         child: Container(
              //           padding: const EdgeInsets.symmetric(
              //             horizontal: 16,
              //             vertical: 8,
              //           ),
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(10),
              //             color: Colors.white,
              //           ),
              //           child: const Text(
              //             "Rate Now",
              //             style: TextStyle(
              //               fontSize: 12,
              //               fontWeight: FontWeight.w700,
              //               color: Color(0xFF7C3AED),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.textColor.withValues(alpha: 0.50),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
