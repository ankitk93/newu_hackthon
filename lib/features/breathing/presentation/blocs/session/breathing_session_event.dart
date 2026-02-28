import 'package:equatable/equatable.dart';
import 'package:newu_health/features/breathing/domain/entities/breathing_config.dart';

/// Events for the breathing session (timer-driven exercise).
abstract class BreathingSessionEvent extends Equatable {
  const BreathingSessionEvent();

  @override
  List<Object?> get props => [];
}

/// Start the breathing session with the given config.
class StartSession extends BreathingSessionEvent {
  final BreathingConfig config;
  const StartSession(this.config);

  @override
  List<Object?> get props => [config];
}

/// Internal timer tick — fires every second.
class TimerTick extends BreathingSessionEvent {
  const TimerTick();
}

/// User pauses the session.
class PauseSession extends BreathingSessionEvent {
  const PauseSession();
}

/// User resumes the session.
class ResumeSession extends BreathingSessionEvent {
  const ResumeSession();
}

/// User cancels/exits the session.
class CancelSession extends BreathingSessionEvent {
  const CancelSession();
}
