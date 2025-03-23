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
      periodDurationInSeconds: curentPeriodDurationInSeconds(
        ProcessingState.rest,
      ),
    );
  }

  Processing makeRestDelay() {
    return _copyWith(
      state: ProcessingState.restDelay,
      periodDurationInSeconds: curentPeriodDurationInSeconds(
        ProcessingState.restDelay,
      ),
    );
  }

  Processing makeActive() {
    return _copyWith(
      state: ProcessingState.activity,
      periodDurationInSeconds: curentPeriodDurationInSeconds(
        ProcessingState.activity,
      ),
    );
  }

  Processing makeInactive() {
    return _copyWith(
      state: ProcessingState.inactivity,
      periodDurationInSeconds: curentPeriodDurationInSeconds(
        ProcessingState.inactivity,
      ),
    );
  }

  Processing updateSettings(PomodoroSettings settings) {
    return _copyWith(
      settings: settings,
      periodDurationInSeconds: curentPeriodDurationInSeconds(state),
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

  int curentPeriodDurationInSeconds(ProcessingState state) {
    switch (state) {
      case ProcessingState.activity:
        return settings?.currentSessionDurationInSeconds ??
            SettingsConstant.defaultSessionDurationInSeconds;
      case ProcessingState.rest:
        return settings?.currentBreakDurationInSeconds ??
            SettingsConstant.defaultBreakDurationInSeconds;
      case ProcessingState.restDelay:
        return SettingsConstant.defaultRestDelayDurationInSeconds;
      case ProcessingState.inactivity:
        return 0;
    }
  }
}
