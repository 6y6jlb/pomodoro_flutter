import 'package:pomodoro_flutter/services/app_initializer.dart';
import 'package:pomodoro_flutter/services/task_handler.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
class WorkmanagerService {
  static void initialize() {
    Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  }

  @pragma('vm:entry-point')
  static void callbackDispatcher() {
    print('Workmanager callbackDispatcher called');
    Workmanager().executeTask((task, inputData) async {
      print('Workmanager task executed: $task');
      await AppInitializer.initializeApp(isBackground: true);
      return TaskHandler.executeTask(task, inputData);
    });
  }
}
