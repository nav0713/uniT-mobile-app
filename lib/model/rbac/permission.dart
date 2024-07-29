import 'package:unit2/model/rbac/rbac.dart';

class RBACPermission {
    final int? id;
    final RBAC? object;
    final RBAC? operation;
    final DateTime? createdAt;
    final dynamic updatedAt;
    final CreatedBy? createdBy;
    final dynamic updatedBy;

    RBACPermission({
        required this.id,
        required this.object,
        required this.operation,
        required this.createdAt,
        required this.updatedAt,
        required this.createdBy,
        required this.updatedBy,
    });

    factory RBACPermission.fromJson(Map<String, dynamic> json) => RBACPermission(
        id: json["id"],
        object: json['object'] == null?null:RBAC.fromJson(json["object"]),
        operation: json['operation'] == null?null:  RBAC.fromJson(json["operation"]),
        createdAt:  DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        createdBy: CreatedBy.fromJson(json["created_by"]),
        updatedBy: json["updated_by"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "object": object?.toJson(),
        "operation": operation?.toJson(),
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


