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

  // Top bar — full screen width, X left, Moon right
  Widget _topBar(BuildContext ctx, bool isDark) {
    final bg = isDark ? AppColors.iconContainerBgDark : AppColors.crossIconBg;

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
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(shape: BoxShape.circle, color: bg),
              child: Center(
                child: SvgPicture.asset('assets/icons/icon_cross.svg',
                  width: 12,
                  height: 12,
                  colorFilter: ColorFilter.mode(
                    isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
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
  // Compact centered layout matching Figma:
  // Top bar → [centered group: "You're a natural" → Bubble → Label → Sub → Progress → Cycle → Pause]
  Widget _breathing(BuildContext ctx, Breathing s, bool isDark) {
    return Column(
      children: [
        _topBar(ctx, isDark),
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 375),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
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
                      const SizedBox(height: 20),
                      // Bubble
                      BreathingBubble(
                        phase: s.currentPhase,
                        secondsRemaining: s.secondsRemaining,
                        phaseDuration: _dur(s),
                        isDark: isDark,
                      ),
                      const SizedBox(height: 20),
                      // Phase label (BELOW bubble)
                      Text(
                        s.currentPhase.label,
                        style: TextStyle(
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimary,
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
                      const SizedBox(height: 24),
                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: s.progress,
                          backgroundColor: isDark
                              ? Colors.white12
                              : AppColors.gradientEnd
                                  .withValues(alpha: 0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isDark
                                ? AppColors.gradientStart
                                : AppColors.gradientEnd,
                          ),
                          minHeight: 4,
                        ),
                      ),
                      const SizedBox(height: 8),
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
                      const SizedBox(height: 16),
                      // Pause/Resume button
                      GestureDetector(
                        onTap: () {
                          if (s.isPaused) {
                            ctx
                                .read<BreathingSessionBloc>()
                                .add(const ResumeSession());
                          } else {
                            ctx
                                .read<BreathingSessionBloc>()
                                .add(const PauseSession());
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28, vertical: 12),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.buttonBgColorDark
                                : AppColors.crossIconBg,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                s.isPaused
                                    ? Icons.play_arrow
                                    : Icons.pause,
                                color: isDark
                                    ? Colors.white
                                    : AppColors.iconContainerBgDark,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                s.isPaused ? 'Resume' : 'Pause',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white
                                      : AppColors.iconContainerBgDark,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
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
