import 'package:hive/hive.dart';
part 'module_object.g.dart';
@HiveType(typeId: 2)
class ModuleObject extends HiveObject {
  ModuleObject({
    this.id,
    this.name,
    this.slug,
    this.operations,
  });
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? slug;
  @HiveField(3)
  List<String?>? operations;

  factory ModuleObject.fromJson(Map<String, dynamic> json) => ModuleObject(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        operations: json["operations"] == null
            ? []
            : List<String?>.from(json["operations"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "operations": operations == null
            ? []
            : List<dynamic>.from(operations!.map((x) => x)),
      };
}
