import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/enums/alert_level.dart';
import 'package:pomodoro_flutter/theme/AlertColors';

class InfoBlockWidget extends StatelessWidget {
  final String title;
  final String description;
  final AlertLevel level;

  const InfoBlockWidget({
    super.key,
    required this.title,
    required this.description,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {

    final alertColors = Theme.of(context).extension<AlertColors>()!;

    final Color backgroundColor;
    switch (level) {
      case AlertLevel.info:
        backgroundColor = alertColors.info;
        break;
      case AlertLevel.warning:
        backgroundColor = alertColors.warning;
        break;
      case AlertLevel.success:
        backgroundColor = alertColors.success;
        break;
      case AlertLevel.danger:
        backgroundColor = alertColors.danger;
        break;
    }


    final isLightBackground =
        ThemeData.estimateBrightnessForColor(backgroundColor) ==
        Brightness.light;
    final textColor = isLightBackground ? Colors.black : Colors.white;

    return Card(
      elevation: 2,
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 14, color: textColor.withOpacity(0.8)),
            ),
          ],
        ),
      ),
    );
  }
}
