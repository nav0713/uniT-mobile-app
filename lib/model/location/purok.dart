// To parse this JSON data, do
//
//     final purok = purokFromJson(jsonString);

import 'dart:convert';

import 'package:unit2/model/location/barangay.dart';

Purok purokFromJson(String str) => Purok.fromJson(json.decode(str));

String purokToJson(Purok data) => json.encode(data.toJson());

class Purok {
    final String code;
    final String description;
    final Barangay barangay;

    Purok({
        required this.code,
        required this.description,
        required this.barangay,
    });

    factory Purok.fromJson(Map<String, dynamic> json) => Purok(
        code: json["code"],
        description: json["description"],
        barangay: Barangay.fromJson(json["barangay"]),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "description": description,
        "barangay": barangay.toJson(),
    };
}
