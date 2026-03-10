import 'package:flutter/material.dart';
import 'package:newu_health/core/theme/app_colors.dart';
import 'package:newu_health/features/breathing/domain/entities/breathing_phase.dart';

/// Animated breathing bubble — continuously scales over the full phase duration
/// using an explicit AnimationController for smooth, phase-synced motion.
class BreathingBubble extends StatefulWidget {
  final BreathingPhase phase;
  final int secondsRemaining;
  final int phaseDuration;
  final bool isDark;
  final bool isPaused;

  const BreathingBubble({
    super.key,
    required this.phase,
    required this.secondsRemaining,
    required this.phaseDuration,
    this.isDark = false,
    this.isPaused = false,
  });

  @override
  State<BreathingBubble> createState() => _BreathingBubbleState();
}

class _BreathingBubbleState extends State<BreathingBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _scaleAnimation = const AlwaysStoppedAnimation(0.5);
    _setupAnimation();
  }

  @override
  void didUpdateWidget(BreathingBubble oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.phase != widget.phase) {
      _setupAnimation();
    }

    if (oldWidget.isPaused != widget.isPaused) {
      if (widget.isPaused) {
        _controller.stop();
      } else if (_isAnimatingPhase) {
        _controller.forward();
      }
    }
  }

  bool get _isAnimatingPhase =>
      widget.phase == BreathingPhase.breatheIn ||
      widget.phase == BreathingPhase.breatheOut;

  void _setupAnimation() {
    _controller.stop();

    switch (widget.phase) {
      case BreathingPhase.breatheIn:
        _controller.duration =
            Duration(seconds: widget.phaseDuration);
        _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        );
        _controller.forward(from: 0.0);
        break;
      case BreathingPhase.holdIn:
        _scaleAnimation = const AlwaysStoppedAnimation(1.0);
        break;
      case BreathingPhase.breatheOut:
        _controller.duration =
            Duration(seconds: widget.phaseDuration);
        _scaleAnimation = Tween<double>(begin: 1.0, end: 0.5).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        );
        _controller.forward(from: 0.0);
        break;
      case BreathingPhase.holdOut:
        _scaleAnimation = const AlwaysStoppedAnimation(0.5);
        break;
    }

    if (widget.isPaused && _isAnimatingPhase) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseSize = MediaQuery.of(context).size.width * 0.5;
    final size = baseSize.clamp(140.0, 220.0);

    final bool isHold = widget.phase == BreathingPhase.holdIn ||
        widget.phase == BreathingPhase.holdOut;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        final scale = _scaleAnimation.value;
        final bubbleSize = size * scale;

        return SizedBox(
          width: bubbleSize,
          height: bubbleSize,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.85,
                colors: widget.isDark
                    ? [
                        AppColors.bubbleGradientDarkStart,
                        AppColors.bubbleGradientDarkEnd,
                      ]
                    : [
                        AppColors.bubbleGradientLightStart,
                        AppColors.bubbleGradientLightEnd,
                      ],
              ),
              border: Border(
                top: BorderSide(
                  color: widget.isDark
                      ? AppColors.bubbleBorderDark
                      : AppColors.bubbleBorderLight,
                  width: 1,
                ),
              ),
            ),
            child: Center(
              child: isHold
                  ? const SizedBox.shrink()
                  : Text(
                      '${widget.secondsRemaining}',
                      style: TextStyle(
                        color: widget.isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimary,
                        fontSize: 44 * scale,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
