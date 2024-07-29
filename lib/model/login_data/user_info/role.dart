import 'assigned_area.dart';
import 'module.dart';

class Role {
  Role({
    this.id,
    this.name,
    this.modules,
    this.assignedArea,
  });

  int? id;
  String? name;
  List<Module?>? modules;
  List<AssignedArea?>? assignedArea;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        name: json["name"],
        modules: json["modules"] == null
            ? []
            : List<Module?>.from(
                json["modules"]!.map((x) => Module.fromJson(x))),
        assignedArea: json["assigned_area"] == null
            ? []
            : json["assigned_area"] == null
                ? []
                : List<AssignedArea?>.from(json["assigned_area"]!
                    .map((x) => AssignedArea.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "modules": modules == null
            ? []
            : List<dynamic>.from(modules!.map((x) => x!.toJson())),
        "assigned_area": assignedArea == null
            ? []
            : assignedArea == null
                ? []
                : List<dynamic>.from(assignedArea!.map((x) => x!.toJson())),
      };
}