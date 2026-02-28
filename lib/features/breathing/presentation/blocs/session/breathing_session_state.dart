import 'package:equatable/equatable.dart';
import 'package:newu_health/features/breathing/domain/entities/breathing_config.dart';
import 'package:newu_health/features/breathing/domain/entities/breathing_phase.dart';

/// States for the breathing session.
abstract class BreathingSessionState extends Equatable {
  const BreathingSessionState();

  @override
  List<Object?> get props => [];
}

/// Initial state — no session running.
class SessionInitial extends BreathingSessionState {
  const SessionInitial();
}

/// "Get Ready" countdown (3, 2, 1).
class GetReady extends BreathingSessionState {
  final int countdown;
  final BreathingConfig config;

  const GetReady({required this.countdown, required this.config});

  @override
  List<Object?> get props => [countdown, config];
}

/// Active breathing exercise.
class Breathing extends BreathingSessionState {
  final BreathingConfig config;
  final BreathingPhase currentPhase;
  final int secondsRemaining;
  final int currentCycle;
  final bool isPaused;

  const Breathing({
    required this.config,
    required this.currentPhase,
    required this.secondsRemaining,
    required this.currentCycle,
    this.isPaused = false,
  });

  /// Total seconds elapsed in the entire session.
  int get totalElapsed {
    int elapsed = 0;
    // Full completed cycles
    elapsed += (currentCycle - 1) * config.cycleDuration;
    // Phases completed in current cycle
    BreathingPhase phase = BreathingPhase.breatheIn;
    while (phase != currentPhase) {
      elapsed += _phaseDuration(phase);
      phase = phase.next;
    }
    // Time elapsed in current phase
    elapsed += _phaseDuration(currentPhase) - secondsRemaining;
    return elapsed;
  }

  /// Total session duration in seconds.
  int get totalDuration => config.totalDuration;

  /// Progress from 0.0 to 1.0.
  double get progress {
    if (totalDuration == 0) return 0;
    return totalElapsed / totalDuration;
  }

  int _phaseDuration(BreathingPhase phase) {
    switch (phase) {
      case BreathingPhase.breatheIn:
        return config.breatheInDuration;
      case BreathingPhase.holdIn:
        return config.holdInDuration;
      case BreathingPhase.breatheOut:
        return config.breatheOutDuration;
      case BreathingPhase.holdOut:
        return config.holdOutDuration;
    }
  }

  Breathing copyWith({
    BreathingConfig? config,
    BreathingPhase? currentPhase,
    int? secondsRemaining,
    int? currentCycle,
    bool? isPaused,
  }) {
    return Breathing(
      config: config ?? this.config,
      currentPhase: currentPhase ?? this.currentPhase,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      currentCycle: currentCycle ?? this.currentCycle,
      isPaused: isPaused ?? this.isPaused,
    );
  }

  @override
  List<Object?> get props => [
        config,
        currentPhase,
        secondsRemaining,
        currentCycle,
        isPaused,
      ];
}

/// Session completed — all cycles done.
class SessionCompleted extends BreathingSessionState {
  final BreathingConfig config;

  const SessionCompleted({required this.config});

  @override
  List<Object?> get props => [config];
}
