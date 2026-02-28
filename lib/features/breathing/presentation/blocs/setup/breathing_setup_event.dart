import 'package:equatable/equatable.dart';

/// Events for the breathing setup screen.
abstract class BreathingSetupEvent extends Equatable {
  const BreathingSetupEvent();

  @override
  List<Object?> get props => [];
}

/// User selects a preset breath duration (3s, 4s, 5s, 10s).
/// This sets all four phases to the same duration.
class SelectDuration extends BreathingSetupEvent {
  final int seconds;
  const SelectDuration(this.seconds);

  @override
  List<Object?> get props => [seconds];
}

/// User selects the number of rounds (2, 4, 6, 8).
class SelectRounds extends BreathingSetupEvent {
  final int rounds;
  const SelectRounds(this.rounds);

  @override
  List<Object?> get props => [rounds];
}

/// User toggles the advanced timing panel open/closed.
class ToggleAdvancedTiming extends BreathingSetupEvent {
  const ToggleAdvancedTiming();
}

/// User adjusts an individual phase duration in advanced timing.
class UpdatePhaseDuration extends BreathingSetupEvent {
  final PhaseType phaseType;
  final int seconds;
  const UpdatePhaseDuration({required this.phaseType, required this.seconds});

  @override
  List<Object?> get props => [phaseType, seconds];
}

/// User toggles the sound on/off.
class ToggleSound extends BreathingSetupEvent {
  const ToggleSound();
}

/// Identifies which phase is being adjusted in advanced timing.
enum PhaseType { breatheIn, holdIn, breatheOut, holdOut }
