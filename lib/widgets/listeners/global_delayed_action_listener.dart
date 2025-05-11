import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/events/delayed_action_event.dart';
import 'package:pomodoro_flutter/event_bus/event_bus_provider.dart';
import 'package:pomodoro_flutter/event_bus/typed_event_bus.dart';
import 'package:pomodoro_flutter/widgets/delayed_action_widget.dart';

class GlobalDelayedActionListener extends StatefulWidget {
  final Widget child;

  const GlobalDelayedActionListener({super.key, required this.child});

  @override
  State<GlobalDelayedActionListener> createState() =>
      _GlobalDelayedActionListenerState();
}

class _GlobalDelayedActionListenerState
    extends State<GlobalDelayedActionListener> {
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _listenForDelayedActionEvent();
  }

    void _listenForDelayedActionEvent() {
    eventBus.onTyped<DelayedActionEvent>().listen(_showLazyConfirmation);
  }

  void _showLazyConfirmation(DelayedActionEvent event) {
    if (_overlayEntry != null) return; // Уже показано

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final overlay = Overlay.of(context);

      _overlayEntry = OverlayEntry(
        builder:
            (context) => Stack(
              children: [
                GestureDetector(
                  onTap: () {}, // Блокируем взаимодействие с фоном
                  child: Container(color: Colors.black.withOpacity(0.5)),
                ),
                DelayedActionWidget(
                  onConfirm: () {
                    _hideLazyConfirmation();
                    event.confirmationAction();
                  },
                  onPostpone: () {
                    _hideLazyConfirmation();
                    event.cancellationAction();
                  },
                ),
              ],
            ),
      );

      overlay.insert(_overlayEntry!);
    });
  }

  void _hideLazyConfirmation() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
