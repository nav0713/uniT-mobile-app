// To parse this JSON data, do
//
//     final permissionAssignment = permissionAssignmentFromJson(jsonString);

import 'package:unit2/model/rbac/permission.dart';
import 'dart:convert';

import 'package:unit2/model/rbac/rbac.dart';
import 'package:unit2/model/rbac/user.dart';

PermissionAssignment permissionAssignmentFromJson(String str) => PermissionAssignment.fromJson(json.decode(str));

String permissionAssignmentToJson(PermissionAssignment data) => json.encode(data.toJson());

class PermissionAssignment {
    final int? id;
    final RBAC? role;
    final RBACPermission? permission;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final User? createdBy;
    final User? updatedBy;

    PermissionAssignment({
        required this.id,
        required this.role,
        required this.permission,
        required this.createdAt,
        required this.updatedAt,
        required this.createdBy,
        required this.updatedBy,
    });

    factory PermissionAssignment.fromJson(Map<String, dynamic> json) => PermissionAssignment(
        id: json["id"],
        role: json["role"] == null? null: RBAC.fromJson(json["role"]),
        permission:json["permission"] == null?null: RBACPermission.fromJson(json["permission"]),
        createdAt: json['created_at'] == null?null: DateTime.parse(json["created_at"]),
        updatedAt:json['updated_at'] == null?null: DateTime.parse(json["updated_at"]),
        createdBy:json["created_by"] == null?null: User.fromJson(json["created_by"]),
        updatedBy: json["updated_by"] == null? null:User.fromJson(json["created_by"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "role": role?.toJson(),
        "permission": permission?.toJson(),
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

class Permission {
    final int id;
    final Role object;
    final Role operation;
    final DateTime createdAt;
    final dynamic updatedAt;
    final CreatedBy createdBy;
    final dynamic updatedBy;

    Permission({
        required this.id,
        required this.object,
        required this.operation,
        required this.createdAt,
        required this.updatedAt,
        required this.createdBy,
        required this.updatedBy,
    });

    factory Permission.fromJson(Map<String, dynamic> json) => Permission(
        id: json["id"],
        object: Role.fromJson(json["object"]),
        operation: Role.fromJson(json["operation"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        createdBy: CreatedBy.fromJson(json["created_by"]),
        updatedBy: json["updated_by"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "object": object.toJson(),
        "operation": operation.toJson(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt,
        "created_by": createdBy.toJson(),
        "updated_by": updatedBy,
    };
}

class Role {
    final int id;
    final String name;
    final String slug;
    final String shorthand;
    final DateTime createdAt;
    final dynamic updatedAt;
    final CreatedBy createdBy;
    final dynamic updatedBy;

    Role({
        required this.id,
        required this.name,
        required this.slug,
        required this.shorthand,
        required this.createdAt,
        required this.updatedAt,
        required this.createdBy,
        required this.updatedBy,
    });

    factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        shorthand: json["shorthand"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        createdBy: CreatedBy.fromJson(json["created_by"]),
        updatedBy: json["updated_by"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "shorthand": shorthand,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt,
        "created_by": createdBy.toJson(),
        "updated_by": updatedBy,
    };
}
