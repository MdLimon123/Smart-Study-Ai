import 'package:flutter/material.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:get/get.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

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
                  "Terms of Service",
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
                "Quiz Question AI Terms of Use",
                "Effective Date: May 22, 2026\n\n"
                "Table of Contents\n"
                "1. Introduction and Legal Agreement\n"
                "2. Eligibility, Age Restrictions, and Parental Controls\n"
                "3. Privacy and Data Usage\n"
                "4. Description of Services\n"
                "5. Third-Party AI Systems and External Technologies\n"
                "6. Account Registration and Security\n"
                "7. Acceptable Use Policy\n"
                "8. Subscription Plans, Billing, and Payments\n"
                "9. Ownership of Intellectual Property\n"
                "10. AI-Generated Content and Accuracy Disclaimer\n"
                "11. Copyright and DMCA Compliance\n"
                "12. Service Changes, Suspension, and Termination\n"
                "13. Disclaimer of Warranties\n"
                "14. Limitation of Liability\n"
                "15. User Responsibility and Indemnification\n"
                "16. Governing Law and Arbitration\n"
                "17. Contact Details",
              ),
              _section(
                "1. Introduction and Legal Agreement",
                "Welcome to Quiz Question AI.\n\n"
                "These Terms of Use (“Terms”) govern your access to and use of the Quiz Question AI platform, mobile applications, websites, APIs, software systems, educational technologies, artificial intelligence tools, and related services (collectively, the “Platform” or “Services”) operated by Quiz Question AI LLC (“Quiz Question AI,” “Company,” “we,” “our,” or “us”).\n\n"
                "By accessing, downloading, installing, browsing, creating an account, subscribing to, or otherwise using the Services, you acknowledge that you have read, understood, and agreed to be legally bound by these Terms and all applicable United States federal, state, and local laws and regulations.\n\n"
                "If you do not agree with these Terms, you must immediately stop using the Services.\n"
                "These Terms form a legally binding agreement between you and Quiz Question AI LLC without requiring handwritten or electronic signatures.",
              ),
              _section(
                "2. Eligibility, Age Restrictions, and Parental Controls",
                "Quiz Question AI is designed primarily for individuals who are eighteen (18) years of age or older.\n"
                "By accessing or using the Services, you represent and warrant that:\n"
                "• You are at least eighteen (18) years old;\n"
                "• You possess the legal authority to enter into binding agreements;\n"
                "• You will comply with all applicable laws and regulations;\n"
                "• All information submitted to the Company is truthful, accurate, and current.\n\n"
                "Minor Users and Parental Oversight\n"
                "Users under the age of eighteen (18) may only access Quiz Question AI through authorized parental supervision and parental control systems provided or approved by the Company.\n"
                "Parents and legal guardians acknowledge and agree that they are solely responsible for:\n"
                "• Supervising a minor’s access and activities;\n"
                "• Reviewing prompts, AI outputs, and interactions;\n"
                "• Monitoring educational and behavioral use;\n"
                "• Preventing misuse of AI-generated information;\n"
                "• Managing account restrictions and safety settings;\n"
                "• Determining whether the Services are appropriate for the child.\n\n"
                "Quiz Question AI reserves the right to restrict, suspend, or permanently terminate accounts suspected of unauthorized underage usage or violations of child safety protections.",
              ),
              _section(
                "3. Privacy and Data Usage",
                "Quiz Question AI values user privacy and data protection.\n"
                "By using the Services, you consent to the collection, storage, processing, transfer, and use of information in accordance with our Privacy Policy and applicable United States privacy laws.\n"
                "Information collected may include:\n"
                "• Account registration information;\n"
                "• Uploaded files, images, and documents;\n"
                "• User prompts and AI conversations;\n"
                "• Device identifiers and browser data;\n"
                "• Usage analytics and system logs;\n"
                "• Subscription and payment information;\n"
                "• IP addresses and security monitoring data.\n\n"
                "We may utilize third-party providers, including:\n"
                "• AI model providers;\n"
                "• Cloud hosting providers;\n"
                "• Analytics services;\n"
                "• Authentication systems;\n"
                "• Payment processors;\n"
                "• Infrastructure and security vendors.\n\n"
                "You acknowledge that no online transmission or storage method is completely secure, and Quiz Question AI cannot guarantee absolute security of information transmitted through the Internet.",
              ),
              _section(
                "4. Description of Services",
                "Quiz Question AI offers AI-powered educational, productivity, and informational technologies, including but not limited to:\n"
                "• AI-generated question answering;\n"
                "• Quiz creation and academic support;\n"
                "• Study assistance and tutoring;\n"
                "• OCR scanning and “scan-and-solve” technologies;\n"
                "• AI chatbot systems;\n"
                "• Prompt-based educational tools;\n"
                "• Multi-model AI integrations;\n"
                "• Educational content generation;\n"
                "• Research and productivity assistance.\n\n"
                "The Services may evolve, expand, or change over time without notice.\n"
                "Quiz Question AI reserves the right to modify, suspend, discontinue, or update any feature, function, or portion of the Services at any time.",
              ),
              _section(
                "5. Third-Party AI Systems and External Technologies",
                "Quiz Question AI integrates and relies on third-party artificial intelligence systems, APIs, machine learning technologies, cloud providers, and external infrastructure services.\n"
                "Because these technologies are operated independently:\n"
                "• We do not control all AI-generated outputs;\n"
                "• AI responses may contain inaccuracies, hallucinations, incomplete information, bias, or offensive content;\n"
                "• External AI systems may experience outages, interruptions, or service limitations;\n"
                "• Third-party providers may alter or discontinue services at any time without notice.\n\n"
                "You acknowledge and agree that:\n"
                "• AI-generated information is not guaranteed to be accurate or reliable;\n"
                "• Outputs should not be interpreted as legal, financial, medical, educational, psychological, or professional advice;\n"
                "• Users must independently verify information before relying upon it;\n"
                "• Quiz Question AI LLC is not responsible for decisions made based on AI-generated outputs.\n\n"
                "You are strongly advised to consult licensed professionals, including attorneys, physicians, financial advisors, educators, or other qualified experts before making important decisions based on AI-generated information.",
              ),
              _section(
                "6. Account Registration and Security",
                "Certain features of the Services may require user registration.\n"
                "Users may create accounts using approved authentication methods, including:\n"
                "• Email registration;\n"
                "• Google authentication;\n"
                "• Apple authentication;\n"
                "• Other authorized sign-in providers.\n\n"
                "You agree to:\n"
                "• Maintain accurate and updated account information;\n"
                "• Protect account credentials and passwords;\n"
                "• Notify us immediately of unauthorized access;\n"
                "• Accept responsibility for all activities occurring under your account.\n\n"
                "Quiz Question AI reserves the right to suspend, restrict, investigate, or terminate accounts involved in:\n"
                "• Fraudulent activity;\n"
                "• Unauthorized access attempts;\n"
                "• Violations of these Terms;\n"
                "• Illegal conduct;\n"
                "• Platform abuse;\n"
                "• Harmful automation or scraping;\n"
                "• Security threats or suspicious behavior.",
              ),
              _section(
                "7. Acceptable Use Policy",
                "You agree not to use the Services to:\n"
                "• Violate any law, regulation, or court order;\n"
                "• Infringe copyrights, trademarks, or intellectual property rights;\n"
                "• Upload viruses, malware, or harmful software;\n"
                "• Harass, threaten, exploit, or abuse others;\n"
                "• Generate unlawful, deceptive, or fraudulent content;\n"
                "• Circumvent security protections or access controls;\n"
                "• Reverse engineer or copy the platform;\n"
                "• Engage in unauthorized scraping or automated extraction;\n"
                "• Upload harmful, obscene, or inappropriate materials;\n"
                "• Distribute misleading or dangerous AI-generated information;\n"
                "• Interfere with platform operations or network integrity.\n\n"
                "Quiz Question AI may investigate violations and cooperate with law enforcement authorities where legally required.",
              ),
              _section(
                "8. Subscription Plans, Billing, and Payments",
                "Certain features and Services may require payment, subscription enrollment, or in-app purchases.\n"
                "By purchasing paid Services, you acknowledge and agree that:\n"
                "• Prices are listed in U.S. Dollars unless otherwise stated;\n"
                "• Subscription plans may renew automatically;\n"
                "• You authorize recurring billing until cancellation;\n"
                "• Payments are processed through authorized third-party payment providers;\n"
                "• Taxes and applicable fees may apply;\n"
                "• All purchases are final except where required by law.\n\n"
                "You may cancel subscriptions through your account settings or the applicable app marketplace provider.\n"
                "Quiz Question AI reserves the right to:\n"
                "• Change pricing structures;\n"
                "• Modify subscription plans;\n"
                "• Add or remove paid features;\n"
                "• Limit promotional offers;\n"
                "• Suspend or discontinue paid Services.",
              ),
              _section(
                "9. Ownership of Intellectual Property",
                "All rights, title, and interests in the Services and related technologies remain the exclusive property of Quiz Question AI LLC or its licensors.\n"
                "Protected materials include, but are not limited to:\n"
                "• Software and source code;\n"
                "• AI systems and algorithms;\n"
                "• Trademarks and branding;\n"
                "• Logos and graphics;\n"
                "• Databases and interfaces;\n"
                "• Educational technologies;\n"
                "• Website designs and content architecture;\n"
                "• Proprietary systems and infrastructure.\n\n"
                "Except as expressly authorized in writing, users may not:\n"
                "• Copy or reproduce content;\n"
                "• Reverse engineer systems;\n"
                "• Modify or distribute materials;\n"
                "• Commercialize platform technologies;\n"
                "• Create derivative works;\n"
                "• Resell or sublicense Services.\n\n"
                "Unauthorized use may violate United States intellectual property laws and subject violators to civil or criminal penalties.",
              ),
              _section(
                "10. AI-Generated Content and Accuracy Disclaimer",
                "Quiz Question AI utilizes automated artificial intelligence systems that generate responses algorithmically.\n"
                "AI-generated outputs may contain:\n"
                "• Inaccuracies;\n"
                "• Hallucinations;\n"
                "• Outdated information;\n"
                "• Incomplete answers;\n"
                "• Biased or inappropriate content.\n\n"
                "Quiz Question AI does not warrant or guarantee:\n"
                "• Accuracy;\n"
                "• Reliability;\n"
                "• Educational correctness;\n"
                "• Legal compliance;\n"
                "• Professional suitability;\n"
                "• Completeness or timeliness.\n\n"
                "Users understand and agree that:\n"
                "• AI outputs are for informational and educational purposes only;\n"
                "• AI systems should not replace licensed professionals or expert advice;\n"
                "• Users assume all risks associated with reliance on AI-generated information.\n\n"
                "Always seek advice from qualified legal, medical, financial, educational, or professional advisors before making decisions based on AI-generated responses.",
              ),
              _section(
                "11. Copyright and DMCA Compliance",
                "Users may upload only content they legally own or are authorized to use.\n"
                "You represent and warrant that submitted content does not infringe:\n"
                "• Copyrights;\n"
                "• Trademarks;\n"
                "• Privacy rights;\n"
                "• Proprietary rights;\n"
                "• Intellectual property rights;\n"
                "• Confidentiality obligations.\n\n"
                "Quiz Question AI complies with the United States Digital Millennium Copyright Act (“DMCA”).\n"
                "If you believe your copyrighted work has been improperly used through the Services, you may submit a valid DMCA takedown notice containing all legally required information.\n"
                "We reserve the right to remove allegedly infringing materials and terminate repeat infringers.",
              ),
              _section(
                "12. Service Changes, Suspension, and Termination",
                "Quiz Question AI reserves the right, at its sole discretion and to the fullest extent permitted by law, to:\n"
                "• Modify or discontinue Services;\n"
                "• Restrict platform functionality;\n"
                "• Remove user content;\n"
                "• Suspend accounts;\n"
                "• Terminate access rights;\n"
                "• Update these Terms at any time.\n\n"
                "Continued use of the Services following modifications constitutes acceptance of the revised Terms.\n"
                "Users are responsible for reviewing updated Terms periodically.",
              ),
              _section(
                "13. Disclaimer of Warranties",
                "THE SERVICES ARE PROVIDED ON AN “AS IS” AND “AS AVAILABLE” BASIS.\n"
                "TO THE MAXIMUM EXTENT PERMITTED UNDER APPLICABLE LAW, QUIZ QUESTION AI LLC DISCLAIMS ALL WARRANTIES, WHETHER EXPRESS, IMPLIED, STATUTORY, OR OTHERWISE, INCLUDING WARRANTIES OF:\n"
                "• MERCHANTABILITY;\n"
                "• FITNESS FOR A PARTICULAR PURPOSE;\n"
                "• NON-INFRINGEMENT;\n"
                "• ACCURACY;\n"
                "• RELIABILITY;\n"
                "• SECURITY;\n"
                "• SYSTEM AVAILABILITY.\n\n"
                "WE DO NOT GUARANTEE THAT:\n"
                "• THE SERVICES WILL OPERATE WITHOUT INTERRUPTION;\n"
                "• THE PLATFORM WILL BE ERROR-FREE;\n"
                "• AI OUTPUTS WILL BE ACCURATE OR SAFE;\n"
                "• SECURITY BREACHES WILL NOT OCCUR;\n"
                "• DEFECTS WILL BE CORRECTED.\n\n"
                "YOUR USE OF THE SERVICES IS ENTIRELY AT YOUR OWN RISK.",
              ),
              _section(
                "14. Limitation of Liability",
                "TO THE FULLEST EXTENT PERMITTED UNDER UNITED STATES LAW, QUIZ QUESTION AI LLC AND ITS AFFILIATES SHALL NOT BE LIABLE FOR:\n"
                "• INDIRECT DAMAGES;\n"
                "• INCIDENTAL DAMAGES;\n"
                "• SPECIAL DAMAGES;\n"
                "• CONSEQUENTIAL DAMAGES;\n"
                "• LOSS OF PROFITS;\n"
                "• LOSS OF DATA;\n"
                "• BUSINESS INTERRUPTION;\n"
                "• REPUTATIONAL HARM;\n"
                "• PERSONAL DECISIONS BASED ON AI OUTPUTS;\n"
                "• THIRD-PARTY SYSTEM FAILURES;\n"
                "• DAMAGES ARISING FROM AI-GENERATED CONTENT.\n\n"
                "IN NO EVENT SHALL THE TOTAL LIABILITY OF QUIZ QUESTION AI LLC EXCEED THE TOTAL AMOUNT PAID BY YOU TO THE COMPANY DURING THE TWELVE (12) MONTHS PRECEDING THE EVENT GIVING RISE TO THE CLAIM.",
              ),
              _section(
                "15. User Responsibility and Indemnification",
                "You agree to defend, indemnify, and hold harmless Quiz Question AI LLC and its officers, directors, employees, affiliates, contractors, licensors, and service providers from and against any claims, liabilities, damages, losses, costs, expenses, or legal fees arising from:\n"
                "• Your use of the Services;\n"
                "• Violations of these Terms;\n"
                "• Violations of applicable laws;\n"
                "• Infringement of third-party rights;\n"
                "• Misuse of AI-generated content;\n"
                "• User-uploaded materials or prompts.\n\n"
                "This indemnification obligation survives termination of your account and use of the Services.",
              ),
              _section(
                "16. Governing Law and Arbitration",
                "These Terms shall be governed by and interpreted in accordance with the laws of the State of Maryland and the United States of America, without regard to conflict-of-law principles.\n"
                "Any dispute, claim, or controversy arising out of or relating to these Terms or the Services shall be resolved exclusively through binding arbitration conducted in the State of Maryland, unless prohibited by applicable law.\n"
                "To the fullest extent permitted by law:\n"
                "• You waive the right to a jury trial;\n"
                "• You waive participation in class-action lawsuits;\n"
                "• You waive participation in class-wide arbitration proceedings.",
              ),
              _section(
                "17. Contact Details",
                "For questions regarding these Terms or the Services, please contact:\n\n"
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