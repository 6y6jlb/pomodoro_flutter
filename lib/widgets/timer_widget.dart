import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/providers/processing_provider.dart';
import 'package:pomodoro_flutter/utils/enums/processing_state.dart';
import 'package:pomodoro_flutter/widgets/animated_circle_times.dart';
import 'package:provider/provider.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final processingProvider = Provider.of<ProcessingProvider>(context);
    final processing = processingProvider.processing;


    return AnimatedCircleTimer(
      key: ValueKey(processing.state),
      totalSeconds: processing.periodDurationInSeconds,
      fillColor: processing.state.colorLevel(),
      onTimerComplete: () {
        Provider.of<ProcessingProvider>(
          context,
          listen: false,
        ).makeNextPeriod();
      },
    );
  }
}
