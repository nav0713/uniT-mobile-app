// To parse this JSON data, do
//
//     final message = messageFromJson(jsonString);

import 'dart:convert';
import 'package:unit2/model/communication/module.dart';
import 'package:unit2/model/communication/person.dart';
import 'package:unit2/model/communication/user.dart';

Message messageFromJson(String str) => Message.fromJson(json.decode(str));

String messageToJson(Message data) => json.encode(data.toJson());

class Message {
    int? id;
    String? employeeid;
    DateTime? sentBySystemAt;
    bool? isSuccess;
    int? sentAttempCount;
    String? dateAcknowledged;
    String? comments;
    String? mobileEmail;
    DateTime? recordedByApiAt;
    DateTime? sentByProviderAt;
    String? telco;
    bool? isIntl;
    String? rcvdTranid;
    String? transactionId;
    Systemid? systemid;
    DeliveryType? deliveryType;
    Response? response;
    String? otpRequest;
    String? remarks;

    Message({
        required this.id,
        required this.employeeid,
        required this.sentBySystemAt,
        required this.isSuccess,
        required this.sentAttempCount,
        required this.dateAcknowledged,
        required this.comments,
        required this.mobileEmail,
        required this.recordedByApiAt,
        required this.sentByProviderAt,
        required this.telco,
        required this.isIntl,
        required this.rcvdTranid,
        required this.transactionId,
        required this.systemid,
        required this.deliveryType,
        required this.response,
        required this.otpRequest,
        required this.remarks,
    });

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        employeeid: json["employeeid"],
        sentBySystemAt: json["sent_by_system_at"] == null?null: DateTime.parse(json["sent_by_system_at"]),
        isSuccess: json["is_success"],
        sentAttempCount: json["sent_attemp_count"],
        dateAcknowledged: json["date_acknowledged"],
        comments: json["comments"],
        mobileEmail: json["mobile_email"],
        recordedByApiAt: json["recorded_by_api_at"] ==null?null:  DateTime.parse(json["recorded_by_api_at"]),
        sentByProviderAt:json["sent_by_provider_at"] == null? null:  DateTime.parse(json["sent_by_provider_at"]),
        telco: json["telco"],
        isIntl: json["is_intl"],
        rcvdTranid: json["rcvd_tranid"],
        transactionId: json["transaction_id"],
        systemid: json["systemid"] == null? null: Systemid.fromJson(json["systemid"]),
        deliveryType: json["delivery_type"] == null?null:DeliveryType.fromJson(json["delivery_type"]),
        response: json["response"] == null?null: Response.fromJson(json["response"]),
        otpRequest: json["otp_request"],
        remarks: json["remarks"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "employeeid": employeeid,
        "sent_by_system_at": sentBySystemAt?.toIso8601String(),
        "is_success": isSuccess,
        "sent_attemp_count": sentAttempCount,
        "date_acknowledged": dateAcknowledged,
        "comments": comments,
        "mobile_email": mobileEmail,
        "recorded_by_api_at": recordedByApiAt?.toIso8601String(),
        "sent_by_provider_at": sentByProviderAt?.toIso8601String(),
        "telco": telco,
        "is_intl": isIntl,
        "rcvd_tranid": rcvdTranid,
        "transaction_id": transactionId,
        "systemid": systemid?.toJson(),
        "delivery_type": deliveryType?.toJson(),
        "response": response?.toJson(),
        "otp_request": otpRequest,
        "remarks": remarks,
    };
}



class MessageClass {
    int? id;
    String? contentDetails;
    String? contentSummary;
    String? messageType;
    String? status;
    Module? systemApp;
    String? communicationType;
    dynamic createdByScoutUser;
    DateTime? createdAt;

    MessageClass({
        required this.id,
        required this.contentDetails,
        required this.contentSummary,
        required this.messageType,
        required this.status,
        required this.systemApp,
        required this.communicationType,
        required this.createdByScoutUser,
        required this.createdAt,
    });

    factory MessageClass.fromJson(Map<String, dynamic> json) => MessageClass(
        id: json["id"],
        contentDetails: json["content_details"],
        contentSummary: json["content_summary"],
        messageType: json["message_type"],
        status: json["status"],
        systemApp: json["system_app"] == null?null:Module.fromJson(json["system_app"]),
        communicationType: json["communication_type"],
        createdByScoutUser: json["created_by_scout_user"],
        createdAt:json["created_at"] == null? null: DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "content_details": contentDetails,
        "content_summary": contentSummary,
        "message_type": messageType,
        "status": status,
        "system_app": systemApp?.toJson(),
        "communication_type": communicationType,
        "created_by_scout_user": createdByScoutUser,
        "created_at": createdAt?.toIso8601String(),
    };
}
class Systemid {
    User? user;
    Person? person;

    Systemid({
        required this.user,
        required this.person,
    });

    factory Systemid.fromJson(Map<String, dynamic> json) => Systemid(
        user:json["user"] ==null?null: User.fromJson(json["user"]),
        person:json["person"]==null?null: Person.fromJson(json["person"]),
    );

    Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "person": person?.toJson(),
    };
}
class DeliveryType {
    int? id;
    Module? module;
    MessageClass? message;

    DeliveryType({
        required this.id,
        required this.module,
        required this.message,
    });

    factory DeliveryType.fromJson(Map<String, dynamic> json) => DeliveryType(
        id: json["id"],
        module: json["module"] == null?null: Module.fromJson(json["module"]),
        message:json["message"] == null?null: MessageClass.fromJson(json["message"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "module": module?.toJson(),
        "message": message?.toJson(),
    };
}
class Response {
    int code;
    String name;

    Response({
        required this.code,
        required this.name,
    });

    factory Response.fromJson(Map<String, dynamic> json) => Response(
        code: json["code"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
    };
}


















