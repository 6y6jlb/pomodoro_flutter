// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'processing.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProcessingAdapter extends TypeAdapter<Processing> {
  @override
  final int typeId = 3;

  @override
  Processing read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Processing(
      state: fields[0] as ProcessingState,
      settings: fields[1] as PomodoroSettings?,
      remainingTime: fields[2] as int,
      isTimerRunning: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Processing obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.state)
      ..writeByte(1)
      ..write(obj.settings)
      ..writeByte(2)
      ..write(obj.remainingTime)
      ..writeByte(3)
      ..write(obj.isTimerRunning);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProcessingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
