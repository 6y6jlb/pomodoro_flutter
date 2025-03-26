import 'package:flutter/material.dart';

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
    const labels = {
      ProcessingState.activity: 'Активно',
      ProcessingState.inactivity: 'Неактивно',
      ProcessingState.rest: 'Перерыв',
      ProcessingState.restDelay: 'Перерыв отложен',
    };
    return labels[this] ?? 'Неактивно';
  }
}

extension ColorLevel on ProcessingState {
  Color colorLevel() {
    Map<ProcessingState, Color?> colorLevels = {
      ProcessingState.activity: Colors.green[400],
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
