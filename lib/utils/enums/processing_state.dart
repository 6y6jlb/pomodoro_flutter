enum ProcessingState {
  rest,
  activity,
  inactivity,
  restDelay;

  static List<ProcessingState> hasTimer() {
    return [
      ProcessingState.rest,
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
      ProcessingState.rest: 'Перерыв',
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

  bool isResDelay() {
    return this == ProcessingState.restDelay;
  }
}

