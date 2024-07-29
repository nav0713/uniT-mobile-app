
import '../../utils/category.dart';

class AgencyAssignedArea {
    final bool? isactive;
    final Area? area;

    AgencyAssignedArea({
        required this.isactive,
        required this.area,
    });

    factory AgencyAssignedArea.fromJson(Map<String, dynamic> json) => AgencyAssignedArea(
        isactive: json["isactive"],
        area: json["area"] == null? null:Area.fromJson(json["area"]),
    );

    Map<String, dynamic> toJson() => {
        "isactive": isactive,
        "area": area?.toJson(),
    };
}

class Area {
    final int? id;
    final String? name;
    final Category? category;
    final bool? privateEntity;
    final String? contactInfo;

    Area({
        required this.id,
        required this.name,
        required this.category,
        required this.privateEntity,
        required this.contactInfo,
    });

    factory Area.fromJson(Map<String, dynamic> json) => Area(
        id: json["id"],
        name: json["name"],
        category: json["category"]==null?null:Category.fromJson(json["category"]),
        privateEntity: json["private_entity"],
        contactInfo: json["contact_info"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "category": category?.toJson(),
        "private_entity": privateEntity,
        "contact_info": contactInfo,
    };
}


class IndustryClass {
    final int? id;
    final String? name;
    final String? description;

    IndustryClass({
        required this.id,
        required this.name,
        required this.description,
    });

    factory IndustryClass.fromJson(Map<String, dynamic> json) => IndustryClass(
        id: json["id"],
        name: json["name"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
    };
}
