import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/providers/processing_provider.dart';
import 'package:pomodoro_flutter/utils/app_text_styles.dart';
import 'package:pomodoro_flutter/utils/enums/processing_state.dart';
import 'package:pomodoro_flutter/widgets/animated_circle_times.dart';
import 'package:provider/provider.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final processingProvider = Provider.of<ProcessingProvider>(context);
    final processing = processingProvider.processing;

    Widget _buildBottomActionWidget() {
      return ElevatedButton(
        onPressed:
            processing.state.hasTimer()
                ? processingProvider.makeInactive
                : null,
        child: Text(
          'Стоп',
          style: AppTextStyles.action.copyWith(color: Colors.blueGrey[900]),
        ),
      );
    }

    ButtonStyle commonButtonStyles = ElevatedButton.styleFrom(
      backgroundColor: processing.state.colorLevel(),
    );

    Widget _buildUpperActionWidget() {
      TextStyle commonTextStyles = AppTextStyles.action.copyWith(
        color: Colors.white,
      );
      if (processing.state.isRest()) {
        return ElevatedButton(
          style: commonButtonStyles,
          onPressed: processingProvider.makeRestDelay,
          child: Text('Отложить', style: commonTextStyles),
        );
      } else if (processing.state.isInactive()) {
        return ElevatedButton(
          style: commonButtonStyles,
          onPressed: processingProvider.makeActive,
          child: Text('Запуск', style: commonTextStyles),
        );
      } else {
        return ElevatedButton(
          style: commonButtonStyles,
          onPressed: processingProvider.makeRest,
          child: Text('Перерыв', style: commonTextStyles),
        );
      }
    }

    return AnimatedCircleTimer(
      key: ValueKey(processing.state),
      totalSeconds: processing.periodDurationInSeconds,
      fillColor: processing.state.colorLevel(),
      bottomWidget: _buildBottomActionWidget(),
      upperWidget: _buildUpperActionWidget(),
      onTimerComplete: () {
        Provider.of<ProcessingProvider>(
          context,
          listen: false,
        ).makeNextPeriod();
      },
    );
  }
}
