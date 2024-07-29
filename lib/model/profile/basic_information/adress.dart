

import '../../location/barangay.dart';
import '../../location/city.dart';
import '../../location/country.dart';
import '../../location/subdivision.dart';
import '../../utils/category.dart';

class MainAdress {
    MainAdress({
        this.id,
        this.address,
        this.details,
        this.subdivision,
    });

    final int? id;
    final AddressClass? address;
    final String? details;
    final Subdivision? subdivision;

    factory MainAdress.fromJson(Map<String, dynamic> json) => MainAdress(
        id: json["id"],
        address: json["address"] == null ? null : AddressClass.fromJson(json["address"]),
        details: json["details"],
        subdivision: json["subdivision"] == null ? null : Subdivision.fromJson(json["subdivision"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "address": address?.toJson(),
        "details": details,
        "subdivision": subdivision?.toJson(),
    };
}

class AddressClass {
    AddressClass({
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
    final Category? category;
    final String? areaClass;
    final CityMunicipality? cityMunicipality;

    factory AddressClass.fromJson(Map<String, dynamic> json) => AddressClass(
        id: json["id"],
        country: json["country"] == null ? null : Country.fromJson(json["country"]),
        barangay: json["barangay"] == null ? null : Barangay.fromJson(json["barangay"]),
        category: json["category"] == null ? null : Category.fromJson(json["category"]),
        areaClass: json["area_class"],
        cityMunicipality: json["city_municipality"] == null ? null : CityMunicipality.fromJson(json["city_municipality"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "country": country?.toJson(),
        "barangay": barangay?.toJson(),
        "category": category?.toJson(),
        "area_class": areaClass,
        "city_municipality": cityMunicipality?.toJson(),
    };
}





