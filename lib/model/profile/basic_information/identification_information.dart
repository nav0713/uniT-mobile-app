import 'dart:convert';

import '../../location/city.dart';
import '../../location/country.dart';
import '../../utils/agency.dart';

Identification identificationFromJson(String str) => Identification.fromJson(json.decode(str));

String identificationToJson(Identification data) => json.encode(data.toJson());

class Identification {
    Identification({
        required this.id,
        required this.agency,
        required this.issuedAt,
        this.dateIssued,
        this.expirationDate,
        required this.asPdfReference,
        required this.identificationNumber,
    });

    int? id;
    Agency? agency;
    IssuedAt? issuedAt;
    DateTime? dateIssued;
    DateTime? expirationDate;
    bool? asPdfReference;
    String? identificationNumber;

    factory Identification.fromJson(Map<String, dynamic> json) => Identification(
        id: json["id"],
        agency:json["agency"] == null? null: Agency.fromJson(json["agency"]),
        issuedAt: json["issued_at"] == null? null:IssuedAt.fromJson(json["issued_at"]),
        dateIssued:json["date_issued"]==null?null:DateTime.parse(json["date_issued"]),
        expirationDate:json["expiration_date"]==null?null:DateTime.parse(json["expiration_date"]),
        asPdfReference: json["as_pdf_reference"],
        identificationNumber: json["identification_number"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "agency": agency!.toJson(),
        "issued_at": issuedAt!.toJson(),
        "date_issued": dateIssued,
        "expiration_date": expirationDate,
        "as_pdf_reference": asPdfReference,
        "identification_number": identificationNumber,
    };
}


class IssuedAt {
    IssuedAt({
        required this.id,
        this.issuedAtClass,
        required this.country,
        this.barangay,
        required this.addressCategory,
        required this.cityMunicipality,
    });

    int? id;
    dynamic issuedAtClass;
    Country? country;
    dynamic barangay;
    AddressCategory? addressCategory;
    CityMunicipality? cityMunicipality;

    factory IssuedAt.fromJson(Map<String, dynamic> json) => IssuedAt(
        id: json["id"],
        issuedAtClass: json["class"],
        country: json['country'] == null? null: Country.fromJson(json["country"]),
        barangay: json["barangay"],
        addressCategory: json["address_category"] == null? null: AddressCategory.fromJson(json["address_category"]),
        cityMunicipality:json["city_municipality"] == null? null: CityMunicipality.fromJson(json["city_municipality"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "class": issuedAtClass,
        "country": country!.toJson(),
        "barangay": barangay,
        "address_category": addressCategory!.toJson(),
        "city_municipality": cityMunicipality!.toJson(),
    };
}

class AddressCategory {
    AddressCategory({
        required this.id,
        required this.name,
        required this.type,
    });

    int? id;
    String? name;
    String? type;

    factory AddressCategory.fromJson(Map<String, dynamic> json) => AddressCategory(
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
