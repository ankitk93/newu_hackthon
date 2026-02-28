import 'package:flutter/material.dart';
import 'package:newu_health/core/theme/app_colors.dart';

/// Phase duration +/- control — exact Figma match.
/// Light: white circle bg, black icons. Dark: semi-transparent, white icons.
class PhaseDurationControl extends StatelessWidget {
  final String label;
  final int value;
  final bool isDark;
  final ValueChanged<int> onChanged;

  const PhaseDurationControl({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.chipUnSelectedBgDark : AppColors.controlBgLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          _circleBtn(
            icon: Icons.remove,
            onTap: value > 2 ? () => onChanged(value - 1) : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '${value}s',
              style: TextStyle(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _circleBtn(
            icon: Icons.add,
            onTap: value < 10 ? () => onChanged(value + 1) : null,
          ),
        ],
      ),
    );
  }

  Widget _circleBtn({required IconData icon, VoidCallback? onTap}) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? AppColors.controlButtonDark : AppColors.controlButtonLight,
        ),
        child: Icon(
          icon,
          size: 14,
          color: isDark
              ? (enabled ? AppColors.controlIconDark : Colors.white38)
              : (enabled ? AppColors.controlIconLight : Colors.grey.shade400),
        ),
      ),
    );
  }
}
