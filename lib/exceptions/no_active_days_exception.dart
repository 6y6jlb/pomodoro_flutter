class NoActiveDaysException implements Exception {
  final String message;

  NoActiveDaysException([
    this.message = 'No active days found in the schedule.',
  ]);

  @override
  String toString() {
    final name = toString();
    return '$name $message';
  }
}
