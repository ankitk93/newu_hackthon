import 'package:flutter/material.dart';
import 'package:newu_health/core/theme/app_colors.dart';

/// Selectable chip — exact Figma match.
/// Unselected: bg=#F5F5F5, text=#737373, NO border.
/// Selected: bg=#FFF8F0, border=#E47B00 (1px), text=#E47B00.
class DurationChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const DurationChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.chipSelectedBgDark : AppColors.chipSelectedBg)
              : (isDark ? AppColors.chipUnselectedBgDark : AppColors.chipUnselectedBg),
          borderRadius: BorderRadius.circular(50),
          border: isSelected
              ? Border.all(
                  color: isDark
                      ? AppColors.chipSelectedBorderDark
                      : AppColors.chipSelectedBorder,
                  width: 1,
                )
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? (isDark ? AppColors.chipSelectedTextDark : AppColors.chipSelectedText)
                  : (isDark ? AppColors.chipUnselectedTextDark : AppColors.chipUnselectedText),
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
