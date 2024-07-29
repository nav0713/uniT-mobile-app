// To parse this JSON data, do
//
//     final barangay = barangayFromJson(jsonString);

import 'dart:convert';


Barangay2 barangayFromJson(String str) => Barangay2.fromJson(json.decode(str));

String barangayToJson(Barangay2 data) => json.encode(data.toJson());

class Barangay2 {
    Barangay2({
        required this.brgycode,
        required this.brgydesc,
        required this.citymuncode,
    });

    final String? brgycode;
    final String? brgydesc;
    final String? citymuncode;

    factory Barangay2.fromJson(Map<String, dynamic> json) => Barangay2(
        brgycode: json["brgycode"],
        brgydesc: json["brgydesc"],
        citymuncode: json['citymuncode']
    );

    Map<String, dynamic> toJson() => {
        "brgycode": brgycode,
        "brgydesc": brgydesc,
        "citymuncode": citymuncode
    };
}




