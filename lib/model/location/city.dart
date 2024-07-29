// To parse this JSON data, do
//
//     final city = cityFromJson(jsonString);

import 'dart:convert';

import 'provinces.dart';

CityMunicipality cityFromJson(String str) => CityMunicipality.fromJson(json.decode(str));

String cityToJson(CityMunicipality data) => json.encode(data.toJson());

class CityMunicipality {
    CityMunicipality({
        required this.code,
        required this.description,
        required this.province,
        required this.psgcCode,
        required this.zipcode,
    });

    final String? code;
    final String? description;
    final Province? province;
    final String? psgcCode;
    final String? zipcode;

    factory CityMunicipality.fromJson(Map<String, dynamic> json) => CityMunicipality(
        code: json["code"],
        description: json["description"],
        province: json['province'] == null? null : Province.fromJson(json["province"]),
        psgcCode: json["psgc_code"],
        zipcode: json["zipcode"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "description": description,
        "province": province?.toJson(),
        "psgc_code": psgcCode,
        "zipcode": zipcode,
    };
    @override
    String toString(){
      return 'CityMunicipality{code:$code, description:$description, provice:${province.toString()} }';
    }
}


