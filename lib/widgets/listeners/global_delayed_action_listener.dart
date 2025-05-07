import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/events/delayed_action_event.dart';
import 'package:pomodoro_flutter/streams/global_delayed_action_stream.dart';
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
    _listenToGlobalStream();
  }

  void _listenToGlobalStream() {
    GlobaDelayedActionStream.stream.listen(_showLazyConfirmation);
  }

  void _showLazyConfirmation(DelayedActionEvent event) {
    if (_overlayEntry != null) return; // Уже показано

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              GestureDetector(
                onTap: () {}, // Блокируем взаимодействие с фоном
                child: Container(color: Colors.black.withOpacity(0.5)),
              ),
              DelayedActionWidget(
                onConfirm: event.confirmationAction,
                onPostpone: event.cancellationAction,
              ),
            ],
          ),
    );

    Overlay.of(context)?.insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
