import 'package:unit2/model/utils/category.dart';

class Agency {
    Agency({
        this.id,
        this.name,
        this.category,
        this.privateEntity,
    });

    final int? id;
    final String? name;
    final Category? category;
    final bool? privateEntity;

    factory Agency.fromJson(Map<String, dynamic> json) => Agency(
        id: json["id"],
        name: json["name"],
        category: json["category"] == null ? null : Category.fromJson(json["category"]),
        privateEntity: json["private_entity"],
    );
    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "category": category?.toJson(),
        "private_entity": privateEntity,
    };
}