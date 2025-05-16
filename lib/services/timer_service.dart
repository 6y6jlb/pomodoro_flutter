import 'package:hive/hive.dart';

class TimerService {
  Future<void> saveRemainingTime(int remainingTime) async {
    final box = await Hive.openBox('timerState');
    await box.put('remainingTime', remainingTime);
  }

  Future<int?> loadRemainingTime() async {
    final box = await Hive.openBox('timerState');
    return box.get('remainingTime', defaultValue: 60); // Значение по умолчанию: 60 секунд
  }
}
