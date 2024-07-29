// To parse this JSON data, do
//
//     final eligibilities = eligibilitiesFromJson(jsonString);

import 'dart:convert';

Eligibility eligibilitiesFromJson(String str) => Eligibility.fromJson(json.decode(str));

String eligibilitiesToJson(Eligibility data) => json.encode(data.toJson());

class Eligibility {
    Eligibility({
        required this.id,
        required this.title,
        required this.type,
    });

    final int id;
    final String title;
    final String type;

    factory Eligibility.fromJson(Map<String, dynamic> json) => Eligibility(
        id: json["id"],
        title: json["title"],
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "type": type,
    };
    @override
  String toString() {
return title;

  }
}
