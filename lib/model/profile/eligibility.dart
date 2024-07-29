// To parse this JSON data, do
//
//     final eligibity = eligibityFromJson(jsonString);

import 'dart:convert';

import 'package:unit2/model/profile/attachment.dart';

import '../location/address_category.dart';
import '../location/city.dart';
import '../location/country.dart';
import '../utils/eligibility.dart';

EligibityCert eligibityFromJson(String str) =>
    EligibityCert.fromJson(json.decode(str));

String eligibityToJson(EligibityCert data) => json.encode(data.toJson());

class EligibityCert {
  EligibityCert({
    required this.id,
    required this.rating,
    required this.examDate,
    required this.attachments,
    required this.eligibility,
    required this.examAddress,
    required this.validityDate,
    required this.licenseNumber,
    required this.overseas,
  });
  bool? overseas;
  final int? id;
  final double? rating;
  final DateTime? examDate;
   List<Attachment>? attachments;

  final Eligibility? eligibility;
  final ExamAddress? examAddress;
  final DateTime? validityDate;
  final String? licenseNumber;

  factory EligibityCert.fromJson(Map<String, dynamic> json) => EligibityCert(
        id: json["id"],
        rating: json["rating"]?.toDouble(),
        examDate: json['exam_date'] == null
            ? null
            : DateTime.parse(json["exam_date"]),
        attachments:  json['attachments'] ==null?null:  List<Attachment>.from(json["attachments"].map((x) => Attachment.fromJson(x))),
        eligibility: json['eligibility'] == null
            ? null
            : Eligibility.fromJson(json["eligibility"]),
        examAddress: json['exam_address'] == null
            ? null
            : ExamAddress.fromJson(json["exam_address"]),
        validityDate:  json['validity_date'] == null
            ? null
            : DateTime.parse(json["validity_date"]),
        licenseNumber: json["license_number"],
        overseas: null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "rating": rating,
        "exam_date":
            "${examDate!.year.toString().padLeft(4, '0')}-${examDate!.month.toString().padLeft(2, '0')}-${examDate!.day.toString().padLeft(2, '0')}",
        "attachments": attachments,
        "eligibility": eligibility!.toJson(),
        "exam_address": examAddress!.toJson(),
        "validity_date":  "${validityDate!.year.toString().padLeft(4, '0')}-${validityDate!.month.toString().padLeft(2, '0')}-${validityDate!.day.toString().padLeft(2, '0')}",
        "license_number": licenseNumber,
      };
  @override
  String toString() {
    return 'eligibility:${eligibility.toString()}, rating:$rating, examDate:${examDate.toString()},validydate:${validityDate.toString()}, lisence:$licenseNumber, examAddress:${examAddress.toString()}';
  }
}

class ExamAddress {
  ExamAddress({
    required this.id,
    required this.examAddressClass,
    required this.country,
    required this.barangay,
    required this.addressCategory,
    required this.cityMunicipality,
  });

  final int? id;
  final dynamic examAddressClass;
  final Country? country;
  final dynamic barangay;
  final AddressCategory? addressCategory;
  final CityMunicipality? cityMunicipality;

  factory ExamAddress.fromJson(Map<String, dynamic> json) => ExamAddress(
        id: json["id"],
        examAddressClass: json["class"],
        country:
            json["country"] == null ? null : Country.fromJson(json["country"]),
        barangay: json["barangay"],
        addressCategory: json["address_category"] == null
            ? null
            : AddressCategory.fromJson(json["address_category"]),
        cityMunicipality: json["city_municipality"] == null
            ? null
            : CityMunicipality.fromJson(json["city_municipality"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "class": examAddressClass,
        "country": country!.toJson(),
        "barangay": barangay,
        "address_category": addressCategory!.toJson(),
        "city_municipality": cityMunicipality!.toJson(),
      };

  @override
  String toString() {
    return 'country:${country.toString()} , address:${cityMunicipality.toString()}';
  }
}
