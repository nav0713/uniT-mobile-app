// To parse this JSON data, do
//
//     final barangay = barangayFromJson(jsonString);

import 'dart:convert';

import 'city.dart';

Barangay barangayFromJson(String str) => Barangay.fromJson(json.decode(str));

String barangayToJson(Barangay data) => json.encode(data.toJson());

class Barangay {
    Barangay({
        required this.code,
        required this.description,
        required this.cityMunicipality,
    });

    final String? code;
    final String? description;
    final CityMunicipality? cityMunicipality;

    factory Barangay.fromJson(Map<String, dynamic> json) => Barangay(
        code: json["code"],
        description: json["description"],
        cityMunicipality: json['city_municipality'] == null? null: CityMunicipality.fromJson(json["city_municipality"]),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "description": description,
        "city_municipality": cityMunicipality!.toJson(),
    };
}




