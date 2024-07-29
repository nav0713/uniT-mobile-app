// To parse this JSON data, do
//
//     final voluntaryWork = voluntaryWorkFromJson(jsonString);

import 'dart:convert';

import '../location/address_category.dart';
import '../location/city.dart';
import '../location/country.dart';
import '../utils/agency.dart';
import '../utils/position.dart';

VoluntaryWork voluntaryWorkFromJson(String str) => VoluntaryWork.fromJson(json.decode(str));

String voluntaryWorkToJson(VoluntaryWork data) => json.encode(data.toJson());

class VoluntaryWork {
    VoluntaryWork({
        this.agency,
        this.address,
        this.toDate,
        this.position,
        this.fromDate,
        this.totalHours,
    });

    final Agency? agency;
    final Address? address;
    final DateTime? toDate;
    final PositionTitle? position;
    final DateTime? fromDate;
    final double? totalHours;

    factory VoluntaryWork.fromJson(Map<String, dynamic> json) => VoluntaryWork(
        agency: json["agency"] == null ? null : Agency.fromJson(json["agency"]),
        address: json["address"] == null ? null : Address.fromJson(json["address"]),
        toDate: json["to_date"] == null? null : DateTime.parse(json['to_date']),
        position: json["position"] == null ? null : PositionTitle.fromJson(json["position"]),
        fromDate: json["from_date"] == null ? null : DateTime.parse(json["from_date"]),
        totalHours: json["total_hours"],
    );

    Map<String, dynamic> toJson() => {
        "agency": agency?.toJson(),
        "address": address?.toJson(),
        "to_date": toDate,
        "position": position?.toJson(),
        "from_date": "${fromDate!.year.toString().padLeft(4, '0')}-${fromDate!.month.toString().padLeft(2, '0')}-${fromDate!.day.toString().padLeft(2, '0')}",
        "total_hours": totalHours,
    };
}

class Address {
    Address({
        this.id,
        this.addressClass,
        this.country,
        this.barangay,
        this.addressCategory,
        this.cityMunicipality,
    });

    final int? id;
    final dynamic addressClass;
    final Country? country;
    final dynamic barangay;
    final AddressCategory? addressCategory;
    final CityMunicipality? cityMunicipality;

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        addressClass: json["class"],
        country: json["country"] == null ? null : Country.fromJson(json["country"]),
        barangay: json["barangay"],
        addressCategory: json["address_category"] == null ? null : AddressCategory.fromJson(json["address_category"]),
        cityMunicipality: json["city_municipality"] == null ? null : CityMunicipality.fromJson(json["city_municipality"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "class": addressClass,
        "country": country?.toJson(),
        "barangay": barangay,
        "address_category": addressCategory?.toJson(),
        "city_municipality": cityMunicipality?.toJson(),
    };
}








