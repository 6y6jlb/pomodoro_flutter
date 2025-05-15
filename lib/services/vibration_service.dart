import 'package:vibration/vibration.dart';

class VibrationService {
  static void vibrate({int duration = 500}) {
    if (Vibration.hasVibrator() != null) {
      Vibration.vibrate(duration: duration); // Время в миллисекундах
    }
  }
}
