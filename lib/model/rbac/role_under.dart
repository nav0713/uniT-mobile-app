// To parse this JSON data, do
//
//     final rolesUnder = rolesUnderFromJson(jsonString);

import 'dart:convert';

import 'package:unit2/model/rbac/rbac.dart';

RolesUnder rolesUnderFromJson(String str) => RolesUnder.fromJson(json.decode(str));

String rolesUnderToJson(RolesUnder data) => json.encode(data.toJson());

class RolesUnder {
    final int id;
    final RBAC roleUnderMain;
    final RBAC roleUnderChild;

    RolesUnder({
        required this.id,
        required this.roleUnderMain,
        required this.roleUnderChild,
    });

    factory RolesUnder.fromJson(Map<String, dynamic> json) => RolesUnder(
        id: json["id"],
        roleUnderMain: RBAC.fromJson(json["role_under_main"]),
        roleUnderChild: RBAC.fromJson(json["role_under_child"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "role_under_main": roleUnderMain.toJson(),
        "role_under_child": roleUnderChild.toJson(),
    };
}

