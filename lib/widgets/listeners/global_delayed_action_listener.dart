import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/streams/global_delayed_action_stream.dart';

class GlobalLazyConfirmationListener extends StatefulWidget {
  final Widget child;

  const GlobalLazyConfirmationListener({super.key, required this.child});
  @override
  State<GlobalLazyConfirmationListener> createState() =>
      _GlobalLazyConfirmationListenerState();
}

class _GlobalLazyConfirmationListenerState
    extends State<GlobalLazyConfirmationListener> {
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _listenToGlobalStream();
  }

  void _listenToGlobalStream() {
    GlobaDelayedActionStream.stream.listen((event) {});
    // Listen to the global stream and show the confirmation dialog when needed
    // GlobalLazyConfirmationStream.listen((event) {
    //   _showConfirmationDialog(event);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
