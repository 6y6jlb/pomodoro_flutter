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

extension TypeCheck on ProcessingState {
  bool isInactive() {
    return this == ProcessingState.inactivity;
  }

  bool isActive() {
    return this == ProcessingState.activity;
  }

  bool isbriefRest() {
    return this == ProcessingState.briefRest;
  }

  bool isLongRest() {
    return this == ProcessingState.longRest;
  }

  bool isResDelay() {
    return this == ProcessingState.restDelay;
  }
}

