// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_period.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimePeriodAdapter extends TypeAdapter<TimePeriod> {
  @override
  final int typeId = 0;

  @override
  TimePeriod read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimePeriod(
      start: fields[0] as TimeOfDay,
      end: fields[1] as TimeOfDay,
    );
  }

  @override
  void write(BinaryWriter writer, TimePeriod obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.start)
      ..writeByte(1)
      ..write(obj.end);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimePeriodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
