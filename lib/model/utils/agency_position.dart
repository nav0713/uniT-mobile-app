
import 'dart:convert';


// To parse this JSON data, do
//
//     final appoinemtStatus = appoinemtStatusFromJson(jsonString);
AppoinemtStatus appoinemtStatusFromJson(String str) => AppoinemtStatus.fromJson(json.decode(str));

String appoinemtStatusToJson(AppoinemtStatus data) => json.encode(data.toJson());

class AppoinemtStatus {
    AppoinemtStatus({
        required this.value,
        required this.label,
    });

    final String value;
    final String label;

    factory AppoinemtStatus.fromJson(Map<String, dynamic> json) => AppoinemtStatus(
        value: json["value"],
        label: json["label"],
    );

    Map<String, dynamic> toJson() => {
        "value": value,
        "label": label,
    };
}

