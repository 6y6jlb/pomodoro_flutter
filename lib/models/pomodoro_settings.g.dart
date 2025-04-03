// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pomodoro_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PomodoroSettingsAdapter extends TypeAdapter<PomodoroSettings> {
  @override
  final int typeId = 2;

  @override
  PomodoroSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PomodoroSettings(
      mode: fields[0] as PomodoroMode,
      schedule: fields[1] as Schedule?,
      userSessionDurationInSeconds: fields[2] as int,
      userBreakDurationInSeconds: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PomodoroSettings obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.mode)
      ..writeByte(1)
      ..write(obj.schedule)
      ..writeByte(2)
      ..write(obj.userSessionDurationInSeconds)
      ..writeByte(3)
      ..write(obj.userBreakDurationInSeconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PomodoroSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
