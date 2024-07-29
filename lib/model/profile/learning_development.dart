// To parse this JSON data, do
//
//     final learningDevelopement = learningDevelopementFromJson(jsonString);

import 'dart:convert';

import 'package:unit2/model/location/barangay.dart';

import '../location/city.dart';
import '../location/country.dart';
import '../utils/agency.dart';
import 'attachment.dart';

LearningDevelopement learningDevelopementFromJson(String str) => LearningDevelopement.fromJson(json.decode(str));

String learningDevelopementToJson(LearningDevelopement data) => json.encode(data.toJson());

class LearningDevelopement {
    LearningDevelopement({
        this.attachments,
        this.sponsoredBy,
        this.conductedTraining,
        this.totalHoursAttended,
    });

      List<Attachment>? attachments;
    final Agency? sponsoredBy;
    final ConductedTraining? conductedTraining;
    final double? totalHoursAttended;

    factory LearningDevelopement.fromJson(Map<String, dynamic> json) => LearningDevelopement(
        attachments:  json['attachments'] ==null?null:  List<Attachment>.from(json["attachments"].map((x) => Attachment.fromJson(x))),
        sponsoredBy: json["sponsored_by"] == null ? null : Agency.fromJson(json["sponsored_by"]),
        conductedTraining: json["conducted_training"] == null ? null : ConductedTraining.fromJson(json["conducted_training"]),
        totalHoursAttended: json["total_hours_attended"],
    );

    Map<String, dynamic> toJson() => {
        "attachments": attachments,
        "sponsored_by": sponsoredBy?.toJson(),
        "conducted_training": conductedTraining?.toJson(),
        "total_hours_attended": totalHoursAttended,
    };
}

class ConductedTraining {
    ConductedTraining({
        this.id,
        this.title,
        this.topic,
        this.venue,
        this.locked,
        this.toDate,
        this.fromDate,
        this.totalHours,
        this.conductedBy,
        this.sessionsAttended,
        this.learningDevelopmentType,
    });

    final int? id;
    final LearningDevelopmentType? title;
    final LearningDevelopmentType? topic;
    final Venue? venue;
    final bool? locked;
    final DateTime? toDate;
    final DateTime? fromDate;
    final double? totalHours;
    final Agency? conductedBy;
    final List<dynamic>? sessionsAttended;
    final LearningDevelopmentType? learningDevelopmentType;

    factory ConductedTraining.fromJson(Map<String, dynamic> json) => ConductedTraining(
        id: json["id"],
        title: json["title"] == null ? null : LearningDevelopmentType.fromJson(json["title"]),
        topic: json["topic"] == null ? null : LearningDevelopmentType.fromJson(json["topic"]),
        venue: json["venue"] == null ? null : Venue.fromJson(json["venue"]),
        locked: json["locked"],
        toDate: json["to_date"] == null ? null : DateTime.parse(json["to_date"]),
        fromDate: json["from_date"] == null ? null : DateTime.parse(json["from_date"]),
        totalHours: double.parse(json["total_hours"].toString()),
        conductedBy: json["conducted_by"] == null ? null : Agency.fromJson(json["conducted_by"]),
        sessionsAttended: json["sessions_attended"] == null ? [] : List<dynamic>.from(json["sessions_attended"]!.map((x) => x)),
        learningDevelopmentType: json["learning_development_type"] == null ? null : LearningDevelopmentType.fromJson(json["learning_development_type"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title?.toJson(),
        "topic": topic?.toJson(),
        "venue": venue?.toJson(),
        "locked": locked,
        "to_date": "${toDate!.year.toString().padLeft(4, '0')}-${toDate!.month.toString().padLeft(2, '0')}-${toDate!.day.toString().padLeft(2, '0')}",
        "from_date": "${fromDate!.year.toString().padLeft(4, '0')}-${fromDate!.month.toString().padLeft(2, '0')}-${fromDate!.day.toString().padLeft(2, '0')}",
        "total_hours": totalHours,
        "conducted_by": conductedBy?.toJson(),
        "sessions_attended": sessionsAttended == null ? [] : List<dynamic>.from(sessionsAttended!.map((x) => x)),
        "learning_development_type": learningDevelopmentType?.toJson(),
    };
}


class LearningDevelopmentType {
    LearningDevelopmentType({
        this.id,
        this.title,
    });

    final int? id;
    final String? title;

    factory LearningDevelopmentType.fromJson(Map<String, dynamic> json) => LearningDevelopmentType(
        id: json["id"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
    };
}

class Venue {
    Venue({
        this.id,
        this.country,
        this.barangay,
        this.category,
        this.areaClass,
        this.cityMunicipality,
    });

    final int? id;
    final Country? country;
    final Barangay? barangay;
    final VenueCategory? category;
    final dynamic areaClass;
    final CityMunicipality? cityMunicipality;

    factory Venue.fromJson(Map<String, dynamic> json) => Venue(
        id: json["id"],
        country: json["country"] == null ? null : Country.fromJson(json["country"]),
        barangay:json["barangay"] == null ? null : Barangay.fromJson(json["barangay"]),
        category: json["category"] == null ? null : VenueCategory.fromJson(json["category"]),
        areaClass: json["area_class"],
        cityMunicipality: json["city_municipality"] == null ? null : CityMunicipality.fromJson(json["city_municipality"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "country": country?.toJson(),
        "barangay": barangay,
        "category": category?.toJson(),
        "area_class": areaClass,
        "city_municipality": cityMunicipality?.toJson(),
    };
}

class VenueCategory {
    VenueCategory({
        this.id,
        this.name,
        this.type,
    });

    final int? id;
    final String? name;
    final String? type;

    factory VenueCategory.fromJson(Map<String, dynamic> json) => VenueCategory(
        id: json["id"],
        name: json["name"],
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
    };
}

