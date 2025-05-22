import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/providers/processing_provider.dart';
import 'package:pomodoro_flutter/widgets/timer_circle_painter.dart';
import 'package:provider/provider.dart';

class AnimatedCircleTimer extends StatelessWidget {
  final Color fillColor;
  final VoidCallback onTimerComplete;
  final Widget? upperWidget;
  final Widget? bottomWidget;

  const AnimatedCircleTimer({
    super.key,
    required this.fillColor,
    required this.onTimerComplete,
    this.upperWidget,
    this.bottomWidget,
  });

  String _formatTime(int seconds) {
    if (seconds >= 3600) {
      final hours = seconds ~/ 3600;
      final minutes = (seconds % 3600) ~/ 60;
      final remainingSeconds = seconds % 60;
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    } else {
      final minutes = seconds ~/ 60;
      final remainingSeconds = seconds % 60;
      return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final processingProvider = Provider.of<ProcessingProvider>(context);
    final totalSeconds = processingProvider.processing.periodDurationInSeconds;
    final remainingSeconds = processingProvider.remainingTime;
    final formattedTime = _formatTime(remainingSeconds);
    final progress = totalSeconds > 0 ? 1 - (remainingSeconds / totalSeconds) : 0.0;

    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: const Size(200, 200),
          painter: TimerCirclePainter(
            progress: progress,
            fillColor: fillColor,
            timeText: formattedTime,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
        ),
        if (upperWidget != null) Positioned(top: 16, child: upperWidget!),
        if (bottomWidget != null) Positioned(bottom: 16, child: bottomWidget!),
      ],
    );
  }
}
