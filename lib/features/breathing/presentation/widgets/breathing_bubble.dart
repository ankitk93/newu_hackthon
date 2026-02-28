import 'package:flutter/material.dart';
import 'package:newu_health/core/theme/app_colors.dart';
import 'package:newu_health/features/breathing/domain/entities/breathing_phase.dart';

/// Animated breathing bubble — scales based on phase.
class BreathingBubble extends StatelessWidget {
  final BreathingPhase phase;
  final int secondsRemaining;
  final int phaseDuration;
  final bool isDark;

  const BreathingBubble({
    super.key,
    required this.phase,
    required this.secondsRemaining,
    required this.phaseDuration,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    double targetScale;
    switch (phase) {
      case BreathingPhase.breatheIn:
        final p = 1.0 - (secondsRemaining / phaseDuration);
        targetScale = 0.5 + (0.5 * p);
        break;
      case BreathingPhase.holdIn:
        targetScale = 1.0;
        break;
      case BreathingPhase.breatheOut:
        final p = 1.0 - (secondsRemaining / phaseDuration);
        targetScale = 1.0 - (0.5 * p);
        break;
      case BreathingPhase.holdOut:
        targetScale = 0.5;
        break;
    }

    final baseSize = MediaQuery.of(context).size.width * 0.5;
    final size = baseSize.clamp(140.0, 220.0);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOut,
      width: size * targetScale,
      height: size * targetScale,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? AppColors.bubbleBgDark : Colors.white,
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: AppColors.gradientEnd.withValues(alpha: 0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
      ),
      child: Center(
        child: Text(
          '$secondsRemaining',
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            fontSize: 44 * targetScale,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}
