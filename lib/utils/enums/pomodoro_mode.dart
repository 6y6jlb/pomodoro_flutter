enum PomodoroMode { standard, scheduleBased }

extension Label on PomodoroMode {
  String label() {
    return this == PomodoroMode.scheduleBased ? 'Расписание' : 'Пользовательский';
  }
}
