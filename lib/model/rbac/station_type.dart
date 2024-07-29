// To parse this JSON data, do
//
//     final rbacStationType = rbacStationTypeFromJson(jsonString);


class StationType {
    final int? id;
    final String? typeName;
    final String? color;
    final int? order;
    final bool? isActive;
    final String? group;

    StationType({
        required this.id,
        required this.typeName,
        required this.color,
        required this.order,
        required this.isActive,
        required this.group,
    });

    factory StationType.fromJson(Map<String, dynamic> json) => StationType(
        id: json["id"],
        typeName: json["type_name"],
        color: json["color"],
        order: json["order"],
        isActive: json["is_active"],
        group: json["group"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "type_name": typeName,
        "color": color,
        "order": order,
        "is_active": isActive,
        "group": group,
    };
}
