// To parse this JSON data, do
//
//     final primaryInformation = primaryInformationFromJson(jsonString);

import 'dart:convert';

import 'package:unit2/model/profile/family_backround.dart';


Profile primaryInformationFromJson(String str) => Profile.fromJson(json.decode(str));

String primaryInformationToJson(Profile data) => json.encode(data.toJson());

class Profile {
    int? webuserId;
     int? id;
     String? lastName;
     String? firstName;
     String? middleName;
     String? nameExtension;
     String? sex;
     DateTime? birthdate;
     String? civilStatus;
     String? bloodType;
     double? heightM;
     double? weightKg;
     String? photoPath;
     String? esigPath;
     MaidenName? maidenName;
     bool? deceased;
     String? uuidQrcode;
     String? titlePrefix;
     String? titleSuffix;
     bool? showTitleId;
     String? ethnicity;
     String? disability;
     String? gender;
     String? religion;
     String? ip;

    Profile({
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

    factory Profile.fromJson(Map<String, dynamic> json) => Profile(
      webuserId: null,
        id: json["id"],
        lastName: json["last_name"],
        firstName: json["first_name"],
        middleName: json["middle_name"]??='',
        nameExtension: json["name_extension"]??='',
        sex: json["sex"],
        birthdate:json['birthdate'] ==null?null: DateTime.parse(json["birthdate"]),
        civilStatus: json["civil_status"]==""?null:json["civil_status"],
        bloodType: json["blood_type"]==''?null: json["blood_type"],
        heightM: json["height_m"]?.toDouble(),
        weightKg: json["weight_kg"]?.toDouble(),
        photoPath: json["photo_path"],
        esigPath: json["esig_path"],
        maidenName: json["maiden_name"]==null?null:MaidenName.fromJson(json["maiden_name"]),
        deceased: json["deceased"],
        uuidQrcode: json["uuid_qrcode"],
        titlePrefix: json["title_prefix"] == ''?null:json["title_prefix"] ,
        titleSuffix: json["title_suffix"] == ''?null:json["title_suffix"],
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
     
    String get fullname => "$firstName $middleName $lastName ${nameExtension == 'NONE' || nameExtension == null || nameExtension == 'NA' || nameExtension == "N/A"?'':nameExtension}";
}
