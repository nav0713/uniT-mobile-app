// To parse this JSON data, do
//
//     final province = provinceFromJson(jsonString);

import 'dart:convert';

import 'region.dart';

Province provinceFromJson(String str) => Province.fromJson(json.decode(str));

String provinceToJson(Province data) => json.encode(data.toJson());

class Province {
    Province({
        required this.code,
        required this.description,
        required this.region,
        required this.psgcCode,
        required this.shortname,
    });

    final String? code;
    final String? description;
    final Region? region;
    final String? psgcCode;
    final String? shortname;

    factory Province.fromJson(Map<String, dynamic> json) => Province(
        code: json["code"],
        description: json["description"],
        region: json['region'] == null? null: Region.fromJson(json["region"]),
        psgcCode: json["psgc_code"],
        shortname: json["shortname"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "description": description,
        "region": region!.toJson(),
        "psgc_code": psgcCode,
        "shortname": shortname,
    };

    @override
    String toString(){
      return 'Province(name:$description ${region.toString()})';
    }
}
