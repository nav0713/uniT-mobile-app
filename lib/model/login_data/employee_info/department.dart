import 'package:unit2/model/login_data/employee_info/head.dart';

class Department {
  Department({
    this.id,
    this.code,
    this.head,
    this.name,
    this.acronym,
    this.parentStationId,
    this.fullCode,
  });

  int? id;
  String? code;
  Head? head;
  String? name;
  int? acronym;
  int? parentStationId;
  String? fullCode;

  factory Department.fromJson(Map<String, dynamic> json) => Department(
        id: json["id"],
        code: json["code"],
        head:json["head"]==null?null:Head.fromJson(json["head"]),
        name: json["name"],
        acronym: json["acronym"],
        parentStationId: json["parent_station_id"],
        fullCode: json["full_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "head": head,
        "name": name,
        "acronym": acronym,
        "parent_station_id": parentStationId,
        "full_code": fullCode,
      };
}