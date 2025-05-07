import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/providers/processing_provider.dart';
import 'package:pomodoro_flutter/utils/styles/app_text_styles.dart';
import 'package:pomodoro_flutter/enums/processing_state.dart';
import 'package:pomodoro_flutter/widgets/animated_circle_times.dart';
import 'package:provider/provider.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final processingProvider = Provider.of<ProcessingProvider>(context);
    final processing = processingProvider.processing;
    final settings = processingProvider.settings;

    ButtonStyle commonButtonStyles = ElevatedButton.styleFrom(
      backgroundColor: processing.state.colorLevel(),
    );

    Widget buildBottomActionWidget() {
      return ElevatedButton(
        style: commonButtonStyles,
        onPressed:
            processing.state.hasTimer()
                ? () => processingProvider.changeState(ProcessingState.inactivity)
                : null,
        child: Text(
          'Стоп',
          style: AppTextStyles.action.copyWith(
            color: Colors.white,
          ),
        ),
      );
    }

    Widget buildUpperActionWidget() {
      TextStyle commonTextStyles = AppTextStyles.action.copyWith(
        color: Colors.white,
      );
      if (processing.state.isRest()) {
        return ElevatedButton(
          style: commonButtonStyles,
          onPressed: () => processingProvider.changeState(ProcessingState.restDelay),
          child: Text('Отложить', style: commonTextStyles),
        );
      } else if (processing.state.isInactive()) {
        return ElevatedButton(
          style: commonButtonStyles,
          onPressed: settings!.isActive ? () => processingProvider.changeState(ProcessingState.activity) : null,
          child: Text('Запуск', style: commonTextStyles),
        );
      } else {
        return ElevatedButton(
          style: commonButtonStyles,
          onPressed: () => processingProvider.changeState(ProcessingState.rest),
          child: Text('Перерыв', style: commonTextStyles),
        );
      }
    }

    return AnimatedCircleTimer(
      key: ValueKey(processing.state),
      totalSeconds: processing.periodDurationInSeconds,
      fillColor: processing.state.colorLevel(),
      bottomWidget: buildBottomActionWidget(),
      upperWidget: buildUpperActionWidget(),
      onTimerComplete: () {
        Provider.of<ProcessingProvider>(
          context,
          listen: false,
        ).makeNextPeriod();
      },
    );
  }
}
