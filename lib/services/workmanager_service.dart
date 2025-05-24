import 'package:pomodoro_flutter/services/app_initializer.dart';
import 'package:pomodoro_flutter/services/task_handler.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  print('Workmanager callbackDispatcher called');
  Workmanager().executeTask((task, inputData) async {
    print('Workmanager task executed: $task && $inputData');
    await AppInitializer.initializeApp(isBackground: true);
    return TaskHandler.executeTask(task, inputData);
  });
}

class WorkmanagerService {
  static void initialize() {
    Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
    print('WorkmanagerService.initialize called');
  }
}
