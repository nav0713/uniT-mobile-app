// To parse this JSON data, do
//
//     final sessionData = sessionDataFromJson(jsonString);

import 'dart:convert';

SessionData sessionDataFromJson(String str) => SessionData.fromJson(json.decode(str));

String sessionDataToJson(SessionData data) => json.encode(data.toJson());

class SessionData {
  SessionData({
    this.id,
    this.receivedDate,
    this.responseDate,
    this.statusid,
    this.acknowledgeDate,
    this.acknowledgedBy,
    this.remarks,
    this.respondentid,
    this.respondentMessage,
    this.pushedbuttonDate,
    this.sosLevel,
    this.sessionToken,
  });

  final int? id;
  final String? receivedDate;
  final String? responseDate;
  final int? statusid;
  final String? acknowledgeDate;
  final String? acknowledgedBy;
  final String? remarks;
  final int? respondentid;
  final String? respondentMessage;
  final String? pushedbuttonDate;
  final String? sosLevel;
  final String? sessionToken;

  factory SessionData.fromJson(Map<String, dynamic> json) => SessionData(
      id: json["id"] = json["id"],
    receivedDate: json["received_date"],
    responseDate: json["response_date"],
    statusid: json["statusid"],
    acknowledgeDate: json["acknowledge_date"],
    acknowledgedBy: json["acknowledged_by"],
    remarks: json["remarks"],
    respondentid: json["respondentid"],
    respondentMessage: json["respondent_message"],
    pushedbuttonDate: json["pushedbutton_date"],
    sosLevel: json["sos_level"],
    sessionToken: json["session_token"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "received_date": receivedDate,
    "response_date": responseDate,
    "statusid": statusid,
    "acknowledge_date": acknowledgeDate,
    "acknowledged_by": acknowledgedBy,
    "remarks": remarks,
    "respondentid": respondentid,
    "respondent_message": respondentMessage,
    "pushedbutton_date": pushedbuttonDate ,
    "sos_level": sosLevel,
    "session_token": sessionToken,
  };
}
