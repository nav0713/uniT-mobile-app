// To parse this JSON data, do
//
//     final rbac = rbacFromJson(jsonString);

import 'dart:convert';

RBAC rbacFromJson(String str) => RBAC.fromJson(json.decode(str));

String rbacToJson(RBAC data) => json.encode(data.toJson());

class RBAC {
     int? id;
    final String? name;
    final String? slug;
    final String? shorthand;
    final String? fontawesomeIcon;
    final DateTime? createdAt;
    final dynamic updatedAt;
    final CreatedBy? createdBy;
    final dynamic updatedBy;

    RBAC({
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

    factory RBAC.fromJson(Map<String, dynamic> json) => RBAC(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        shorthand: json["shorthand"],
        fontawesomeIcon: json["fontawesome_icon"],
        createdAt: json['created_at'] == null?null: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        createdBy: json['created_by']==null?null: CreatedBy.fromJson(json["created_by"]),
        updatedBy: json["updated_by"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "shorthand": shorthand,
        "fontawesome_icon": fontawesomeIcon,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt,
        "created_by": createdBy?.toJson(),
        "updated_by": updatedBy,
    };
}

class CreatedBy {
    final int id;
    final String username;
    final String firstName;
    final String lastName;
    final String email;
    final bool isActive;

    CreatedBy({
        required this.id,
        required this.username,
        required this.firstName,
        required this.lastName,
        required this.email,
        required this.isActive,
    });

    factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
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
