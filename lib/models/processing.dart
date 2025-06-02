import 'package:hive/hive.dart';
import 'package:pomodoro_flutter/enums/processing_state.dart';
import 'package:pomodoro_flutter/models/pomodoro_settings.dart';
import 'package:pomodoro_flutter/utils/consts/hive_type_id.dart';
import 'package:pomodoro_flutter/utils/consts/settings_constant.dart';

part 'processing.g.dart';

@HiveType(typeId: HiveTypeId.processing)
class Processing {
  @HiveField(0)
  final ProcessingState state;

  @HiveField(1)
  final PomodoroSettings? settings;

  @HiveField(2)
  final int remainingTime;

  @HiveField(3)
  final bool isTimerRunning;

  Processing({required this.state, this.settings, this.remainingTime = 0, this.isTimerRunning = false});

  Processing copyWith({ProcessingState? state, PomodoroSettings? settings, int? remainingTime, bool? isTimerRunning}) {
    return Processing(
      state: state ?? this.state,
      settings: settings ?? this.settings,
      remainingTime: remainingTime ?? this.remainingTime,
      isTimerRunning: isTimerRunning ?? this.isTimerRunning,
    );
  }

  Processing copyWithNewState(ProcessingState state) {
    return copyWith(state: state);
  }

  Processing copyWithNewSettings(PomodoroSettings settings) {
    return copyWith(settings: settings);
  }

  ProcessingState getNextProcessingState() {
    if (settings == null) {
      return ProcessingState.inactivity;
    }

    if (state.isRest()) {
      return ProcessingState.activity;
    } else if (state.isRestDelay()) {
      return ProcessingState.rest;
    } else {
      return ProcessingState.rest;
    }
  }

  int get periodDurationInSeconds {
    switch (state) {
      case ProcessingState.activity:
        return settings?.currentSessionDurationInSeconds ?? SettingsConstant.defaultSessionDurationInSeconds;
      case ProcessingState.rest:
        return settings?.currentBreakDurationInSeconds ?? SettingsConstant.defaultBreakDurationInSeconds;
      case ProcessingState.restDelay:
        return SettingsConstant.defaultRestDelayDurationInSeconds;
      case ProcessingState.inactivity:
        return 0;
    }
  }
}
