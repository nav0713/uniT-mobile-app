// To parse this JSON data, do
//
//     final references = referencesFromJson(jsonString);
import '../location/address_category.dart';
import '../location/barangay.dart';
import '../location/city.dart';
import '../location/country.dart';

class PersonalReference {
    PersonalReference({
        required this.id,
        required this.address,
        required this.lastName,
        required this.contactNo,
        required this.firstName,
        required this.middleName,
    });

    final int? id;
    final Address? address;
    final String? lastName;
    final String? contactNo;
    final String? firstName;
    final String? middleName;

    factory PersonalReference.fromJson(Map<String, dynamic> json) => PersonalReference(
        id: json["id"],
        address: json['address'] == null?null: Address.fromJson(json["address"]),
        lastName: json["last_name"],
        contactNo: json["contact_no"],
        firstName: json["first_name"],
        middleName: json["middle_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "address": address!.toJson(),
        "last_name": lastName,
        "contact_no": contactNo,
        "first_name": firstName,
        "middle_name": middleName,
    };
}

class Address {
    Address({
        required this.id,
        required this.addressClass,
        required this.country,
        required this.barangay,
        required this.addressCategory,
        required this.cityMunicipality,
    });

    final int? id;
    final String? addressClass;
    final Country? country;
    final Barangay? barangay;
    final AddressCategory? addressCategory;
    final CityMunicipality? cityMunicipality;

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        addressClass: json["class"],
        country: json['country']== null?null: Country.fromJson(json["country"]),
        barangay:json["barangay"]== null?null: Barangay.fromJson(json["barangay"]),
        addressCategory: json["address_category"]== null? null: AddressCategory.fromJson(json["address_category"]),
        cityMunicipality: json["city_municipality"]==null?null: CityMunicipality.fromJson(json["city_municipality"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "class": addressClass,
        "country": country!.toJson(),
        "barangay": barangay!.toJson(),
        "address_category": addressCategory!.toJson(),
        "city_municipality": cityMunicipality!.toJson(),
    };
}




