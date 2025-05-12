import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/utils/translation/t.dart';

enum ProcessingState { rest, activity, inactivity, restDelay }

extension HasTime on ProcessingState {
  bool hasTimer() {
    return [
      ProcessingState.rest,
      ProcessingState.activity,
      ProcessingState.restDelay,
    ].contains(this);
  }
}

extension Label on ProcessingState {
  String label() {
    var labels = {
      ProcessingState.activity: t.processingStateLabel_activity,
      ProcessingState.inactivity: t.processingStateLabel_inactivity,
      ProcessingState.rest: t.processingStateLabel_rest,
      ProcessingState.restDelay: t.processingStateLabel_restDelay,
    };
    return labels[this] ?? t.processingStateLabel_unknown;
  }
}

extension ColorLevel on ProcessingState {
  Color colorLevel() {
    Map<ProcessingState, Color?> colorLevels = {
      ProcessingState.activity: Colors.green[300],
      ProcessingState.inactivity: Colors.grey[500],
      ProcessingState.rest: Colors.blue[400],
      ProcessingState.restDelay: Colors.deepPurple[300],
    };
    return colorLevels[this] ?? Colors.blueGrey;
  }
}

extension TypeCheck on ProcessingState {
  bool isInactive() {
    return this == ProcessingState.inactivity;
  }

  bool isActive() {
    return this == ProcessingState.activity;
  }

  bool isRestDelay() {
    return this == ProcessingState.restDelay;
  }

  bool isRest() {
    return this == ProcessingState.rest;
  }
}
