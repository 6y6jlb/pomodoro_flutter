import 'package:hive/hive.dart';
import 'pomodoro_mode.dart';

class PomodoroModeAdapter extends TypeAdapter<PomodoroMode> {
  @override
  final int typeId = 4;

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
