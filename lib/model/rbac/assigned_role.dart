// To parse this JSON data, do
//
//     final assignedRole = assignedRoleFromJson(jsonString);

import 'dart:convert';

import 'package:unit2/model/rbac/rbac.dart';

AssignedRole assignedRoleFromJson(String str) => AssignedRole.fromJson(json.decode(str));

String assignedRoleToJson(AssignedRole data) => json.encode(data.toJson());

class AssignedRole {
    final int? id;
    final RBAC? role;
    final CreatedBy? user;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final CreatedBy? createdBy;
    final CreatedBy? updatedBy;

    AssignedRole({
        required this.id,
        required this.role,
        required this.user,
        required this.createdAt,
        required this.updatedAt,
        required this.createdBy,
        required this.updatedBy,
    });

    factory AssignedRole.fromJson(Map<String, dynamic> json) => AssignedRole(
        id: json["id"],
        role: json['role'] == null?null: RBAC.fromJson(json["role"]),
        user: json['role'] == null?null: CreatedBy.fromJson(json["user"]),
        createdAt:json["created_at"] == null?null: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null?null: DateTime.parse(json["updated_at"]),
        createdBy: json["created_by"] == null? null: CreatedBy.fromJson(json["created_by"]),
        updatedBy: json["updated_by"] == null? null: CreatedBy.fromJson(json["updated_by"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "role": role?.toJson(),
        "user": user?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "created_by": createdBy?.toJson(),
        "updated_by": updatedBy?.toJson(),
    };
}


