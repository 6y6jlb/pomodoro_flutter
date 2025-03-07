import 'package:pomodoro_flutter/utils/enums/processing_state.dart';

class Processing {
  final ProcessingState state;

  Processing({required this.state});

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

  Processing _copyWith({ProcessingState? state}) {
    return Processing(state: state ?? this.state);
  }
}
