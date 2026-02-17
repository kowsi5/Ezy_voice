// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HistoryItemAdapter extends TypeAdapter<HistoryItem> {
  @override
  final int typeId = 1;

  @override
  HistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoryItem(
      inputText: fields[0] as String,
      englishInput: fields[1] as String,
      resultEnglish: fields[2] as String,
      resultLocal: fields[3] as String,
      lang: fields[4] as String,
      timestamp: fields[5] as String,
      synced: fields[6] == null ? false : fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HistoryItem obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.inputText)
      ..writeByte(1)
      ..write(obj.englishInput)
      ..writeByte(2)
      ..write(obj.resultEnglish)
      ..writeByte(3)
      ..write(obj.resultLocal)
      ..writeByte(4)
      ..write(obj.lang)
      ..writeByte(5)
      ..write(obj.timestamp)
      ..writeByte(6)
      ..write(obj.synced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
