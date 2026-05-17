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
      'question': 'How do I upgrade to Premium?',
      'answer': "Tap the 'Upgrade to Premium' button on your profile",
    },
    {
      'question': 'How many scans do I get per day?',
      'answer': 'Free plan: 3 scans/day, Premium: Unlimited',
    },
    {
      'question': 'How do I earn badges?',
      'answer': 'Complete challenges and maintain study streaks',
    },
    {
      'question': 'Can I export my study data?',
      'answer': 'Yes, go to Privacy & Security > Data Management',
    },
    {
      'question': 'How do I earn badges?',
      'answer': 'Complete challenges and maintain study streaks',
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
