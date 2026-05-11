import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/profile_controller.dart';
import 'package:flutter_extension/data/model/profile_badge_model.dart';
import 'package:flutter_extension/data/api/api_client.dart';
import 'package:flutter_extension/helper/prefs_helper.dart';
import 'package:flutter_extension/helper/route_helper.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/util/app_constants.dart';
import 'package:flutter_extension/views/screen/profile/aiPersonalization/ai_personalization.dart';
import 'package:flutter_extension/views/screen/profile/change_password_screen.dart';
import 'package:flutter_extension/views/screen/profile/dataControl/data_control_screen.dart';
import 'package:flutter_extension/views/screen/profile/notification_screen.dart';
import 'package:flutter_extension/views/screen/profile/parental/parental_control_screen.dart';
import 'package:flutter_extension/views/screen/profile/help_support.dart';
import 'package:flutter_extension/views/screen/profile/privacy_security.dart';
import 'package:flutter_extension/views/screen/profile/twoFactorAuth/two_factor_auth.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileController _profileController = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Obx(
                      () {
                        final local = _profileController.userProfileImage.value;
                        final p = _profileController.profile.value;
                        final loading = _profileController.isProfileLoading.value;
                        Widget imageChild;
                        if (local != null) {
                          imageChild = Image.file(
                            local,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          );
                        } else if (loading && p == null) {
                          imageChild = const Center(
                            child: SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF7C3AED),
                              ),
                            ),
                          );
                        } else if (p?.imageUrl != null &&
                            p!.imageUrl!.trim().isNotEmpty) {
                          imageChild = CachedNetworkImage(
                            imageUrl: p.imageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            placeholder: (_, __) => const Center(
                              child: SizedBox(
                                width: 28,
                                height: 28,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF7C3AED),
                                ),
                              ),
                            ),
                            errorWidget: (_, __, ___) => Image.asset(
                              "assets/images/dummy.png",
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          );
                        } else {
                          imageChild = Image.asset(
                            "assets/images/dummy.png",
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          );
                        }
                        return GestureDetector(
                          onTap: () => _profileController.pickUserImage(),
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF181823),
                            ),
                            child: ClipOval(child: imageChild),
                          ),
                        );
                      },
                    ),
                    Obx(
                      () {
                        if (!_profileController.isUpdatingImage.value) {
                          return const SizedBox.shrink();
                        }
                        return Positioned(
                          left: 0,
                          top: 0,
                          right: 0,
                          bottom: 0,
                          child: ClipOval(
                            child: Container(
                              color: Colors.black.withValues(alpha: 0.45),
                              alignment: Alignment.center,
                              child: const SizedBox(
                                width: 28,
                                height: 28,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF7C3AED),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => _profileController.pickUserImage(),

                        child: Container(
                          height: 30,
                          padding: const EdgeInsets.all(8),
                          width: 30,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF1D1929),
                          ),
                          child: Container(
                            height: 12,
                            width: 12,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF1BD2A4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              Obx(
                () {
                  final p = _profileController.profile.value;
                  final name =
                      (p?.name.isNotEmpty == true) ? p!.name : '—';
                  final email = p?.email ?? '';
                  return Column(
                    children: [
                      Center(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Center(
                        child: Text(
                          email,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textColor.withValues(alpha: 0.50),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 12),

              Obx(
                () {
                  final level = _profileController.profile.value?.level ?? 1;
                  return Center(
                    child: Container(
                      width: 200,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF48A3B).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: const Color(0xFFF48A3B),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'LEVEL $level',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFF48A3B),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '• Free plan',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textColor.withValues(alpha: 0.30),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF7C3AED).withValues(alpha: 0.30),
                  ),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/crown.png'),
                    const SizedBox(width: 16),
                    Text(
                      "Upgrade to Premium",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Obx(
                () {
                  final p = _profileController.profile.value;
                  final solved = p?.problemsSolved ?? 0;
                  final study = p?.studyTimeLabel ?? '0';
                  final streak = p?.activeDays ?? 0;
                  final badgeCount = p?.badges.length ?? 0;
                  return Row(
                    children: [
                      _customContainer(
                        image: "assets/images/circle.png",
                        count: '$solved',
                        title: "Problems Solved",
                      ),
                      const SizedBox(width: 8),
                      _customContainer(
                        image: "assets/images/book_fill.png",
                        count: study,
                        title: "Study time",
                      ),
                      const SizedBox(width: 8),
                      _customContainer(
                        image: "assets/images/phy.png",
                        count: '$streak',
                        title: "Streak days",
                      ),
                      const SizedBox(width: 8),
                      _customContainer(
                        image: "assets/images/badges.png",
                        count: '$badgeCount',
                        title: "Badges",
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 23),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Badges',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                  Obx(() {
                    final badges = _profileController.profile.value?.badges ?? [];
                    if (badges.isEmpty) return const SizedBox.shrink();
                    return InkWell(
                      onTap: () => _openAllBadgesSheet(badges),
                      borderRadius: BorderRadius.circular(8),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        child: Text(
                          'See all',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFA78BFA),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),

              const SizedBox(height: 12),

              Obx(() {
                final badges = _profileController.profile.value?.badges ?? [];
                if (badges.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        'No badges yet',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor.withValues(alpha: 0.45),
                        ),
                      ),
                    ),
                  );
                }
                return SizedBox(
                  height: 124,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: badges.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, i) {
                      final b = badges[i];
                      final v = _badgeVisualForId(b.id);
                      return SizedBox(
                        width: 92,
                        child: _badgeCard(
                          borderColor: v.border,
                          iconBg: v.iconBg,
                          imageAsset: v.asset,
                          label: b.label,
                        ),
                      );
                    },
                  ),
                );
              }),
              const SizedBox(height: 23),

              Text(
                "Security & Privacy",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.textColor.withValues(alpha: 0.04),
                  border: Border.all(
                    color: AppColors.textColor.withValues(alpha: 0.07),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => _customRow(
                        onTap: () {
                          Get.to(() => const TwoFactorAuth());
                        },
                        backgroundColor: const Color(0xFF60A5FA),
                        image: "assets/images/lock.png",
                        title: "Two-Factor Auth",
                        subtitle:
                            _profileController.profile.value?.twoFactorEnabled ==
                                true
                            ? "Enabled"
                            : "Add extra sign-in security",
                      ),
                    ),

                    const SizedBox(height: 10),
                    Divider(
                      height: 1,
                      color: AppColors.textColor.withValues(alpha: 0.05),
                    ),

                    const SizedBox(height: 10),

                    _customRow(
                      onTap: () {
                        Get.to(() => const ParentalControlScreen());
                      },
                      backgroundColor: const Color(0xFFF59E0B),
                      image: "assets/images/groupUser.png",
                      title: "Parental Control",
                      subtitle: "Content & time restrictions",
                    ),

                    const SizedBox(height: 10),
                    Divider(
                      height: 1,
                      color: AppColors.textColor.withValues(alpha: 0.05),
                    ),

                    const SizedBox(height: 10),

                    _customRow(
                      onTap: () {
                        Get.to(() => const AiPersonalization());
                      },
                      backgroundColor: const Color(0xFFA78BFA),
                      image: "assets/images/groupUser.png",
                      title: "AI Personalization",
                      subtitle: "Model, style & subject focus",
                    ),

                    const SizedBox(height: 10),
                    Divider(
                      height: 1,
                      color: AppColors.textColor.withValues(alpha: 0.05),
                    ),

                    const SizedBox(height: 10),

                    _customRow(
                      onTap: () {
                        Get.to(() => const DataControlScreen());
                      },
                      backgroundColor: const Color(0xFF34D399),
                      image: "assets/images/groupUser.png",
                      title: "Data Control",
                      subtitle: "Export data · Delete chat history",
                    ),

                    const SizedBox(height: 10),
                    Divider(
                      height: 1,
                      color: AppColors.textColor.withValues(alpha: 0.05),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 23),

              Text(
                "General",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),

              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.textColor.withValues(alpha: 0.04),
                  border: Border.all(
                    color: AppColors.textColor.withValues(alpha: 0.07),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _customRow(
                      onTap: () {
                        Get.to(() => const NotificationScreen());
                      },
                      backgroundColor: const Color(0xFF60A5FA),
                      image: "assets/images/notification.png",
                      title: "Notifications",
                      subtitle: "Push & email alerts",
                    ),

                    const SizedBox(height: 10),
                    Divider(
                      height: 1,
                      color: AppColors.textColor.withValues(alpha: 0.05),
                    ),

                    const SizedBox(height: 10),

                    _customRow(
                      onTap: () {
                        Get.to(() => const PrivacySecurity());
                      },
                      backgroundColor: const Color(0xFF34D399),
                      image: "assets/images/privacy.png",
                      title: "Privacy & Security",
                      subtitle: "Manage data",
                    ),

                    const SizedBox(height: 10),
                    Divider(
                      height: 1,
                      color: AppColors.textColor.withValues(alpha: 0.05),
                    ),

                    const SizedBox(height: 10),

                    _customRow(
                      onTap: () {
                        Get.to(() => const HelpSupport());
                      },
                      backgroundColor: const Color(0xFFF59E0B),
                      image: "assets/images/help.png",
                      title: "Help & Support",
                      subtitle: "FAQ & contact",
                    ),

                    const SizedBox(height: 10),
                    Divider(
                      height: 1,
                      color: AppColors.textColor.withValues(alpha: 0.05),
                    ),

                    const SizedBox(height: 10),

                    _customRow(
                      onTap: () {
                        Get.to(() => const ChangePasswordScreen());
                      },
                      backgroundColor: const Color(0xFFF87171),
                      image: "assets/images/lock.png",
                      title: "Change Password",
                      subtitle: "Update your password",
                    ),
                    const SizedBox(height: 10),
                    _customRow(
                      onTap: () {
                        showLogoutBottomSheet(context);
                      },
                      backgroundColor: const Color(0xFF60A5FA),
                      image: "assets/images/logout.png",
                      title: "Logout",
                      subtitle: "",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showLogoutBottomSheet(BuildContext context) {
    const borderRadius = BorderRadius.vertical(top: Radius.circular(24));
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      shape: const RoundedRectangleBorder(borderRadius: borderRadius),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: borderRadius,
            border: Border.all(color: AppColors.surfaceBorder, width: 1),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Logout',
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Are you sure you want to log out?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  width: double.maxFinite,
                  height: 1,
                  color: AppColors.surfaceBorder,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(100),
                          onTap: () => Get.back(),
                          child: Container(
                            height: 52,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                color: AppColors.surfaceBorder,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(100),
                          onTap: () async {
                            // Session: only [AppConstants.TOKEN] is auth data here.
                            // Keep language + theme prefs (THEME, LANGUAGE_CODE, COUNTRY_CODE).
                            await PrefsHelper.remove(AppConstants.TOKEN);
                            await ApiClient.loadPrefs();
                            Get.offAllNamed(AppRoutes.loginScreen);
                          },
                          child: Container(
                            height: 52,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.accent,
                                  AppColors.accentSecondary,
                                ],
                                begin: Alignment.centerRight,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Text(
                              'Yes, log out',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textColor,
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
        );
      },
    );
  }

  _customRow({
    required Color backgroundColor,
    required String image,
    required String title,
    required String subtitle,
    required Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: backgroundColor.withValues(alpha: 0.12),
            ),
            child: Image.asset(image),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor.withValues(alpha: 0.35),
                ),
              ),
            ],
          ),

          const Spacer(),
          Icon(
            Icons.navigate_next,
            color: AppColors.textColor.withValues(alpha: 0.25),
          ),
        ],
      ),
    );
  }

  /// Border / icon tint / asset for known API `id` values (`bookworm`, `top_solver`, …).
  ({Color border, Color iconBg, String asset}) _badgeVisualForId(String id) {
    switch (id) {
      case 'bookworm':
        return (
          border: const Color(0xFF34D399),
          iconBg: const Color(0xFF34D399),
          asset: 'assets/images/book3.png',
        );
      case 'dedicated':
        return (
          border: const Color(0xFFA78BFA),
          iconBg: const Color(0xFFA78BFA),
          asset: 'assets/images/book_fill.png',
        );
      case 'scholar':
        return (
          border: const Color(0xFF818CF8),
          iconBg: const Color(0xFF818CF8),
          asset: 'assets/images/data.png',
        );
      case 'top_solver':
        return (
          border: const Color(0xFF60A5FA),
          iconBg: const Color(0xFF60A5FA),
          asset: 'assets/images/star.png',
        );
      case 'marathon':
        return (
          border: const Color(0xFFA78BFA),
          iconBg: const Color(0xFFF59E0B),
          asset: 'assets/images/fire.png',
        );
      default:
        return (
          border: const Color(0xFFA78BFA),
          iconBg: const Color(0xFFA78BFA),
          asset: 'assets/images/badges.png',
        );
    }
  }

  Widget _badgeCard({
    required Color borderColor,
    required Color iconBg,
    required String imageAsset,
    required String label,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
      decoration: BoxDecoration(
        color: AppColors.textColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor.withValues(alpha: 0.55),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: iconBg.withValues(alpha: 0.16),
            ),
            padding: const EdgeInsets.all(6),
            child: Image.asset(imageAsset, fit: BoxFit.contain),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  void _openAllBadgesSheet(List<ProfileBadgeModel> badges) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF16161F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final h = MediaQuery.of(ctx).size.height * 0.52;
        return SafeArea(
          child: SizedBox(
            height: h,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 8, 8),
                  child: Row(
                    children: [
                      Text(
                        'All badges',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textColor,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        icon: Icon(
                          Icons.close,
                          color: AppColors.textColor.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    itemCount: badges.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: AppColors.textColor.withValues(alpha: 0.06),
                    ),
                    itemBuilder: (context, i) {
                      final b = badges[i];
                      final v = _badgeVisualForId(b.id);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 52,
                              width: 52,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: v.border.withValues(alpha: 0.45),
                                ),
                                color: v.iconBg.withValues(alpha: 0.12),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Image.asset(
                                v.asset,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    b.label,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textColor,
                                    ),
                                  ),
                                  if (b.description != null &&
                                      b.description!.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      b.description!,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.textColor.withValues(
                                          alpha: 0.50,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _customContainer({
    required String image,
    required String count,
    required String title,
  }) {
    const cardHeight = 108.0;
    return Expanded(
      child: SizedBox(
        height: cardHeight,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.textColor.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.textColor.withValues(alpha: 0.06),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(image, width: 20, height: 20),
              const SizedBox(height: 6),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: Text(
                  count,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                    height: 1.1,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w400,
                  height: 1.2,
                  color: AppColors.textColor.withValues(alpha: 0.40),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
