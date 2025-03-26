import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/providers/processing_provider.dart';
import 'package:pomodoro_flutter/utils/app_text_styles.dart';
import 'package:pomodoro_flutter/utils/enums/processing_state.dart';
import 'package:provider/provider.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({super.key,});

  @override
  Widget build(BuildContext context) {

    final processingProvider = Provider.of<ProcessingProvider>(context);
    final processing = processingProvider.processing;

    Stream<int> createTimerStream(int durationInSeconds) {
      return Stream.periodic(
        const Duration(seconds: 1),
        (count) => count,
      ).take(durationInSeconds + 1);
    }

    return StreamBuilder<int>(
      key: ValueKey(processing.state),
      stream: createTimerStream(processing.periodDurationInSeconds),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null || !processing.state.hasTimer()) {
          return Text(
            '00:00',
            style: AppTextStyles.timer.copyWith(
              color: processing.state.colorLevel(),
            ),
          );
        }
    
        final passedSeconds = snapshot.data ?? 0;
    
        if (passedSeconds == processing.periodDurationInSeconds) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Provider.of<ProcessingProvider>(
              context,
              listen: false,
            ).makeNextPeriod();
          });
        }
    
        final remains =
            processing.periodDurationInSeconds - passedSeconds;
        final minutes = remains ~/ 60;
        final seconds = remains % 60;
    
        return Text(
          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
          style: AppTextStyles.timer.copyWith(
            color: processing.state.colorLevel(),
          ),
        );
      },
    );
  }
}
