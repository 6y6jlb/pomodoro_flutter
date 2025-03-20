enum PomodoroMode { standard, scheduleBased }

extension Label on PomodoroMode {
  String label() {
    return this.isScheduleBased() ? 'Расписание' : 'Пользовательский';
  }
}

extension TypeCheck on PomodoroMode {
  bool isScheduleBased() {
    return this == PomodoroMode.scheduleBased;
  }

  bool isStandart() {
    return !this.isScheduleBased();
  }
}
