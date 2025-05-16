import 'package:vibration/vibration.dart';

class VibrationService {
  static void vibrate({int duration = 500}) {
    Vibration.vibrate(duration: duration); // Время в миллисекундах
    }
}
