import 'package:equatable/equatable.dart';
import 'package:newu_health/features/breathing/domain/entities/breathing_config.dart';

/// Sentinel to distinguish "not provided" from "explicitly null".
const _sentinel = Object();

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
    Object? selectedPresetDuration = _sentinel,
    bool? isAdvancedTimingOpen,
  }) {
    return BreathingSetupState(
      config: config ?? this.config,
      selectedPresetDuration: identical(selectedPresetDuration, _sentinel)
          ? this.selectedPresetDuration
          : selectedPresetDuration as int?,
      isAdvancedTimingOpen:
          isAdvancedTimingOpen ?? this.isAdvancedTimingOpen,
    );
  }

  @override
  List<Object?> get props => [config, selectedPresetDuration, isAdvancedTimingOpen];
}
