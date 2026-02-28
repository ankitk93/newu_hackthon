import 'package:equatable/equatable.dart';
import 'package:newu_health/features/breathing/domain/entities/breathing_config.dart';

/// State for the breathing setup screen.
class BreathingSetupState extends Equatable {
  /// The user's current configuration.
  final BreathingConfig config;

  /// The currently selected preset duration (null if using advanced).
  final int? selectedPresetDuration;

  /// Whether the advanced timing panel is expanded.
  final bool isAdvancedTimingOpen;

  const BreathingSetupState({
    this.config = const BreathingConfig(),
    this.selectedPresetDuration = 4,
    this.isAdvancedTimingOpen = false,
  });

  BreathingSetupState copyWith({
    BreathingConfig? config,
    int? selectedPresetDuration,
    bool? isAdvancedTimingOpen,
  }) {
    return BreathingSetupState(
      config: config ?? this.config,
      selectedPresetDuration:
          selectedPresetDuration ?? this.selectedPresetDuration,
      isAdvancedTimingOpen:
          isAdvancedTimingOpen ?? this.isAdvancedTimingOpen,
    );
  }

  @override
  List<Object?> get props => [config, selectedPresetDuration, isAdvancedTimingOpen];
}
