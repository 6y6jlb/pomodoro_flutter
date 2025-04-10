class WeekHelper {

  static List<int> get daysOfWeekIndexes => getDaysOfWeekIndexes;

  static final List<int> getDaysOfWeekIndexes = List.generate(7, (index) {
    final firstDayOfWeek = DateTime.now().subtract(
      Duration(days: DateTime.now().weekday - 1),
    );
    return firstDayOfWeek.add(Duration(days: index)).weekday % 7;
  });

}