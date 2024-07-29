import 'package:unit2/model/utils/industry_class.dart';

class Category {
    Category({
        this.id,
        this.name,
        this.industryClass,
    });

    final int? id;
    final String? name;
    final IndustryClass? industryClass;

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        industryClass: json["industry_class"] == null ? null : IndustryClass.fromJson(json["industry_class"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "industry_class": industryClass?.toJson(),
    };
}