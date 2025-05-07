import 'package:flutter/animation.dart';

class DelayedActionEvent {
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
