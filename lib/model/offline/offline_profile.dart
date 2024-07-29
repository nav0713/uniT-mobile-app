import 'package:hive/hive.dart';

import 'dart:convert';

import 'package:unit2/model/profile/family_backround.dart';
part 'offline_profile.g.dart';
OfflineProfile primaryInformationFromJson(String str) => OfflineProfile.fromJson(json.decode(str));

String primaryInformationToJson(OfflineProfile data) => json.encode(data.toJson());
@HiveType(typeId: 0)
class OfflineProfile extends HiveObject {
   @HiveField(0)
    int? webuserId;
    @HiveField(1)
     int? id;
     @HiveField(2)
     String? lastName;
     @HiveField(3)
     String? firstName;
     @HiveField(4)
     String? middleName;
     @HiveField(5)
     String? nameExtension;
     @HiveField(6)
     String? sex;
     @HiveField(7)
     DateTime? birthdate;
     @HiveField(8)
     String? civilStatus;
     @HiveField(9)
     String? bloodType;
     @HiveField(10)
     double? heightM;
     @HiveField(11)
     double? weightKg;
     @HiveField(12)
     String? photoPath;
     @HiveField(13)
     String? esigPath;
     @HiveField(14)
     MaidenName? maidenName;
     @HiveField(15)
     bool? deceased;
     @HiveField(16)
     String? uuidQrcode;
     @HiveField(17)
     String? titlePrefix;
     @HiveField(18)
     String? titleSuffix;
     @HiveField(19)
     bool? showTitleId;
     @HiveField(20)
     String? ethnicity;
     @HiveField(21)
     String? disability;
     @HiveField(22)
     String? gender;
     @HiveField(23)
     String? religion;
     @HiveField(24)
     String? ip;

    OfflineProfile({
      required this.webuserId,
        required this.id,
        required this.lastName,
        required this.firstName,
        required this.middleName,
        required this.nameExtension,
        required this.sex,
        required this.birthdate,
        required this.civilStatus,
        required this.bloodType,
        required this.heightM,
        required this.weightKg,
        required this.photoPath,
        required this.esigPath,
        required this.maidenName,
        required this.deceased,
        required this.uuidQrcode,
        required this.titlePrefix,
        required this.titleSuffix,
        required this.showTitleId,
        required this.ethnicity,
        required this.disability,
        required this.gender,
        required this.religion,
        required this.ip,
    });

    factory OfflineProfile.fromJson(Map<String, dynamic> json) => OfflineProfile(
      webuserId: null,
        id: json["id"],
        lastName: json["last_name"],
        firstName: json["first_name"],
        middleName: json["middle_name"],
        nameExtension: json["name_extension"],
        sex: json["sex"],
        birthdate:json['birthdate'] ==null?null: DateTime.parse(json["birthdate"]),
        civilStatus: json["civil_status"],
        bloodType: json["blood_type"],
        heightM: json["height_m"]?.toDouble(),
        weightKg: json["weight_kg"]?.toDouble(),
        photoPath: json["photo_path"],
        esigPath: json["esig_path"],
        maidenName: json["maiden_name"]==null?null:MaidenName.fromJson(json["maiden_name"]),
        deceased: json["deceased"],
        uuidQrcode: json["uuid_qrcode"],
        titlePrefix: json["title_prefix"],
        titleSuffix: json["title_suffix"],
        showTitleId: json["show_title_id"],
        ethnicity: json["ethnicity"]== null?null:json["ethnicity"]['name'],
        disability: json["disability"] == null?null:json['disability']['name'],
        gender: json["gender"] == null?null:json['gender']['name'],
        religion: json["religion"] == null?null:json['religion']['name'],
        ip: json["ip"]==null?null:json['ip']['name'],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "last_name": lastName,
        "first_name": firstName,
        "middle_name": middleName,
        "name_extension": nameExtension,
        "sex": sex,
        "birthdate": "${birthdate?.year.toString().padLeft(4, '0')}-${birthdate?.month.toString().padLeft(2, '0')}-${birthdate?.day.toString().padLeft(2, '0')}",
        "civil_status": civilStatus,
        "blood_type": bloodType,
        "height_m": heightM,
        "weight_kg": weightKg,
        "photo_path": photoPath,
        "esig_path": esigPath,
        "maiden_name": maidenName,
        "deceased": deceased,
        "uuid_qrcode": uuidQrcode,
        "title_prefix": titlePrefix,
        "title_suffix": titleSuffix,
        "show_title_id": showTitleId,
        "ethnicity": ethnicity,
        "disability": disability,
        "gender": gender,
        "religion": religion,
        "ip": ip,
    };
}
