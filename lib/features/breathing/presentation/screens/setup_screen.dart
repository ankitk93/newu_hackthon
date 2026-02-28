import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newu_health/core/theme/app_colors.dart';
import 'package:newu_health/core/theme/theme_cubit.dart';
import 'package:newu_health/features/breathing/presentation/blocs/setup/breathing_setup_bloc.dart';
import 'package:newu_health/features/breathing/presentation/blocs/setup/breathing_setup_event.dart';
import 'package:newu_health/features/breathing/presentation/blocs/setup/breathing_setup_state.dart';
import 'package:newu_health/features/breathing/presentation/widgets/duration_chip.dart';
import 'package:newu_health/features/breathing/presentation/widgets/phase_duration_control.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BreathingSetupBloc(),
      child: const _SetupContent(),
    );
  }
}

class _SetupContent extends StatelessWidget {
  const _SetupContent();

  static const double _maxW = 375.0;

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
            // Clouds
            _clouds(isDark, sw, sh),
            // Stars in dark mode
            if (isDark)
              Positioned.fill(
                child: SvgPicture.asset(
                  'assets/images/dark_mode_assets/stars.svg',
                  fit: BoxFit.cover,
                ),
              ),
            // Content
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _maxW),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 12),
                        // Moon/Sun icon — top right, 16x16, no bg
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () =>
                                context.read<ThemeCubit>().toggleTheme(),
                            child: SvgPicture.asset(
                              isDark
                                  ? 'assets/images/dark_mode_assets/icon_sun.svg'
                                  : 'assets/images/light_mode_assets/icon_moon.svg',
                              width: 24,
                              height: 24,
                              colorFilter: ColorFilter.mode(
                                isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimary,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Title
                        Text(
                          'Set your breathing pace',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Customise your breathing session.\nYou can always change this later.',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondary,
                            fontSize: 12,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        // Card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.cardDark
                                : AppColors.cardLight,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: isDark
                                ? []
                                : [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.06),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _title('Breath duration', isDark),
                              const SizedBox(height: 2),
                              _sub('Seconds per phase', isDark),
                              const SizedBox(height: 12),
                              _durationChips(context, isDark),
                              const SizedBox(height: 20),
                              _title('Rounds', isDark),
                              const SizedBox(height: 2),
                              _sub('Full box breathing cycles', isDark),
                              const SizedBox(height: 12),
                              _roundsChips(context, isDark),
                              const SizedBox(height: 20),
                              _advancedTiming(context, isDark),
                              const SizedBox(height: 20),
                              _soundRow(context, isDark),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        // Start button — 25px extra horizontal margin from card
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: _startButton(context, isDark),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
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
    return Stack(
      children: [
        // Top-left
        Positioned(
          left: -20,
          top: h * 0.05,
          child: SvgPicture.asset(
            isDark ? '$base/one_small_cloud.svg' : '$base/small_clouds.svg',
            width: w * 0.2,
          ),
        ),
        // Top-right
        Positioned(
          right: -30,
          top: h * 0.02,
          child: SvgPicture.asset('$base/right_cloud.svg', width: w * 0.3),
        ),
        // Mid-left
        Positioned(
          left: -40,
          top: h * 0.40,
          child: SvgPicture.asset('$base/left_cloud.svg', width: w * 0.3),
        ),
        // Bottom-right
        Positioned(
          right: -20,
          bottom: h * 0.05,
          child: SvgPicture.asset(
            isDark
                ? '$base/one_medium_cloud.svg'
                : '$base/one_big_cloud.svg',
            width: w * 0.35,
          ),
        ),
        // Bottom-left
        Positioned(
          left: w * 0.05,
          bottom: h * 0.15,
          child: SvgPicture.asset(
              '$base/two_overlapping_cloud.svg', width: w * 0.2),
        ),
      ],
    );
  }

  Widget _title(String t, bool isDark) => Text(
        t,
        style: TextStyle(
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      );

  Widget _sub(String t, bool isDark) => Text(
        t,
        style: TextStyle(
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          fontSize: 12,
        ),
      );

  Widget _durationChips(BuildContext ctx, bool isDark) {
    const durations = [3, 4, 5, 10];
    return BlocBuilder<BreathingSetupBloc, BreathingSetupState>(
      builder: (ctx, s) => Row(
        children: durations
            .map((d) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: DurationChip(
                      label: '${d}s',
                      isSelected: s.selectedPresetDuration == d,
                      isDark: isDark,
                      onTap: () =>
                          ctx.read<BreathingSetupBloc>().add(SelectDuration(d)),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _roundsChips(BuildContext ctx, bool isDark) {
    const rounds = [
      {'v': 2, 'l': '2 quick'},
      {'v': 4, 'l': '4 calm'},
      {'v': 6, 'l': '6 deep'},
      {'v': 8, 'l': '8 zen'},
    ];
    return BlocBuilder<BreathingSetupBloc, BreathingSetupState>(
      builder: (ctx, s) => Row(
        children: rounds
            .map((r) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: DurationChip(
                      label: r['l'] as String,
                      isSelected: s.config.rounds == (r['v'] as int),
                      isDark: isDark,
                      onTap: () => ctx
                          .read<BreathingSetupBloc>()
                          .add(SelectRounds(r['v'] as int)),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _advancedTiming(BuildContext ctx, bool isDark) {
    return BlocBuilder<BreathingSetupBloc, BreathingSetupState>(
      builder: (ctx, s) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => ctx
                .read<BreathingSetupBloc>()
                .add(const ToggleAdvancedTiming()),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _title('Advanced timing', isDark),
                      const SizedBox(height: 2),
                      _sub('Set different durations for each phase', isDark),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: s.isAdvancedTimingOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(Icons.keyboard_arrow_down,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondary,
                      size: 24),
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(children: [
                PhaseDurationControl(
                    label: 'Breathe in',
                    value: s.config.breatheInDuration,
                    isDark: isDark,
                    onChanged: (v) => ctx.read<BreathingSetupBloc>().add(
                        UpdatePhaseDuration(
                            phaseType: PhaseType.breatheIn, seconds: v))),
                PhaseDurationControl(
                    label: 'Hold in',
                    value: s.config.holdInDuration,
                    isDark: isDark,
                    onChanged: (v) => ctx.read<BreathingSetupBloc>().add(
                        UpdatePhaseDuration(
                            phaseType: PhaseType.holdIn, seconds: v))),
                PhaseDurationControl(
                    label: 'Breathe out',
                    value: s.config.breatheOutDuration,
                    isDark: isDark,
                    onChanged: (v) => ctx.read<BreathingSetupBloc>().add(
                        UpdatePhaseDuration(
                            phaseType: PhaseType.breatheOut, seconds: v))),
                PhaseDurationControl(
                    label: 'Hold out',
                    value: s.config.holdOutDuration,
                    isDark: isDark,
                    onChanged: (v) => ctx.read<BreathingSetupBloc>().add(
                        UpdatePhaseDuration(
                            phaseType: PhaseType.holdOut, seconds: v))),
              ]),
            ),
            crossFadeState: s.isAdvancedTimingOpen
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _soundRow(BuildContext ctx, bool isDark) {
    return BlocBuilder<BreathingSetupBloc, BreathingSetupState>(
      builder: (ctx, s) => Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title('Sound', isDark),
                const SizedBox(height: 2),
                _sub('Gentle chime between phases', isDark),
              ],
            ),
          ),
          Switch(
            value: s.config.soundEnabled,
            onChanged: (_) =>
                ctx.read<BreathingSetupBloc>().add(const ToggleSound()),
            activeTrackColor: AppColors.switchTrack,
            inactiveTrackColor:
                isDark ? Colors.white24 : Colors.grey.shade300,
          ),
        ],
      ),
    );
  }

  Widget _startButton(BuildContext ctx, bool isDark) {
    return BlocBuilder<BreathingSetupBloc, BreathingSetupState>(
      builder: (ctx, s) => Container(
        height: 52,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        child: ElevatedButton(
          onPressed: () => Navigator.of(ctx).pushNamed(
            '/breathing',
            arguments: s.config,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50)),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Start breathing'),
              const SizedBox(width: 8),
              SvgPicture.asset('assets/icons/fast_wind.svg',
                  width: 18,
                  height: 18,
                  colorFilter: const ColorFilter.mode(
                      Colors.white, BlendMode.srcIn)),
            ],
          ),
        ),
      ),
    );
  }
}
