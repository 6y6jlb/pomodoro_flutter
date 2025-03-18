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

extension Label on ProcessingState {
  String label() {
    const labels = {
      ProcessingState.activity: 'Активно',
      ProcessingState.inactivity: 'Неактивно',
      ProcessingState.longRest: 'Отдых',
      ProcessingState.briefRest: 'Перерыв',
      ProcessingState.restDelay: 'Перерыв отложен',
    };
    return labels[this] ?? 'Неактивно';
  }
}

