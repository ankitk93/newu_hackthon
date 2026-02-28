import 'package:equatable/equatable.dart';

/// Represents the user's chosen configuration for a breathing session.
/// This is a pure domain entity with no external dependencies.
class BreathingConfig extends Equatable {
  /// Duration for breathing in, in seconds.
  final int breatheInDuration;

  /// Duration for holding after breathing in, in seconds.
  final int holdInDuration;

  /// Duration for breathing out, in seconds.
  final int breatheOutDuration;

  /// Duration for holding after breathing out, in seconds.
  final int holdOutDuration;

  /// Number of breathing cycles (rounds).
  final int rounds;

  /// Whether a gentle chime plays between phases.
  final bool soundEnabled;

  const BreathingConfig({
    this.breatheInDuration = 4,
    this.holdInDuration = 4,
    this.breatheOutDuration = 4,
    this.holdOutDuration = 4,
    this.rounds = 4,
    this.soundEnabled = true,
  });

  /// Total duration of one complete breathing cycle in seconds.
  int get cycleDuration =>
      breatheInDuration + holdInDuration + breatheOutDuration + holdOutDuration;

  /// Total session duration in seconds.
  int get totalDuration => cycleDuration * rounds;

  BreathingConfig copyWith({
    int? breatheInDuration,
    int? holdInDuration,
    int? breatheOutDuration,
    int? holdOutDuration,
    int? rounds,
    bool? soundEnabled,
  }) {
    return BreathingConfig(
      breatheInDuration: breatheInDuration ?? this.breatheInDuration,
      holdInDuration: holdInDuration ?? this.holdInDuration,
      breatheOutDuration: breatheOutDuration ?? this.breatheOutDuration,
      holdOutDuration: holdOutDuration ?? this.holdOutDuration,
      rounds: rounds ?? this.rounds,
      soundEnabled: soundEnabled ?? this.soundEnabled,
    );
  }

  @override
  List<Object?> get props => [
        breatheInDuration,
        holdInDuration,
        breatheOutDuration,
        holdOutDuration,
        rounds,
        soundEnabled,
      ];
}
