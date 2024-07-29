class AssignedArea {
  AssignedArea({
    this.id,
    this.areaid,
    this.isactive,
    this.areaName,
    this.areaTypeName,
  });

  int? id;
  String? areaid;
  bool? isactive;
  String? areaName;
  String? areaTypeName;

  factory AssignedArea.fromJson(Map<String, dynamic> json) => AssignedArea(
        id: json["id"],
        areaid: json["areaid"],
        isactive: json["isactive"],
        areaName: json["area_name"],
        areaTypeName: json["area_type_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "areaid": areaid,
        "isactive": isactive,
        "area_name": areaName,
        "area_type_name": areaTypeName,
      };
}