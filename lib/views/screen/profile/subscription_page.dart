import 'package:flutter/material.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:get/get.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  int _selectedPlan = 1; // 0=Weekly, 1=Monthly (default), 2=Yearly

  final List<_PlanData> _plans = const [
    _PlanData(
      title: 'Weekly',
      price: '\$7.99',
      period: '/week',
      buttonLabel: 'Get Started',
      isPopular: false,
    ),
    _PlanData(
      title: 'Monthly',
      price: '\$19.99',
      period: '/month',
      buttonLabel: 'Upgrade to Pro',
      isPopular: true,
    ),
    _PlanData(
      title: 'Yearly',
      price: '\$59.99',
      period: '/year',
      buttonLabel: 'Save Big',
      isPopular: false,
    ),
  ];

  static const List<_FeatureItem> _features = [
    _FeatureItem(icon: Icons.all_inclusive_rounded, text: 'Unlimited AI questions'),
    _FeatureItem(icon: Icons.auto_awesome_rounded, text: 'All AI models (GPT-4o, Claude, Gemini)'),
    _FeatureItem(icon: Icons.camera_alt_rounded, text: 'Photo to Solution'),
    _FeatureItem(icon: Icons.history_rounded, text: 'Unlimited history'),
    _FeatureItem(icon: Icons.support_agent_rounded, text: 'Priority support'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 8),

              // ─── Header ───
              _buildHeader(),

              const SizedBox(height: 32),

              // ─── Plan Cards ───
              ...List.generate(_plans.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildPlanCard(index),
                );
              }),

              const SizedBox(height: 16),

              // ─── Footer note ───
              // Text(
              //   'Cancel anytime. No hidden fees.',
              //   style: TextStyle(
              //     fontSize: 13,
              //     fontWeight: FontWeight.w400,
              //     color: AppColors.textColor.withValues(alpha: 0.40),
              //   ),
              // ),
              // const SizedBox(height: 8),
              // Text(
              //   'Restore Purchases',
              //   style: TextStyle(
              //     fontSize: 13,
              //     fontWeight: FontWeight.w500,
              //     color: AppColors.primaryColor.withValues(alpha: 0.80),
              //     decoration: TextDecoration.underline,
              //     decorationColor: AppColors.primaryColor.withValues(alpha: 0.50),
              //   ),
              // ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Crown / sparkle icon
        Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7C3AED).withValues(alpha: 0.35),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.workspace_premium_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Start for free.',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.textColor,
            height: 1.2,
          ),
        ),
        Text(
          'Upgrade anytime.',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.textColor,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Unlock the full power of Quick Question AI',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textColor.withValues(alpha: 0.50),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanCard(int index) {
    final plan = _plans[index];
    final isSelected = _selectedPlan == index;
    final isPopular = plan.isPopular;

    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.withValues(alpha: 0.06)
              : AppColors.textColor.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor.withValues(alpha: 0.50)
                : AppColors.textColor.withValues(alpha: 0.08),
            width: isSelected ? 1.8 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryColor.withValues(alpha: 0.10),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Title Row ───
            Row(
              children: [
                Text(
                  plan.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor.withValues(alpha: 0.60),
                  ),
                ),
                if (isPopular) ...[
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                      ),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'Popular',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                // Radio indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 22,
                  width: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.textColor.withValues(alpha: 0.20),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            height: 12,
                            width: 12,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                              ),
                            ),
                          ),
                        )
                      : null,
                ),
              ],
            ),

            const SizedBox(height: 14),

            // ─── Price ───
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  plan.price,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textColor,
                    height: 1,
                  ),
                ),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    plan.period,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor.withValues(alpha: 0.40),
                    ),
                  ),
                ),
                if (index == 2) ...[
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: const Color(0xFF10B981).withValues(alpha: 0.25),
                      ),
                    ),
                    child: const Text(
                      'Save 42%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 18),

            // ─── Divider ───
            Container(
              height: 1,
              color: AppColors.textColor.withValues(alpha: 0.06),
            ),

            const SizedBox(height: 16),

            // ─── Features ───
            ..._features.map((f) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      f.text,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textColor.withValues(alpha: 0.75),
                      ),
                    ),
                  ),
                ],
              ),
            )),

            const SizedBox(height: 8),

            // ─── CTA Button ───
            SizedBox(
              width: double.infinity,
              height: 48,
              child: isSelected
                  ? ElevatedButton(
                      onPressed: () {
                        // TODO: Handle subscription
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            plan.buttonLabel,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  : OutlinedButton(
                      onPressed: () => setState(() => _selectedPlan = index),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppColors.textColor.withValues(alpha: 0.12),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        backgroundColor: AppColors.textColor.withValues(alpha: 0.04),
                      ),
                      child: Text(
                        plan.buttonLabel,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor.withValues(alpha: 0.60),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanData {
  final String title;
  final String price;
  final String period;
  final String buttonLabel;
  final bool isPopular;

  const _PlanData({
    required this.title,
    required this.price,
    required this.period,
    required this.buttonLabel,
    required this.isPopular,
  });
}

class _FeatureItem {
  final IconData icon;
  final String text;

  const _FeatureItem({required this.icon, required this.text});
}