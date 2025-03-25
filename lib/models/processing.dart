import 'package:pomodoro_flutter/models/pomodoro_settings.dart';
import 'package:pomodoro_flutter/utils/enums/processing_state.dart';
import 'package:pomodoro_flutter/utils/settings_constant.dart';

class Processing {
  final ProcessingState state;
  final PomodoroSettings? settings;

  Processing({required this.state, this.settings});

  Processing _copyWith({ProcessingState? state, PomodoroSettings? settings}) {
    return Processing(
      state: state ?? this.state,
      settings: settings ?? this.settings,
    );
  }

  Processing copyWithNewState(ProcessingState state) {
    return _copyWith(state: state);
  }

  Processing copyWithNewSettings(PomodoroSettings settings) {
    return _copyWith(settings: settings);
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

  int get periodDurationInSeconds {
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
