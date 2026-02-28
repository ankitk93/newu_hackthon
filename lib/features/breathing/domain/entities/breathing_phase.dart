/// The four phases of box breathing.
enum BreathingPhase {
  breatheIn,
  holdIn,
  breatheOut,
  holdOut,
}

/// Extension to provide display-friendly metadata for each phase.
extension BreathingPhaseExtension on BreathingPhase {
  String get label {
    switch (this) {
      case BreathingPhase.breatheIn:
        return 'Breathe in';
      case BreathingPhase.holdIn:
        return 'Hold';
      case BreathingPhase.breatheOut:
        return 'Breathe out';
      case BreathingPhase.holdOut:
        return 'Hold';
    }
  }

  String get subtitle {
    switch (this) {
      case BreathingPhase.breatheIn:
        return 'nice and slow';
      case BreathingPhase.holdIn:
        return 'hold softly';
      case BreathingPhase.breatheOut:
        return 'let it flow';
      case BreathingPhase.holdOut:
        return 'hold gently';
    }
  }

  /// Whether the bubble should be expanded during this phase.
  bool get isExpanded {
    switch (this) {
      case BreathingPhase.breatheIn:
        return true;
      case BreathingPhase.holdIn:
        return true;
      case BreathingPhase.breatheOut:
        return false;
      case BreathingPhase.holdOut:
        return false;
    }
  }

  /// Get the next phase in the cycle.
  BreathingPhase get next {
    switch (this) {
      case BreathingPhase.breatheIn:
        return BreathingPhase.holdIn;
      case BreathingPhase.holdIn:
        return BreathingPhase.breatheOut;
      case BreathingPhase.breatheOut:
        return BreathingPhase.holdOut;
      case BreathingPhase.holdOut:
        return BreathingPhase.breatheIn;
    }
  }
}
