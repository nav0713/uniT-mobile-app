// To parse this JSON data, do
//
//     final region = regionFromJson(jsonString);

import 'dart:convert';

Region regionFromJson(String str) => Region.fromJson(json.decode(str));

String regionToJson(Region data) => json.encode(data.toJson());

class Region {
    Region({
        required this.code,
        required this.description,
        required this.psgcCode,
    });

    final int? code;
    final String? description;
    final String? psgcCode;

    factory Region.fromJson(Map<String, dynamic> json) => Region(
        code: json["code"],
        description: json["description"],
        psgcCode: json["psgc_code"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "description": description,
        "psgc_code": psgcCode,
    };

    @override
    String toString(){
      return 'Region(name:$description)';
    }
}
