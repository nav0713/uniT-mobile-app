// To parse this JSON data, do
//
//     final familyBackground = familyBackgroundFromJson(jsonString);

import 'dart:convert';

import '../utils/category.dart';
import '../utils/position.dart';

FamilyBackground familyBackgroundFromJson(String str) =>
    FamilyBackground.fromJson(json.decode(str));

String familyBackgroundToJson(FamilyBackground data) =>
    json.encode(data.toJson());

class FamilyBackground {
  FamilyBackground({
    this.company,
    this.position,
    this.relationship,
    this.relatedPerson,
    this.companyAddress,
    this.emergencyContact,
    this.incaseOfEmergency,
    this.companyContactNumber,
  });

  final Company? company;
  final PositionTitle? position;
  final Relationship? relationship;
  final RelatedPerson? relatedPerson;
  final String? companyAddress;
  final List<EmergencyContact>? emergencyContact;
  final bool? incaseOfEmergency;
  final String? companyContactNumber;

  factory FamilyBackground.fromJson(Map<String, dynamic> json) =>
      FamilyBackground(
        company:
            json["company"] == null ? null : Company.fromJson(json["company"]),
        position: json["position"] == null
            ? null
            : PositionTitle.fromJson(json["position"]),
        relationship: json["relationship"] == null
            ? null
            : Relationship.fromJson(json["relationship"]),
        relatedPerson: json["related_person"] == null
            ? null
            : RelatedPerson.fromJson(json["related_person"]),
        companyAddress: json["company_address"],
        emergencyContact: json["emergency_contact"] == null
            ? []
            : List<EmergencyContact>.from(json["emergency_contact"]!
                .map((x) => EmergencyContact.fromJson(x))),
        incaseOfEmergency: json["incase_of_emergency"],
        companyContactNumber: json["company_contact_number"],
      );

  Map<String, dynamic> toJson() => {
        "company": company?.toJson(),
        "position": position?.toJson(),
        "relationship": relationship?.toJson(),
        "related_person": relatedPerson?.toJson(),
        "company_address": companyAddress,
        "emergency_contact": emergencyContact == null
            ? []
            : List<dynamic>.from(emergencyContact!.map((x) => x.toJson())),
        "incase_of_emergency": incaseOfEmergency,
        "company_contact_number": companyContactNumber,
      };
}

class Company {
  Company({
    this.id,
    this.name,
    this.category,
    this.privateEntity,
  });

  final int? id;
  final String? name;
  final Category? category;
  final bool? privateEntity;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"],
        name: json["name"],
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
        privateEntity: json["private_entity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "category": category?.toJson(),
        "private_entity": privateEntity,
      };
}

class EmergencyContact {
  EmergencyContact({
    this.telco,
    this.isactive,
    this.provider,
    this.isprimary,
    this.numbermail,
    this.serviceType,
    this.contactinfoid,
    this.commServiceId,
  });

  final String? telco;
  final bool? isactive;
  final int? provider;
  final bool? isprimary;
  final String? numbermail;
  final int? serviceType;
  final int? contactinfoid;
  final int? commServiceId;

  factory EmergencyContact.fromJson(Map<String, dynamic> json) =>
      EmergencyContact(
        telco: json["telco"],
        isactive: json["isactive"],
        provider: json["provider"],
        isprimary: json["isprimary"],
        numbermail: json["numbermail"],
        serviceType: json["service_type"],
        contactinfoid: json["contactinfoid"],
        commServiceId: json["comm_service_id"],
      );

  Map<String, dynamic> toJson() => {
        "telco": telco,
        "isactive": isactive,
        "provider": provider,
        "isprimary": isprimary,
        "numbermail": numbermail,
        "service_type": serviceType,
        "contactinfoid": contactinfoid,
        "comm_service_id": commServiceId,
      };
}

class RelatedPerson {
  RelatedPerson({
    required this.id,
    required this.gender,
    required this.sex,
    required this.deceased,
    required this.heightM,
    required this.birthdate,
    required this.esigPath,
    required this.lastName,
    required this.weightKg,
    required this.bloodType,
    required this.firstName,
    required this.photoPath,
    required this.maidenName,
    required this.middleName,
    required this.uuidQrcode,
    required this.civilStatus,
    required this.titlePrefix,
    required this.titleSuffix,
    required this.showTitleId,
    required this.nameExtension,
  });

  final int? id;
  final String? sex;
  final bool? deceased;
  final String? gender;
  final double? heightM;
  final DateTime? birthdate;
  final String? esigPath;
  final String? lastName;
  final double? weightKg;
  final String? bloodType;
  final String? firstName;
  final String? photoPath;
  final MaidenName? maidenName;
  final String? middleName;
  final String? uuidQrcode;
  final String? civilStatus;
  final String? titlePrefix;
  final String? titleSuffix;
  final bool? showTitleId;
  final String? nameExtension;

  factory RelatedPerson.fromJson(Map<String, dynamic> json) => RelatedPerson(
        id: json["id"],
        sex: json["sex"],
        gender: json["gender"],
        deceased: json["deceased"],
        heightM: json["height_m"] == null
            ? null
            : double.parse(json["height_m"].toString()),
        birthdate: json["birthdate"] == null
            ? null
            : DateTime.parse(json["birthdate"]),
        esigPath: json["esig_path"],
        lastName: json["last_name"],
        weightKg: json["weight_kg"] == null
            ? null
            : double.parse(json["weight_kg"].toString()),
        bloodType: json["blood_type"],
        firstName: json["first_name"],
        photoPath: json["photo_path"],
        maidenName: json["maiden_name"] == null
            ? null
            : MaidenName.fromJson(json['maiden_name']),
        middleName: json["middle_name"],
        uuidQrcode: json["uuid_qrcode"],
        civilStatus: json["civil_status"],
        titlePrefix: json["title_prefix"],
        titleSuffix: json["title_suffix"],
        showTitleId: json["show_title_id"],
        nameExtension: json["name_extension"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sex": sex,
        "gender": gender,
        "deceased": deceased,
        "height_m": heightM,
        "birthdate":
            "${birthdate!.year.toString().padLeft(4, '0')}-${birthdate!.month.toString().padLeft(2, '0')}-${birthdate!.day.toString().padLeft(2, '0')}",
        "esig_path": esigPath,
        "last_name": lastName,
        "weight_kg": weightKg,
        "blood_type": bloodType,
        "first_name": firstName,
        "photo_path": photoPath,
        "maiden_name": maidenName,
        "middle_name": middleName,
        "uuid_qrcode": uuidQrcode,
        "civil_status": civilStatus,
        "title_prefix": titlePrefix,
        "title_suffix": titleSuffix,
        "show_title_id": showTitleId,
        "name_extension": nameExtension,
      };
}

class Relationship {
  Relationship({
    this.id,
    this.type,
    this.category,
  });

  final int? id;
  final String? type;
  final String? category;

  factory Relationship.fromJson(Map<String, dynamic> json) => Relationship(
        id: json["id"],
        type: json["type"],
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "category": category,
      };
}

class MaidenName {
  final String? lastName;
  final String? middleName;

  MaidenName({
    required this.lastName,
    required this.middleName,
  });

  factory MaidenName.fromJson(Map<String, dynamic> json) => MaidenName(
        lastName: json["last_name"],
        middleName: json["middle_name"],
      );

  Map<String, dynamic> toJson() => {
        "last_name": lastName,
        "middle_name": middleName,
      };
}
