import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/widgets/timer_circle_painter.dart';

class AnimatedCircleTimer extends StatefulWidget {
  final int totalSeconds;
  final Color fillColor;
  final VoidCallback onTimerComplete;
  final Widget? upperWidget;
  final Widget? bottomWidget;

  const AnimatedCircleTimer({
    super.key,
    required this.totalSeconds,
    required this.fillColor,
    required this.onTimerComplete,
    this.upperWidget,
    this.bottomWidget,
  });

  @override
  State<AnimatedCircleTimer> createState() => _AnimatedCircleTimerState();
}

class _AnimatedCircleTimerState extends State<AnimatedCircleTimer>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.totalSeconds),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onTimerComplete();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
    final remainingSeconds =
        ((1 - _animation.value) * widget.totalSeconds).round();
    final formattedTime = _formatTime(remainingSeconds);
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: const Size(200, 200),
          painter: TimerCirclePainter(
            progress: _animation.value,
            fillColor: widget.fillColor,
            timeText: formattedTime,
            backgroundColor:
                Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
        ),
        if (widget.upperWidget != null)
          Positioned(
            top: 16, // Расстояние от верхнего края круга
            child: widget.upperWidget!,
          ),
        if (widget.bottomWidget != null)
          Positioned(bottom: 16, child: widget.bottomWidget!),
      ],
    );
  }
}
