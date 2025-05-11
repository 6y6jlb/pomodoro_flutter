import 'package:flutter/animation.dart';
import 'package:pomodoro_flutter/events/app_event.dart';

class DelayedActionEvent extends AppEvent {
  final String type;
  final String message;
  final VoidCallback confirmationAction;
  final VoidCallback cancellationAction;

  DelayedActionEvent({
    required this.type,
    required this.message,
    required this.confirmationAction,
    required this.cancellationAction,
  });
}
