import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/providers/processing_provider.dart';
import 'package:pomodoro_flutter/services/i_10n.dart';
import 'package:pomodoro_flutter/theme/processing_colors.dart';
import 'package:pomodoro_flutter/utils/styles/app_text_styles.dart';
import 'package:pomodoro_flutter/enums/processing_state.dart';
import 'package:pomodoro_flutter/widgets/animated_circle_timer.dart';
import 'package:provider/provider.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final processingProvider = Provider.of<ProcessingProvider>(context);
    final processing = processingProvider.processing;
    final settings = processingProvider.settings;

ButtonStyle commonButtonStyles = ElevatedButton.styleFrom(
      backgroundColor: processing.state.colorLevel(
        Theme.of(context).extension<ProcessingColors>()!,
      ),
    );

    Widget buildBottomActionWidget() {
      return ElevatedButton(
        style: commonButtonStyles,
        onPressed:
            processing.state.hasTimer()
                ? () => processingProvider.changeState(ProcessingState.inactivity)
                : null,
        child: Text(
          I10n().t.action_stop,
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
          child: Text(I10n().t.action_delay, style: commonTextStyles),
        );
      } else if (processing.state.isInactive()) {
        return ElevatedButton(
          style: commonButtonStyles,
          onPressed: settings!.isActive ? () => processingProvider.changeState(ProcessingState.activity) : null,
          child: Text(I10n().t.action_start, style: commonTextStyles),
        );
      } else {
        return ElevatedButton(
          style: commonButtonStyles,
          onPressed: () => processingProvider.changeState(ProcessingState.rest),
          child: Text(I10n().t.action_rest, style: commonTextStyles),
        );
      }
    }

    return AnimatedCircleTimer(
      key: ValueKey(processing.state),
     fillColor: processing.state.colorLevel(
        Theme.of(context).extension<ProcessingColors>()!,
      ),
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
