import 'department.dart';
import 'position_class.dart';

class Office {
  Office({
    this.unit,
    this.section,
    this.division,
    this.posstatid,
    this.department,
    this.stationId,
    this.positionClass,
    this.positionSpecificrole,
  });

  Department? unit;
  Department? section;
  Department? division;
  int? posstatid;
  Department? department;
  int? stationId;
  PositionClass? positionClass;
  PositionSpecificrole? positionSpecificrole;

  factory Office.fromJson(Map<String, dynamic> json) => Office(
        unit: json["unit"]==null?null:Department.fromJson(json["unit"]),
        section: json["section"]==null?null:Department.fromJson(json["section"]),
        division: json["division"] ==null? null:Department.fromJson(json["division"]),
        posstatid: json["posstatid"],
        department: json["department"]==null?null:Department.fromJson(json["department"]),
        stationId: json["station_id"],
        positionClass: json["position_class"]==null?null:PositionClass.fromJson(json["position_class"]),
        positionSpecificrole:json["position_specificrole"]==null?null:
            PositionSpecificrole.fromJson(json["position_specificrole"]),
      );

  Map<String, dynamic> toJson() => {
        "unit": unit!.toJson(),
        "section": section!.toJson(),
        "division": division!.toJson(),
        "posstatid": posstatid,
        "department": department!.toJson(),
        "station_id": stationId,
        "position_class": positionClass!.toJson(),
        "position_specificrole": positionSpecificrole!.toJson(),
      };
}