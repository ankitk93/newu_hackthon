import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:newu_health/core/theme/app_colors.dart';
import 'package:newu_health/core/theme/theme_cubit.dart';
import 'package:newu_health/core/utils/dotlottie_util.dart';
import 'package:newu_health/core/utils/responsive_utils.dart';
import 'package:newu_health/features/breathing/domain/entities/breathing_config.dart';

/// Finish screen — exact Figma match.
/// Vertically centered: checkmark, title, message, Start again (gradient), Back to set up (purple).
/// NO stats card.
class FinishScreen extends StatefulWidget {
  final BreathingConfig config;
  const FinishScreen({super.key, required this.config});

  @override
  State<FinishScreen> createState() => _FinishScreenState();
}

class _FinishScreenState extends State<FinishScreen> {
  late final Future<Uint8List> _animationBytes;

  @override
  void initState() {
    super.initState();
    _animationBytes =
        loadDotLottieAsset('assets/animations/green_check.lottie');
  }

  BreathingConfig get config => widget.config;

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
              child: Column(
                children: [
                  // Theme toggle — full-width, top right (outside ConstrainedBox)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Align(
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
                  ),
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              const Spacer(),
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: FutureBuilder<Uint8List>(
                            future: _animationBytes,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Lottie.memory(
                                  snapshot.data!,
                                  repeat: false,
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Title
                        Text(
                          'You did it! 🎉',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimary,
                            fontSize: Responsive.fontSize(context, 24),
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        // Message
                        Text(
                          'Great rounds of calm, just like that.\nYour mind thanks you.',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondary,
                            fontSize: Responsive.fontSize(context, 12),
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        // Start again — primary purple button
                        Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.buttonBgColorDark : AppColors.buttonBgColorLight,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: ElevatedButton(
                            onPressed: () =>
                                Navigator.of(context).pushReplacementNamed(
                              '/breathing',
                              arguments: config,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              textStyle: TextStyle(
                                  fontSize: Responsive.fontSize(context, 16), fontWeight: FontWeight.w600),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Start again'),
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
                        const SizedBox(height: 16),
                        // Back to set up — purple text
                        Container(
                          width: double.infinity,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.cardDark
                                : AppColors.backToSetup.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: TextButton(
                            onPressed: () =>
                                Navigator.of(context).pushNamedAndRemoveUntil(
                              '/',
                              (route) => false,
                            ),
                            child: Text(
                              'Back to set up',
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.backToSetup,
                                fontSize: Responsive.fontSize(context, 14),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
    double cw(double factor, double max) => (w * factor).clamp(0, max);
    return Opacity(
      opacity: 0.4,
      child: Stack(children: [
        Positioned(
          right: -20,
          top: h * 0.03,
          child: SvgPicture.asset('$base/right_cloud.svg', width: cw(0.28, 200)),
        ),
        Positioned(
          left: -30,
          bottom: h * 0.1,
          child: SvgPicture.asset('$base/left_cloud.svg', width: cw(0.3, 200)),
        ),
      ]),
    );
  }
}
