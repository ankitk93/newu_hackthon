import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newu_health/features/breathing/domain/entities/breathing_phase.dart';
import 'package:newu_health/features/breathing/presentation/blocs/session/breathing_session_event.dart';
import 'package:newu_health/features/breathing/presentation/blocs/session/breathing_session_state.dart';

/// BLoC for managing the active breathing session.
/// Handles the timer, phase transitions, cycle counting, pause/resume.
class BreathingSessionBloc
    extends Bloc<BreathingSessionEvent, BreathingSessionState> {
  Timer? _timer;

  BreathingSessionBloc() : super(const SessionInitial()) {
    on<StartSession>(_onStartSession);
    on<TimerTick>(_onTimerTick);
    on<PauseSession>(_onPauseSession);
    on<ResumeSession>(_onResumeSession);
    on<CancelSession>(_onCancelSession);
  }

  void _onStartSession(
    StartSession event,
    Emitter<BreathingSessionState> emit,
  ) {
    // Start with "Get Ready" countdown from 3
    emit(GetReady(countdown: 3, config: event.config));
    _startTimer();
  }

  void _onTimerTick(
    TimerTick event,
    Emitter<BreathingSessionState> emit,
  ) {
    final currentState = state;

    if (currentState is GetReady) {
      _handleGetReadyTick(currentState, emit);
    } else if (currentState is Breathing) {
      if (!currentState.isPaused) {
        _handleBreathingTick(currentState, emit);
      }
    }
  }

  void _handleGetReadyTick(
    GetReady currentState,
    Emitter<BreathingSessionState> emit,
  ) {
    if (currentState.countdown > 1) {
      emit(GetReady(
        countdown: currentState.countdown - 1,
        config: currentState.config,
      ));
    } else {
      // Countdown done — start breathing exercise
      emit(Breathing(
        config: currentState.config,
        currentPhase: BreathingPhase.breatheIn,
        secondsRemaining: currentState.config.breatheInDuration,
        currentCycle: 1,
      ));
    }
  }

  void _handleBreathingTick(
    Breathing currentState,
    Emitter<BreathingSessionState> emit,
  ) {
    if (currentState.secondsRemaining > 1) {
      // Continue current phase
      emit(currentState.copyWith(
        secondsRemaining: currentState.secondsRemaining - 1,
      ));
    } else {
      // Phase complete — move to next phase
      _moveToNextPhase(currentState, emit);
    }
  }

  void _moveToNextPhase(
    Breathing currentState,
    Emitter<BreathingSessionState> emit,
  ) {
    final nextPhase = currentState.currentPhase.next;
    final isNewCycle = nextPhase == BreathingPhase.breatheIn;
    final nextCycle =
        isNewCycle ? currentState.currentCycle + 1 : currentState.currentCycle;

    // Check if session is complete
    if (isNewCycle && nextCycle > currentState.config.rounds) {
      _cancelTimer();
      emit(SessionCompleted(config: currentState.config));
      return;
    }

    // Get duration for the next phase
    int nextDuration;
    switch (nextPhase) {
      case BreathingPhase.breatheIn:
        nextDuration = currentState.config.breatheInDuration;
        break;
      case BreathingPhase.holdIn:
        nextDuration = currentState.config.holdInDuration;
        break;
      case BreathingPhase.breatheOut:
        nextDuration = currentState.config.breatheOutDuration;
        break;
      case BreathingPhase.holdOut:
        nextDuration = currentState.config.holdOutDuration;
        break;
    }

    emit(Breathing(
      config: currentState.config,
      currentPhase: nextPhase,
      secondsRemaining: nextDuration,
      currentCycle: nextCycle,
    ));
  }

  void _onPauseSession(
    PauseSession event,
    Emitter<BreathingSessionState> emit,
  ) {
    final currentState = state;
    if (currentState is Breathing) {
      emit(currentState.copyWith(isPaused: true));
    }
  }

  void _onResumeSession(
    ResumeSession event,
    Emitter<BreathingSessionState> emit,
  ) {
    final currentState = state;
    if (currentState is Breathing) {
      emit(currentState.copyWith(isPaused: false));
    }
  }

  void _onCancelSession(
    CancelSession event,
    Emitter<BreathingSessionState> emit,
  ) {
    _cancelTimer();
    emit(const SessionInitial());
  }

  void _startTimer() {
    _cancelTimer();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => add(const TimerTick()),
    );
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Future<void> close() {
    _cancelTimer();
    return super.close();
  }
}
