import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newu_health/features/breathing/domain/entities/breathing_config.dart';
import 'package:newu_health/features/breathing/presentation/blocs/setup/breathing_setup_event.dart';
import 'package:newu_health/features/breathing/presentation/blocs/setup/breathing_setup_state.dart';

/// BLoC for the breathing setup screen.
/// Manages user selections for breath duration, rounds, advanced timing, and sound.
class BreathingSetupBloc
    extends Bloc<BreathingSetupEvent, BreathingSetupState> {
  BreathingSetupBloc() : super(const BreathingSetupState()) {
    on<SelectDuration>(_onSelectDuration);
    on<SelectRounds>(_onSelectRounds);
    on<ToggleAdvancedTiming>(_onToggleAdvancedTiming);
    on<UpdatePhaseDuration>(_onUpdatePhaseDuration);
    on<ToggleSound>(_onToggleSound);
  }

  void _onSelectDuration(
    SelectDuration event,
    Emitter<BreathingSetupState> emit,
  ) {
    emit(state.copyWith(
      selectedPresetDuration: event.seconds,
      config: state.config.copyWith(
        breatheInDuration: event.seconds,
        holdInDuration: event.seconds,
        breatheOutDuration: event.seconds,
        holdOutDuration: event.seconds,
      ),
    ));
  }

  void _onSelectRounds(
    SelectRounds event,
    Emitter<BreathingSetupState> emit,
  ) {
    emit(state.copyWith(
      config: state.config.copyWith(rounds: event.rounds),
    ));
  }

  void _onToggleAdvancedTiming(
    ToggleAdvancedTiming event,
    Emitter<BreathingSetupState> emit,
  ) {
    emit(state.copyWith(
      isAdvancedTimingOpen: !state.isAdvancedTimingOpen,
    ));
  }

  void _onUpdatePhaseDuration(
    UpdatePhaseDuration event,
    Emitter<BreathingSetupState> emit,
  ) {
    final clamped = event.seconds.clamp(2, 10);
    BreathingConfig updatedConfig;
    switch (event.phaseType) {
      case PhaseType.breatheIn:
        updatedConfig = state.config.copyWith(breatheInDuration: clamped);
        break;
      case PhaseType.holdIn:
        updatedConfig = state.config.copyWith(holdInDuration: clamped);
        break;
      case PhaseType.breatheOut:
        updatedConfig = state.config.copyWith(breatheOutDuration: clamped);
        break;
      case PhaseType.holdOut:
        updatedConfig = state.config.copyWith(holdOutDuration: clamped);
        break;
    }
    // Clear preset when user manually adjusts timing
    emit(state.copyWith(
      config: updatedConfig,
      selectedPresetDuration: null,
    ));
  }

  void _onToggleSound(
    ToggleSound event,
    Emitter<BreathingSetupState> emit,
  ) {
    emit(state.copyWith(
      config: state.config.copyWith(soundEnabled: !state.config.soundEnabled),
    ));
  }
}
