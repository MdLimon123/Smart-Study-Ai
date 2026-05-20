import 'package:flutter/material.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_svg/svg.dart';

class BottomMenu extends StatelessWidget {
  final int menuIndex;
  final Function(int) onTap;

  const BottomMenu({super.key, required this.menuIndex, required this.onTap});

  Widget buildItem({
    required String icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = index == menuIndex;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          icon,
          height: 20,
          width: 20,
          colorFilter: ColorFilter.mode(
            isSelected
                ? const Color(0xFFA78BFA)
                : AppColors.textColor.withValues(alpha: 0.40),
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? const Color(0xFFA78BFA) : const Color(0xFF6B6B7B),
          ),
        ),
      ],
    );

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0x1F8B5CF6)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: content,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.bottomBarColor.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildItem(icon: "assets/icon/home.svg", label: "Home", index: 0),
              buildItem(icon: "assets/icon/scan.svg", label: "Scan", index: 1),
              buildItem(icon: "assets/icon/chat.svg", label: "Chat", index: 2),
              buildItem(
                icon: "assets/icon/library.svg",
                label: "Library",
                index: 3,
              ),
              buildItem(
                icon: "assets/icon/profile.svg",
                label: "Profile",
                index: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

