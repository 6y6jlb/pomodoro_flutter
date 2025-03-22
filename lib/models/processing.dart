import 'package:pomodoro_flutter/models/pomodoro_settings.dart';
import 'package:pomodoro_flutter/utils/enums/processing_state.dart';
import 'package:pomodoro_flutter/utils/settings_constant.dart';

class Processing {
  final ProcessingState state;
  final int periodDurationInSeconds;
  final PomodoroSettings? settings;

  Processing({
    required this.state,
    required this.periodDurationInSeconds,
    this.settings,
  });

  Processing _copyWith({
    ProcessingState? state,
    int? periodDurationInSeconds,
    PomodoroSettings? settings,
  }) {
    return Processing(
      state: state ?? this.state,
      periodDurationInSeconds:
          periodDurationInSeconds ?? this.periodDurationInSeconds,
      settings: settings ?? this.settings,
    );
  }

  Processing makeRest() {
    return _copyWith(
      state: ProcessingState.rest,
      periodDurationInSeconds:
          settings?.currentBreakDurationInSeconds ??
          SettingsConstant.defaultBreakDurationInSeconds,
    );
  }

  Processing makeRestDelay() {
    return _copyWith(
      state: ProcessingState.restDelay,
      periodDurationInSeconds:
          SettingsConstant.defaultRestDelayDurationInSeconds, // TO:DO настройка
    );
  }

  Processing makeActive() {
    return _copyWith(
      state: ProcessingState.activity,
      periodDurationInSeconds:
          settings?.currentSessionDurationInSeconds ??
          SettingsConstant.defaultSessionDurationInSeconds,
    );
  }

  Processing makeInactive() {
    return _copyWith(
      state: ProcessingState.inactivity,
      periodDurationInSeconds: 0,
    );
  }

  ProcessingState getNextProcessingState() {
    final currentProcessingState = state;

    if (settings == null) {
      return ProcessingState.inactivity;
    }

    return currentProcessingState.isActive()
        ? ProcessingState.rest
        : ProcessingState.activity;
  }
}
