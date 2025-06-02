import 'package:hive/hive.dart';
import 'package:pomodoro_flutter/utils/consts/hive_type_id.dart';
import 'pomodoro_mode.dart';

class PomodoroModeAdapter extends TypeAdapter<PomodoroMode> {
  @override
  final int typeId = HiveTypeId.pomodoroMode;

  @override
  PomodoroMode read(BinaryReader reader) {
    final value = reader.readInt(); 
    return PomodoroMode.values[value];
  }

  @override
  void write(BinaryWriter writer, PomodoroMode obj) {
    writer.writeInt(obj.index);
  }
}
