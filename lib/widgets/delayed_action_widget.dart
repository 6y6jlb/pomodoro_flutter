import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/services/i_10n.dart';

class DelayedActionWidget extends StatefulWidget {
  final VoidCallback onConfirm;
  final VoidCallback onPostpone;

  const DelayedActionWidget({
    super.key,
    required this.onConfirm,
    required this.onPostpone,
  });

  @override
  State<DelayedActionWidget> createState() => _DelayedActionWidgetState();
}

class _DelayedActionWidgetState extends State<DelayedActionWidget> {
  int _remainingTimeInSeconds = 5; // Таймер на 5 секунд
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTimeInSeconds > 0) {
          _remainingTimeInSeconds--;
        } else {
          timer.cancel();
          widget.onConfirm(); // Автоматическое подтверждение
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              I10n().t.delayedChangeStateLabel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              "${I10n().t.timerLabel} $_remainingTimeInSeconds ${I10n().t.unitShort_seconds}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: widget.onPostpone,
                  child: Text("${I10n().t.action_delay} (${I10n().t.unitShort_minute})"),
                ),
                ElevatedButton(
                  onPressed: widget.onConfirm,
                  child: Text(I10n().t.action_confirm),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
