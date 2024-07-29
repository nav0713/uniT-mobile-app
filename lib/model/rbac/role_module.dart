
class RoleModules {
    final int? id;
    final Module? role;
    final Module? module;
    final DateTime? createdAt;
    final dynamic updatedAt;
    final AtedBy? createdBy;
    final dynamic updatedBy;

    RoleModules({
        required this.id,
        required this.role,
        required this.module,
        required this.createdAt,
        required this.updatedAt,
        required this.createdBy,
        required this.updatedBy,
    });

    factory RoleModules.fromJson(Map<String, dynamic> json) => RoleModules(
        id: json["id"],
        role:json['role'] == null?null: Module.fromJson(json["role"]),
        module: json['module'] == null?null:Module.fromJson(json["module"]),
        createdAt: json["created_at"] == null? null: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        createdBy: json["created_by"]==null? null: AtedBy.fromJson(json["created_by"]),
        updatedBy: json["updated_by"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "role": role?.toJson(),
        "module": module?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt,
        "created_by": createdBy?.toJson(),
        "updated_by": updatedBy,
    };
}

class AtedBy {
    final int id;
    final String username;
    final String firstName;
    final String lastName;
    final String email;
    final bool isActive;

    AtedBy({
        required this.id,
        required this.username,
        required this.firstName,
        required this.lastName,
        required this.email,
        required this.isActive,
    });

    factory AtedBy.fromJson(Map<String, dynamic> json) => AtedBy(
        id: json["id"],
        username: json["username"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        isActive: json["is_active"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "is_active": isActive,
    };
}

class Module {
    final int? id;
    final String? name;
    final String? slug;
    final String? shorthand;
    final String? fontawesomeIcon;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final AtedBy? createdBy;
    final AtedBy? updatedBy;

    Module({
        required this.id,
        required this.name,
        required this.slug,
        required this.shorthand,
        required this.fontawesomeIcon,
        required this.createdAt,
        required this.updatedAt,
        required this.createdBy,
        required this.updatedBy,
    });

    factory Module.fromJson(Map<String, dynamic> json) => Module(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        shorthand: json["shorthand"],
        fontawesomeIcon: null,
        createdAt:json['created_at'] == null?null: DateTime.parse(json["created_at"]),
        updatedAt:json["updated_at"] == null?null: DateTime.parse(json["updated_at"]),
        createdBy:json["created_by"] ==null?null: AtedBy.fromJson(json["created_by"]),
        updatedBy:json["updated_by"] == null?null: AtedBy.fromJson(json["updated_by"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "shorthand": shorthand,
        "fontawesome_icon": fontawesomeIcon,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "created_by": createdBy?.toJson(),
        "updated_by": updatedBy?.toJson(),
    };
}
