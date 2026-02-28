import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newu_health/core/theme/app_colors.dart';
import 'package:newu_health/core/theme/theme_cubit.dart';
import 'package:newu_health/features/breathing/domain/entities/breathing_config.dart';
import 'package:newu_health/features/breathing/domain/entities/breathing_phase.dart';
import 'package:newu_health/features/breathing/presentation/blocs/session/breathing_session_bloc.dart';
import 'package:newu_health/features/breathing/presentation/blocs/session/breathing_session_event.dart';
import 'package:newu_health/features/breathing/presentation/blocs/session/breathing_session_state.dart';
import 'package:newu_health/features/breathing/presentation/widgets/breathing_bubble.dart';

class BreathingScreen extends StatelessWidget {
  final BreathingConfig config;
  const BreathingScreen({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BreathingSessionBloc()..add(StartSession(config)),
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [AppColors.backgroundDark, AppColors.backgroundDarkEnd]
                : [AppColors.backgroundLight, AppColors.backgroundLightEnd],
          ),
        ),
        child: Stack(
          children: [
            _clouds(isDark, sw, sh),
            if (isDark)
              Positioned.fill(
                child: SvgPicture.asset(
                  'assets/images/dark_mode_assets/stars.svg',
                  fit: BoxFit.cover,
                ),
              ),
            SafeArea(
              child: BlocConsumer<BreathingSessionBloc, BreathingSessionState>(
                listener: (ctx, s) {
                  if (s is SessionCompleted) {
                    Navigator.of(ctx)
                        .pushReplacementNamed('/finish', arguments: s.config);
                  }
                },
                builder: (ctx, s) {
                  if (s is GetReady) return _getReady(ctx, s, isDark);
                  if (s is Breathing) return _breathing(ctx, s, isDark);
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _clouds(bool isDark, double w, double h) {
    final base = isDark
        ? 'assets/images/dark_mode_assets'
        : 'assets/images/light_mode_assets';
    return Stack(children: [
      Positioned(
        right: -20,
        top: h * 0.03,
        child: SvgPicture.asset('$base/right_cloud.svg', width: w * 0.28),
      ),
      Positioned(
        left: -30,
        top: h * 0.35,
        child: SvgPicture.asset('$base/left_cloud.svg', width: w * 0.3),
      ),
    ]);
  }

  // Top bar: X (left) + Moon/Sun (right), both 24x24
  Widget _topBar(BuildContext ctx, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              ctx.read<BreathingSessionBloc>().add(const CancelSession());
              Navigator.of(ctx).pop();
            },
            child: Icon(Icons.close,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimary,
                size: 24),
          ),
          GestureDetector(
            onTap: () => ctx.read<ThemeCubit>().toggleTheme(),
            child: SvgPicture.asset(
              isDark
                  ? 'assets/images/dark_mode_assets/icon_sun.svg'
                  : 'assets/images/light_mode_assets/icon_moon.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── GET READY ───
  Widget _getReady(BuildContext ctx, GetReady s, bool isDark) {
    return Column(
      children: [
        _topBar(ctx, isDark),
        const Spacer(),
        // Bubble with countdown
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark ? AppColors.bubbleBgDark : Colors.white,
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.grey.shade200,
            ),
          ),
          child: Center(
            child: Text(
              '${s.countdown}',
              style: TextStyle(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimary,
                fontSize: 56,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Get ready',
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Get going on your breathing session.',
          style: TextStyle(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        const Spacer(flex: 2),
      ],
    );
  }

  // ─── BREATHING ───
  // Order: "You're a natural" → Bubble → Phase label → Sub → Progress → Cycle → Pause
  Widget _breathing(BuildContext ctx, Breathing s, bool isDark) {
    return Column(
      children: [
        _topBar(ctx, isDark),
        const Spacer(),
        // "You're a natural"
        Text(
          "You're a natural",
          style: TextStyle(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 24),
        // Bubble
        BreathingBubble(
          phase: s.currentPhase,
          secondsRemaining: s.secondsRemaining,
          phaseDuration: _dur(s),
          isDark: isDark,
        ),
        const SizedBox(height: 24),
        // Phase label (BELOW bubble)
        Text(
          s.currentPhase.label,
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          s.currentPhase.subtitle,
          style: TextStyle(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        const Spacer(),
        // Progress bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: s.progress,
              backgroundColor: isDark
                  ? Colors.white12
                  : AppColors.gradientEnd.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark ? AppColors.gradientStart : AppColors.gradientEnd,
              ),
              minHeight: 4,
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Cycle text
        Text(
          'Cycle ${s.currentCycle} of ${s.config.rounds}',
          style: TextStyle(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 20),
        // Pause/Resume — gradient pill
        GestureDetector(
          onTap: () {
            if (s.isPaused) {
              ctx.read<BreathingSessionBloc>().add(const ResumeSession());
            } else {
              ctx.read<BreathingSessionBloc>().add(const PauseSession());
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.gradientStart, AppColors.gradientEnd],
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  s.isPaused ? Icons.play_arrow : Icons.pause,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  s.isPaused ? 'Resume' : 'Pause',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  int _dur(Breathing s) {
    switch (s.currentPhase) {
      case BreathingPhase.breatheIn:
        return s.config.breatheInDuration;
      case BreathingPhase.holdIn:
        return s.config.holdInDuration;
      case BreathingPhase.breatheOut:
        return s.config.breatheOutDuration;
      case BreathingPhase.holdOut:
        return s.config.holdOutDuration;
    }
  }
}
