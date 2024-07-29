// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module_object.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModuleObjectAdapter extends TypeAdapter<ModuleObject> {
  @override
  final int typeId = 2;

  @override
  ModuleObject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModuleObject(
      id: fields[0] as int?,
      name: fields[1] as String?,
      slug: fields[2] as String?,
      operations: (fields[3] as List?)?.cast<String?>(),
    );
  }

  @override
  void write(BinaryWriter writer, ModuleObject obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.slug)
      ..writeByte(3)
      ..write(obj.operations);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModuleObjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
