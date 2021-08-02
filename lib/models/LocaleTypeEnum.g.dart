// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LocaleTypeEnum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocaleTypeAdapter extends TypeAdapter<LocaleType> {
  @override
  final int typeId = 1;

  @override
  LocaleType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LocaleType.ENGLISH;
      case 1:
        return LocaleType.HINDI;
      default:
        return LocaleType.ENGLISH;
    }
  }

  @override
  void write(BinaryWriter writer, LocaleType obj) {
    switch (obj) {
      case LocaleType.ENGLISH:
        writer.writeByte(0);
        break;
      case LocaleType.HINDI:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocaleTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
