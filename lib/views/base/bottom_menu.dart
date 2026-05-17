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
      children: [
        SvgPicture.asset(
          icon,
          height: 22,
          width: 22,
          colorFilter: ColorFilter.mode(
            isSelected
                ? Color(0xFFA78BFA)
                : AppColors.textColor.withValues(alpha: 0.40),
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? AppColors.textColor : const Color(0xFF6B6B7B),
          ),
        ),
      ],
    );

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: isSelected
            ? Container(
                height: 58,
                width: 52,
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0x268B5CF6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: content,
              )
            : content,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.bottomBarColor.withValues(alpha: 0.95),
        border: Border.all(
          color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
        ),
      ),
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
    );
  }
}
