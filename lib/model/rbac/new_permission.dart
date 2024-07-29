// To parse this JSON data, do
//
//     final newPermission = newPermissionFromJson(jsonString);

import 'dart:convert';

NewPermission newPermissionFromJson(String str) => NewPermission.fromJson(json.decode(str));

String newPermissionToJson(NewPermission data) => json.encode(data.toJson());

class NewPermission {
    final int? newPermissionObjectId;
    final String? newObjectName;
    final String? newObjectSlug;
    final String? newObjectShorthand;
    final List<int> newPermissionOperationIds;
    final List<NewOperation> newOperations;

    NewPermission({
        required this.newPermissionObjectId,
        required this.newObjectName,
        required this.newObjectSlug,
        required this.newObjectShorthand,
        required this.newPermissionOperationIds,
        required this.newOperations,
    });

    factory NewPermission.fromJson(Map<String, dynamic> json) => NewPermission(
        newPermissionObjectId: json["_new_permission_object_id"],
        newObjectName: json["_new_object_name"],
        newObjectSlug: json["_new_object_slug"],
        newObjectShorthand: json["_new_object_shorthand"],
        newPermissionOperationIds: List<int>.from(json["_new_permission_operation_ids"].map((x) => x)),
        newOperations: List<NewOperation>.from(json["_new_operations"].map((x) => NewOperation.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "_new_permission_object_id": newPermissionObjectId,
        "_new_object_name": newObjectName,
        "_new_object_slug": newObjectSlug,
        "_new_object_shorthand": newObjectShorthand,
        "_new_permission_operation_ids": List<dynamic>.from(newPermissionOperationIds.map((x) => x)),
        "_new_operations": List<dynamic>.from(newOperations.map((x) => x.toJson())),
    };
}

class NewOperation {
    final String newOperationName;
    final String newOperationSlug;
    final String newOperationShorthand;

    NewOperation({
        required this.newOperationName,
        required this.newOperationSlug,
        required this.newOperationShorthand,
    });

    factory NewOperation.fromJson(Map<String, dynamic> json) => NewOperation(
        newOperationName: json["_new_operation_name"],
        newOperationSlug: json["_new_operation_slug"],
        newOperationShorthand: json["_new_operation_shorthand"],
    );

    Map<String, dynamic> toJson() => {
        "_new_operation_name": newOperationName,
        "_new_operation_slug": newOperationSlug,
        "_new_operation_shorthand": newOperationShorthand,
    };
}
