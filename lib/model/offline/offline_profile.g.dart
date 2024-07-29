// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OfflineProfileAdapter extends TypeAdapter<OfflineProfile> {
  @override
  final int typeId = 0;

  @override
  OfflineProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OfflineProfile(
      webuserId: fields[0] as int?,
      id: fields[1] as int?,
      lastName: fields[2] as String?,
      firstName: fields[3] as String?,
      middleName: fields[4] as String?,
      nameExtension: fields[5] as String?,
      sex: fields[6] as String?,
      birthdate: fields[7] as DateTime?,
      civilStatus: fields[8] as String?,
      bloodType: fields[9] as String?,
      heightM: fields[10] as double?,
      weightKg: fields[11] as double?,
      photoPath: fields[12] as String?,
      esigPath: fields[13] as String?,
      maidenName: fields[14] as MaidenName?,
      deceased: fields[15] as bool?,
      uuidQrcode: fields[16] as String?,
      titlePrefix: fields[17] as String?,
      titleSuffix: fields[18] as String?,
      showTitleId: fields[19] as bool?,
      ethnicity: fields[20] as String?,
      disability: fields[21] as String?,
      gender: fields[22] as String?,
      religion: fields[23] as String?,
      ip: fields[24] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OfflineProfile obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)
      ..write(obj.webuserId)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.firstName)
      ..writeByte(4)
      ..write(obj.middleName)
      ..writeByte(5)
      ..write(obj.nameExtension)
      ..writeByte(6)
      ..write(obj.sex)
      ..writeByte(7)
      ..write(obj.birthdate)
      ..writeByte(8)
      ..write(obj.civilStatus)
      ..writeByte(9)
      ..write(obj.bloodType)
      ..writeByte(10)
      ..write(obj.heightM)
      ..writeByte(11)
      ..write(obj.weightKg)
      ..writeByte(12)
      ..write(obj.photoPath)
      ..writeByte(13)
      ..write(obj.esigPath)
      ..writeByte(14)
      ..write(obj.maidenName)
      ..writeByte(15)
      ..write(obj.deceased)
      ..writeByte(16)
      ..write(obj.uuidQrcode)
      ..writeByte(17)
      ..write(obj.titlePrefix)
      ..writeByte(18)
      ..write(obj.titleSuffix)
      ..writeByte(19)
      ..write(obj.showTitleId)
      ..writeByte(20)
      ..write(obj.ethnicity)
      ..writeByte(21)
      ..write(obj.disability)
      ..writeByte(22)
      ..write(obj.gender)
      ..writeByte(23)
      ..write(obj.religion)
      ..writeByte(24)
      ..write(obj.ip);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflineProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
