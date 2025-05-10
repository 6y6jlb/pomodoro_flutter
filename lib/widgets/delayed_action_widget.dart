import 'dart:async';

import 'package:flutter/material.dart';

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
  int _remainingTime = 5; // Таймер на 5 секунд
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
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
              'Подтвердите смену статуса',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Таймер: $_remainingTime сек.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: widget.onPostpone,
                  child: const Text('Отложить (5 мин.)'),
                ),
                ElevatedButton(
                  onPressed: widget.onConfirm,
                  child: const Text('Подтвердить'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
