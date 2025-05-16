import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';

@pragma('vm:entry-point')
class BackgroundService {
  static SendPort? _sendPort;

  @pragma('vm:entry-point')
  static Future<void> initialize(SendPort sendPort) async {
    _sendPort = sendPort;

    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(onStart: onStart, autoStart: true, isForegroundMode: true),
      iosConfiguration: IosConfiguration(),
    );
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();

    // Выполняем задачу каждые 10 секунд
    Timer.periodic(Duration(seconds: 10), (timer) async {
      print("Background task running at ${DateTime.now()}");

      // Отправляем запрос в основной изолят
      _sendPort?.send({'action': 'check_timer'});
    });
  }
}
