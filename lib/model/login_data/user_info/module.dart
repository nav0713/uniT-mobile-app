import 'package:hive/hive.dart';
import 'package:unit2/model/login_data/user_info/module_object.dart';
part 'module.g.dart';
@HiveType(typeId: 1)
class Module extends HiveObject {
  Module({
    this.id,
    this.icon,
    this.name,
    this.slug,
    this.objects,
  });
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? icon;
  @HiveField(2)
  String? name;
  @HiveField(3)
  String? slug;
  @HiveField(4)
  List<ModuleObject?>? objects;

  factory Module.fromJson(Map<String, dynamic> json) => Module(
        id: json["id"],
        icon: json["icon"],
        name: json["name"],
        slug: json["slug"],
        objects: json["objects"] == null
            ? []
            : List<ModuleObject?>.from(
                json["objects"]!.map((x) => ModuleObject.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "icon": icon,
        "name": name,
        "slug": slug,
        "objects": objects == null
            ? []
            : List<dynamic>.from(objects!.map((x) => x!.toJson())),
      };
}

