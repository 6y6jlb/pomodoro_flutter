// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScheduleAdapter extends TypeAdapter<Schedule> {
  @override
  final int typeId = 1;

  @override
  Schedule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Schedule(
      activeDaysOfWeek: (fields[0] as List).cast<int>(),
      exceptionsDays: (fields[1] as List).cast<DateTime>(),
      breakDurationInSeconds: fields[4] as int,
      plannedTimeBreaks: (fields[2] as List).cast<TimePeriod>(),
      activeTimePeriod: fields[3] as TimePeriod,
      sessionDurationInSeconds: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Schedule obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.activeDaysOfWeek)
      ..writeByte(1)
      ..write(obj.exceptionsDays)
      ..writeByte(2)
      ..write(obj.plannedTimeBreaks)
      ..writeByte(3)
      ..write(obj.activeTimePeriod)
      ..writeByte(4)
      ..write(obj.breakDurationInSeconds)
      ..writeByte(5)
      ..write(obj.sessionDurationInSeconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
