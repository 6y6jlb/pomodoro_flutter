enum ProcessingState {
  briefRest,
  longRest,
  activity,
  inactivity,
  restDelay;

  static List<ProcessingState> hasTimer() {
    return [
      ProcessingState.briefRest,
      ProcessingState.longRest,
      ProcessingState.activity,
      ProcessingState.restDelay,
    ];
  }
}
