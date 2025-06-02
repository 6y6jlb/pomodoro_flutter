import 'package:hive/hive.dart';
import 'package:pomodoro_flutter/enums/processing_state.dart';
import 'package:pomodoro_flutter/utils/consts/hive_type_id.dart';

class ProcessingStateAdapter extends TypeAdapter<ProcessingState> {
  @override
  final int typeId = HiveTypeId.processingState;

  @override
  ProcessingState read(BinaryReader reader) {
    final value = reader.readInt(); 
    return ProcessingState.values[value];
  }

  @override
  void write(BinaryWriter writer, ProcessingState obj) {
    writer.writeInt(obj.index);
  }
}
