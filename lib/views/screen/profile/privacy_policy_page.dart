import 'package:flutter/material.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:get/get.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
                  "Privacy Policy",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
                Text(
                  'Legal Information',
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
              _section(
                "QUIZ QUESTION AI PRIVACY POLICY",
                "Effective Date: May 22, 2026\n\n"
                "This Privacy Policy (“Policy”) applies to Quiz Question AI, an artificial intelligence-powered educational and learning platform, including all related websites, applications, software, AI tools, content, features, prompts, APIs, and services (collectively, the “Services”) operated by Quiz Question AI LLC (“Company,” “we,” “our,” or “us”).\n\n"
                "This Policy explains how we collect, use, store, process, disclose, and protect personal information when users access or use Quiz Question AI and related Services.\n\n"
                "By accessing or using Quiz Question AI, you acknowledge that you have read, understood, and agreed to this Privacy Policy and our Terms of Use.",
              ),
              _section(
                "1. ELIGIBILITY, AGE REQUIREMENTS & PARENTAL CONTROL",
                "Quiz Question AI is intended for users who are at least eighteen (18) years of age or older.\n"
                "Users under the age of 18 may only use Quiz Question AI under the direct supervision, monitoring, and consent of a parent or legal guardian through our parental control and safety framework.\n\n"
                "Parents and guardians are solely responsible for:\n"
                "• supervising underage users;\n"
                "• monitoring AI-generated responses and prompts;\n"
                "• controlling account activity;\n"
                "• reviewing educational content;\n"
                "• restricting inappropriate usage; and\n"
                "• ensuring compliance with applicable laws.\n\n"
                "We reserve the right to restrict, suspend, or terminate accounts used by minors without proper parental authorization.\n"
                "We comply with applicable United States child privacy laws, including the Children’s Online Privacy Protection Act (“COPPA”), where applicable.\n"
                "We do not knowingly collect personal information from children without verifiable parental consent where required by law.\n\n"
                "Parents or legal guardians may request:\n"
                "• access to a child’s information;\n"
                "• deletion of child-related data;\n"
                "• account restrictions; or\n"
                "• termination of a minor’s account.\n"
                "Requests may be submitted to: info@quizquestionai.com",
              ),
              _section(
                "2. IMPORTANT AI & LEGAL DISCLAIMER",
                "Quiz Question AI utilizes artificial intelligence systems, machine learning technologies, and third-party API models provided by external technology providers.\n\n"
                "AI-generated responses, prompts, recommendations, educational materials, summaries, or outputs may:\n"
                "• contain inaccuracies;\n"
                "• be incomplete or outdated;\n"
                "• contain errors or hallucinations;\n"
                "• not constitute professional advice; and\n"
                "• not always reflect current legal, medical, financial, academic, or factual standards.\n\n"
                "Users acknowledge and agree that:\n"
                "• all AI-generated content is provided “AS IS” and “AS AVAILABLE”;\n"
                "• reliance on AI-generated content is solely at the user’s own risk;\n"
                "• Quiz Question AI LLC does not guarantee the accuracy, completeness, legality, reliability, or suitability of AI outputs;\n"
                "• users should independently verify all information before making educational, legal, financial, medical, business, or personal decisions.\n\n"
                "Quiz Question AI LLC is not a law firm, medical provider, financial advisor, educational institution, or licensed professional service provider.\n"
                "Users are strongly advised to consult qualified legal counsel, educators, medical professionals, or other licensed professionals before relying on AI-generated information.",
              ),
              _section(
                "3. INFORMATION WE COLLECT",
                "We may collect the following categories of information:\n\n"
                "3.1 Personal Information You Provide\n"
                "This may include:\n"
                "• name;\n"
                "• email address;\n"
                "• username;\n"
                "• profile information;\n"
                "• uploaded images;\n"
                "• text prompts;\n"
                "• educational materials;\n"
                "• PDF files;\n"
                "• customer support communications;\n"
                "• payment confirmations;\n"
                "• subscription records.\n\n"
                "3.2 Automatically Collected Information\n"
                "We may automatically collect:\n"
                "• IP address;\n"
                "• browser type;\n"
                "• device identifiers;\n"
                "• operating system;\n"
                "• app usage statistics;\n"
                "• log files;\n"
                "• device performance data;\n"
                "• cookies and analytics data.\n\n"
                "3.3 AI Prompt & Uploaded Content\n"
                "When users submit prompts, upload files, or use AI features, submitted content may be processed by:\n"
                "• Quiz Question AI systems;\n"
                "• third-party AI API providers;\n"
                "• cloud hosting providers; and\n"
                "• infrastructure partners.\n\n"
                "Users should not upload:\n"
                "• confidential legal documents;\n"
                "• highly sensitive financial data;\n"
                "• medical records;\n"
                "• passwords;\n"
                "• government identification documents; or\n"
                "• protected confidential information.",
              ),
              _section(
                "4. HOW WE USE INFORMATION",
                "We may use collected information to:\n"
                "• provide and improve Services;\n"
                "• personalize user experiences;\n"
                "• process payments and subscriptions;\n"
                "• maintain platform security;\n"
                "• detect fraud and abuse;\n"
                "• improve AI functionality;\n"
                "• provide customer support;\n"
                "• enforce legal rights and policies;\n"
                "• comply with legal obligations;\n"
                "• analyze system performance;\n"
                "• protect users and the Company.",
              ),
              _section(
                "5. THIRD-PARTY SERVICES & AI PROVIDERS",
                "Quiz Question AI may integrate with third-party technologies, including:\n"
                "• AI API providers;\n"
                "• cloud hosting platforms;\n"
                "• payment processors;\n"
                "• analytics services;\n"
                "• authentication providers;\n"
                "• customer support systems.\n\n"
                "Third-party providers may independently collect and process information subject to their own privacy policies and terms.\n"
                "Quiz Question AI LLC is not responsible for:\n"
                "• third-party platform errors;\n"
                "• AI hallucinations;\n"
                "• outages;\n"
                "• unauthorized third-party conduct;\n"
                "• data transmission interruptions; or\n"
                "• external platform privacy practices.\n\n"
                "Use of third-party integrations is at the user’s own risk.",
              ),
              _section(
                "6. PAYMENTS & SUBSCRIPTIONS",
                "Certain Services may require paid subscriptions or purchases.\n"
                "Payments may be processed through authorized third-party payment providers, including:\n"
                "• Stripe;\n"
                "• Apple Pay;\n"
                "• Google Pay;\n"
                "• debit cards;\n"
                "• credit cards.\n\n"
                "We do not store full payment card numbers on our servers.\n"
                "Users agree that subscription purchases may renew automatically unless canceled in accordance with applicable billing terms.",
              ),
              _section(
                "7. COOKIES & TRACKING TECHNOLOGIES",
                "We may use cookies, analytics tools, and similar technologies to:\n"
                "• improve functionality;\n"
                "• remember user preferences;\n"
                "• analyze traffic;\n"
                "• maintain security;\n"
                "• optimize performance.\n\n"
                "Users may disable cookies through browser settings, though some features may not function properly.",
              ),
              _section(
                "8. DATA SHARING & DISCLOSURE",
                "We may share information:\n"
                "• with service providers;\n"
                "• with AI technology providers;\n"
                "• with payment processors;\n"
                "• with legal authorities when required by law;\n"
                "• during mergers, acquisitions, or business restructuring;\n"
                "• to protect legal rights, users, or platform security.\n\n"
                "We do not sell personal information in violation of applicable U.S. privacy laws.",
              ),
              _section(
                "9. DATA SECURITY",
                "We implement commercially reasonable administrative, technical, and physical safeguards designed to protect user information.\n"
                "However, no online platform, cloud system, AI platform, transmission method, or electronic storage system is completely secure.\n"
                "Users acknowledge and accept all cybersecurity and internet-related risks associated with online services.\n\n"
                "Quiz Question AI LLC disclaims liability for:\n"
                "• hacking;\n"
                "• unauthorized access;\n"
                "• cyberattacks;\n"
                "• system failures;\n"
                "• data breaches beyond reasonable control;\n"
                "• internet interruptions; or\n"
                "• force majeure events.",
              ),
              _section(
                "10. DATA RETENTION",
                "We retain information only for as long as reasonably necessary to:\n"
                "• operate Services;\n"
                "• comply with legal obligations;\n"
                "• resolve disputes;\n"
                "• enforce agreements;\n"
                "• maintain security and business operations.\n\n"
                "We may retain anonymized or aggregated data indefinitely for analytics, research, AI improvement, and lawful business purposes.",
              ),
              _section(
                "11. USER RIGHTS",
                "Subject to applicable U.S. laws, users may request:\n"
                "• access to personal information;\n"
                "• correction of inaccurate information;\n"
                "• deletion of eligible information;\n"
                "• withdrawal of certain consents;\n"
                "• account termination.\n\n"
                "We may deny requests where permitted by law, including:\n"
                "• security concerns;\n"
                "• fraud prevention;\n"
                "• legal compliance obligations;\n"
                "• unresolved disputes;\n"
                "• protection of Company rights.",
              ),
              _section(
                "12. ACCOUNT TERMINATION",
                "We reserve the right, at our sole discretion, to suspend, restrict, or terminate any account for:\n"
                "• misuse of Services;\n"
                "• unlawful conduct;\n"
                "• harmful prompts;\n"
                "• abusive behavior;\n"
                "• policy violations;\n"
                "• suspected fraud;\n"
                "• security risks;\n"
                "• unauthorized automated usage.\n\n"
                "Termination decisions may be made without prior notice.",
              ),
              _section(
                "13. LIMITATION OF LIABILITY",
                "TO THE MAXIMUM EXTENT PERMITTED UNDER APPLICABLE LAW:\n"
                "QUIZ QUESTION AI LLC DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, ACCURACY, AND NON-INFRINGEMENT.\n\n"
                "QUIZ QUESTION AI LLC SHALL NOT BE LIABLE FOR:\n"
                "• AI-GENERATED ERRORS;\n"
                "• USER RELIANCE ON AI OUTPUTS;\n"
                "• EDUCATIONAL OUTCOMES;\n"
                "• BUSINESS DECISIONS;\n"
                "• LEGAL OR FINANCIAL LOSSES;\n"
                "• DATA LOSS;\n"
                "• INDIRECT DAMAGES;\n"
                "• CONSEQUENTIAL DAMAGES;\n"
                "• LOST PROFITS;\n"
                "• SERVICE INTERRUPTIONS.\n\n"
                "USE OF QUIZ QUESTION AI IS ENTIRELY AT THE USER’S OWN RISK.",
              ),
              _section(
                "14. INTERNATIONAL USERS",
                "Users accessing Services outside the United States acknowledge that their information may be transferred to and processed within the United States or other jurisdictions where our providers operate.",
              ),
              _section(
                "15. CHANGES TO THIS POLICY",
                "We reserve the right to update or modify this Privacy Policy at any time without prior notice.\n"
                "Updated versions become effective immediately upon posting.\n"
                "Continued use of Quiz Question AI after updates constitutes acceptance of revised terms.",
              ),
              _section(
                "16. CONTACT INFORMATION",
                "If you have questions regarding this Privacy Policy or user privacy matters, please contact:\n\n"
                "Quiz Question AI LLC\n"
                "1177 Annapolis Rd, Unit 91\n"
                "Odenton, MD 21113\n"
                "United States\n"
                "Email: info@quizquestionai.com",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) ...[
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Text(
          content,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: AppColors.textColor.withValues(alpha: 0.60),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}