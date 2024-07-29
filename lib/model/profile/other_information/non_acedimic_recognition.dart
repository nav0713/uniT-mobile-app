// To parse this JSON data, do
//
//     final nonAcademicRecognition = nonAcademicRecognitionFromJson(jsonString);

import 'dart:convert';

import 'package:unit2/model/utils/agency.dart';

NonAcademicRecognition nonAcademicRecognitionFromJson(String str) => NonAcademicRecognition.fromJson(json.decode(str));

String nonAcademicRecognitionToJson(NonAcademicRecognition data) => json.encode(data.toJson());

class NonAcademicRecognition {
    NonAcademicRecognition({
        this.id,
        this.title,
        this.presenter,
    });

    final int? id;
    final String? title;
    final Agency? presenter;

    factory NonAcademicRecognition.fromJson(Map<String, dynamic> json) => NonAcademicRecognition(
        id: json["id"],
        title: json["title"],
        presenter: json["presenter"] == null ? null : Agency.fromJson(json["presenter"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "presenter": presenter?.toJson(),
    };
}


