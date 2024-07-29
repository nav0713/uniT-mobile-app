// To parse this JSON data, do
//
//     final rolesExtend = rolesExtendFromJson(jsonString);

import 'dart:convert';

import 'package:unit2/model/rbac/rbac.dart';

RolesExtend rolesExtendFromJson(String str) => RolesExtend.fromJson(json.decode(str));

String rolesExtendToJson(RolesExtend data) => json.encode(data.toJson());

class RolesExtend {
    final int id;
    final RBAC roleExtendMain;
    final RBAC roleExtendChild;

    RolesExtend({
        required this.id,
        required this.roleExtendMain,
        required this.roleExtendChild,
    });

    factory RolesExtend.fromJson(Map<String, dynamic> json) => RolesExtend(
        id: json["id"],
        roleExtendMain: RBAC.fromJson(json["role_extend_main"]),
        roleExtendChild: RBAC.fromJson(json["role_extend_child"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "role_extend_main": roleExtendMain.toJson(),
        "role_extend_child": roleExtendChild.toJson(),
    };
}

