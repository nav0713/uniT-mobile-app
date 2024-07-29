// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offlane_modules.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OfflineModulesAdapter extends TypeAdapter<OfflineModules> {
  @override
  final int typeId = 4;

  @override
  OfflineModules read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OfflineModules(
      moduleName: fields[1] as String,
      object: fields[2] as ModuleObject,
      roleName: fields[0] as String,
      roleId: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, OfflineModules obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.roleName)
      ..writeByte(1)
      ..write(obj.moduleName)
      ..writeByte(2)
      ..write(obj.object)
      ..writeByte(3)
      ..write(obj.roleId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflineModulesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
