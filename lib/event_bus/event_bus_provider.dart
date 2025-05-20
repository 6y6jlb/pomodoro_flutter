import 'package:event_bus/event_bus.dart';
import 'package:pomodoro_flutter/events/app_event.dart';

// Глобальный экземпляр EventBus
final eventBus = EventBus();

extension TypedEventBus on EventBus {
  void emit<T extends AppEvent>(T event) {
    fire(event);
  }

  Stream<T> onTyped<T extends AppEvent>() {
    return on<T>();
  }
}
