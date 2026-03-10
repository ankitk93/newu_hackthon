import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newu_health/core/theme/app_colors.dart';

/// Shared background scaffold used by all screens: gradient + clouds (at 40%
/// opacity) + optional dark-mode stars, with a [child] overlaid on top via a
/// Stack. Each screen can supply its own [cloudBuilder] for screen-specific
/// cloud placement, or use the default two-cloud layout.
class AppScaffoldBackground extends StatelessWidget {
  final Widget child;
  final Widget Function(bool isDark, double sw, double sh)? cloudBuilder;

  const AppScaffoldBackground({
    super.key,
    required this.child,
    this.cloudBuilder,
  });

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
            if (cloudBuilder != null)
              cloudBuilder!(isDark, sw, sh)
            else
              _defaultClouds(isDark, sw, sh),
            if (isDark)
              Positioned.fill(
                child: SvgPicture.asset(
                  'assets/images/dark_mode_assets/stars.svg',
                  fit: BoxFit.cover,
                ),
              ),
            child,
          ],
        ),
      ),
    );
  }

  static Widget _defaultClouds(bool isDark, double w, double h) {
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
          top: h * 0.35,
          child: SvgPicture.asset('$base/left_cloud.svg', width: cw(0.3, 200)),
        ),
      ]),
    );
  }
}
