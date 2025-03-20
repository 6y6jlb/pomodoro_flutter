import 'package:pomodoro_flutter/models/pomodoro_settings.dart';
import 'package:pomodoro_flutter/models/schedule.dart';
import 'package:pomodoro_flutter/utils/enums/pomodoro_mode.dart';
import 'package:pomodoro_flutter/utils/enums/processing_state.dart';

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

  Processing makeBriefRest() {
    return _copyWith(state: ProcessingState.briefRest);
  }

  Processing makeLongfRest() {
    return _copyWith(state: ProcessingState.longRest);
  }

  Processing makeRestDelay() {
    return _copyWith(state: ProcessingState.restDelay);
  }

  Processing makeActive() {
    return _copyWith(state: ProcessingState.activity);
  }

  Processing makeInactive() {
    return _copyWith(state: ProcessingState.inactivity);
  }

  ProcessingState getNextProcessingState() {
    final currentProcessingState = this.state;

    if(settings == null) {
      return ProcessingState.inactivity;
    }

    if(settings!.mode.isStandart()) {
      return currentProcessingState.isActive() ? ProcessingState.inactivity : ProcessingState.activity;
    } 

    if(settings!.mode.isScheduleBased()) {} 
    // if schedule based -> check it active or not
    // if schefule active -> get next proccessing type based on current type and next break type(long, short, delay)
    // if schedult inactive -> make inactive
    // -
    // if standart -> get next proccessing type based on current type(active->break->active(delay conditionally))

   return ProcessingState.inactivity;
  }
}
