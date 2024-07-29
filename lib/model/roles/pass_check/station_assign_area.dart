// To parse this JSON data, do
//
//     final assignArea = assignAreaFromJson(jsonString);

import '../../rbac/rbac_station.dart';
import '../../rbac/station_type.dart';

class StationAssignArea {
    final bool? isactive;
    final Station? area;

    StationAssignArea({
        required this.isactive,
        required this.area,
    });

    factory StationAssignArea.fromJson(Map<String, dynamic> json) => StationAssignArea(
        isactive: json["isactive"],
        area: json["area"] == null?null: Station.fromJson(json["area"]),
    );

    Map<String, dynamic> toJson() => {
        "isactive": isactive,
        "area": area?.toJson(),
    };
}

class Station {
    final int? id;
    final String? stationName;
    final StationType? stationType;
    final int? hierarchyOrderNo;
    final String? headPosition;
    final GovernmentAgency? governmentAgency;
    final String? acronym;
    final int? parentStation;
    final String? code;
    final String? fullcode;
    final List<ChildStationInfo>? childStationInfo;
    final bool? islocationUnderParent;
    final int? mainParentStation;
    final String? description;
    final bool? ishospital;
    final bool? isactive;
    final bool? sellingStation;

    Station({
        required this.id,
        required this.stationName,
        required this.stationType,
        required this.hierarchyOrderNo,
        required this.headPosition,
        required this.governmentAgency,
        required this.acronym,
        required this.parentStation,
        required this.code,
        required this.fullcode,
        required this.childStationInfo,
        required this.islocationUnderParent,
        required this.mainParentStation,
        required this.description,
        required this.ishospital,
        required this.isactive,
        required this.sellingStation,
    });

    factory Station.fromJson(Map<String, dynamic> json) => Station(
        id: json["id"],
        stationName: json["station_name"],
        stationType:json["station_type"] ==null?null: StationType.fromJson(json["station_type"]),
        hierarchyOrderNo: json["hierarchy_order_no"],
        headPosition: json["head_position"],
        governmentAgency: json["government_agency"] == null?null:GovernmentAgency.fromJson(json["government_agency"]),
        acronym: json["acronym"],
        parentStation: json["parent_station"],
        code: json["code"],
        fullcode: json["fullcode"],
        childStationInfo: json['child_station_info']==null || json['child_station_info'].isEmpty ?[]:List<ChildStationInfo>.from(json["child_station_info"].map((x) => ChildStationInfo.fromJson(x))),
        islocationUnderParent: json["islocation_under_parent"],
        mainParentStation: json["main_parent_station"],
        description: json["description"],
        ishospital: json["ishospital"],
        isactive: json["isactive"],
        sellingStation: json["selling_station"],
    );

    Map<dynamic, dynamic> toJson() => {
        "id": id,
        "station_name": stationName,
        "station_type": stationType?.toJson(),
        "hierarchy_order_no": hierarchyOrderNo,
        "head_position": headPosition,
        "government_agency": governmentAgency?.toJson(),
        "acronym": acronym,
        "parent_station": parentStation,
        "code": code,
        "fullcode": fullcode,
        "child_station_info": List<dynamic>.from(childStationInfo!.map((x) => x.toJson())),
        "islocation_under_parent": islocationUnderParent,
        "main_parent_station": mainParentStation,
        "description": description,
        "ishospital": ishospital,
        "isactive": isactive,
        "selling_station": sellingStation,
    };
}

class ChildStationInfo {
    final int? id;
    final String? stationName;
    final String? acroym;
     bool? motherStation;

    ChildStationInfo({
        required this.id,
        required this.stationName,
        required this.acroym,
         this.motherStation
    });

    factory ChildStationInfo.fromJson(Map<String, dynamic> json) => ChildStationInfo(
        id: json["id"],
        stationName: json["station_name"],
        acroym: json["acroym"],
        
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "station_name": stationName,
        "acroym": acroym,
    };
}



