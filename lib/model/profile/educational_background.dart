// To parse this JSON data, do
//
//     final educationalBackground = educationalBackgroundFromJson(jsonString);

import 'dart:convert';

import 'package:unit2/model/profile/attachment.dart';

EducationalBackground educationalBackgroundFromJson(String str) => EducationalBackground.fromJson(json.decode(str));

String educationalBackgroundToJson(EducationalBackground data) => json.encode(data.toJson());

class EducationalBackground {
    EducationalBackground({
        this.id,
        this.honors,
        this.education,
        this.periodTo,
        this.attachments,
        this.periodFrom,
        this.unitsEarned,
        this.yearGraduated,
    });

    final int? id;
    final List<Honor>? honors;
    final Education? education;
    final String? periodTo;
      List<Attachment>? attachments;
    final String? periodFrom;
    final int? unitsEarned;
    final String? yearGraduated;

    factory EducationalBackground.fromJson(Map<String, dynamic> json) => EducationalBackground(
        id: json["id"],
        honors: json["honors"] == null ? [] : List<Honor>.from(json["honors"]!.map((x) => Honor.fromJson(x))),
        education: json["education"] == null ? null : Education.fromJson(json["education"]),
        periodTo: json["period_to"],
        attachments: json['attachments'] ==null?null:  List<Attachment>.from(json["attachments"].map((x) => Attachment.fromJson(x))),
        periodFrom: json["period_from"],
        unitsEarned: json["units_earned"],
        yearGraduated: json["year_graduated"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "honors": honors == null ? [] : List<dynamic>.from(honors!.map((x) => x.toJson())),
        "education": education?.toJson(),
        "period_to": periodTo,
        "attachments": attachments,
        "period_from": periodFrom,
        "units_earned": unitsEarned,
        "year_graduated": yearGraduated,
    };
}

class Education {
    Education({
        this.id,
        this.level,
        this.course,
        this.school,
    });

    final int? id;
    final String? level;
    final Course? course;
    final School? school;

    factory Education.fromJson(Map<String, dynamic> json) => Education(
        id: json["id"],
        level: json["level"],
        course: json["course"] == null ? null : Course.fromJson(json["course"]),
        school: json["school"] == null ? null : School.fromJson(json["school"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "level": level,
        "course": course?.toJson(),
        "school": school?.toJson(),
    };
}

class Course {
    Course({
        this.id,
        this.program,
    });

    final int? id;
    final String? program;

    factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json["id"],
        program: json["program"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "program": program,
    };
}

class School {
    School({
        this.id,
        this.name,
    });

    final int? id;
    final String? name;

    factory School.fromJson(Map<String, dynamic> json) => School(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}

class Honor {
    Honor({
        this.id,
        this.name,
        this.academ,
    });

    final int? id;
    final String? name;
    final bool? academ;

    factory Honor.fromJson(Map<String, dynamic> json) => Honor(
        id: json["id"],
        name: json["name"],
        academ: json["academ"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "academ": academ,
    };
}
