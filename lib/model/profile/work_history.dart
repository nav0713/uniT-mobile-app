import 'package:unit2/model/profile/attachment.dart';

import '../utils/agency.dart';
import '../utils/position.dart';

class WorkHistory {
  final PositionTitle? position;
  final Agency? agency;
  final Supervisor? supervisor;
  final int? id;
  final DateTime? fromDate;
  final DateTime? toDate;
  final int? agencydepid;
  final double? monthlysalary;
  final String? statusAppointment;
  final int? salarygrade;
  final int? sgstep;
  final List<Accomplishment>? accomplishment;
  final List<ActualDuty>? actualDuties;
   List<Attachment>? attachments;
  WorkHistory({
    required this.attachments,
    required this.position,
    required this.agency,
    required this.supervisor,
    required this.id,
    required this.fromDate,
    required this.toDate,
    required this.agencydepid,
    required this.monthlysalary,
    required this.statusAppointment,
    required this.salarygrade,
    required this.sgstep,
    required this.accomplishment,
    required this.actualDuties,
  });

  factory WorkHistory.fromJson(Map<String, dynamic> json) => WorkHistory(
        position: PositionTitle.fromJson(json["position"]),
        agency: json['agency'] == null?null: Agency.fromJson(json["agency"]),
        supervisor: json['supervisor'] == null?null: Supervisor.fromJson(json["supervisor"]),
        id: json["id"],
        fromDate: json['from_date'] == null?null:  DateTime.tryParse(json["from_date"]),
        toDate: json['to_date'] == null?null: DateTime.tryParse(json["to_date"]),
        agencydepid: json["agencydepid"],
        monthlysalary: json["monthlysalary"],
        statusAppointment: json["status_appointment"],
         attachments: [],
        salarygrade: json["salarygrade"],
        sgstep: json["sgstep"],
        accomplishment:json['accomplishment'] == null?null:  json['accomplishment'] == null?null: List<Accomplishment>.from(
            json["accomplishment"].map((x) => Accomplishment.fromJson(x))),
        actualDuties: json['actual_duties'] == null?null: List<ActualDuty>.from(
            json["actual_duties"].map((x) => ActualDuty.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "position": position?.toJson(),
        "agency": agency?.toJson(),
        "supervisor": supervisor?.toJson(),
        "id": id,
        "from_date":
            "${fromDate?.year.toString().padLeft(4, '0')}-${fromDate?.month.toString().padLeft(2, '0')}-${fromDate?.day.toString().padLeft(2, '0')}",
        "to_date": toDate,
        "agencydepid": agencydepid,
        "monthlysalary": monthlysalary,
        "status_appointment": statusAppointment,
        "salarygrade": salarygrade,
        "sgstep": sgstep,
        "accomplishment":
            List<dynamic>.from(accomplishment!.map((x) => x.toJson())),
        "actual_duties":
            List<dynamic>.from(actualDuties!.map((x) => x.toJson())),
      };
}

class Accomplishment {
  final int? id;
  final int? workExperienceId;
  final String? accomplishment;

  Accomplishment({
    required this.id,
    required this.workExperienceId,
    required this.accomplishment,
  });

  factory Accomplishment.fromJson(Map<String, dynamic> json) => Accomplishment(
        id: json["id"],
        workExperienceId: json["work_experience_id"],
        accomplishment: json["accomplishment"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "work_experience_id": workExperienceId,
        "accomplishment": accomplishment,
      };
}

class ActualDuty {
  final int? id;
  final int? workExperienceId;
  final String description;

  ActualDuty({
    required this.id,
    required this.workExperienceId,
    required this.description,
  });

  factory ActualDuty.fromJson(Map<String, dynamic> json) => ActualDuty(
        id: json["id"],
        workExperienceId: json["work_experience_id"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "work_experience_id": workExperienceId,
        "description": description,
      };
}



class Supervisor {
  final int? id;
  final int? agencyId;
  final String? lastname;
  final String? firstname;
  final String? middlename;
  final String? stationName;

  Supervisor({
    required this.id,
    required this.agencyId,
    required this.lastname,
    required this.firstname,
    required this.middlename,
    required this.stationName,
  });

  factory Supervisor.fromJson(Map<String, dynamic> json) => Supervisor(
        id: json["id"],
        agencyId: json["agency_id"],
        lastname: json["lastname"],
        firstname: json["firstname"],
        middlename: json["middlename"],
        stationName: json["station_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "agency_id": agencyId,
        "lastname": lastname,
        "firstname": firstname,
        "middlename": middlename,
        "station_name": stationName,
      };
}
class AttachmentElement {
    int id;
    AttachmentAttachment? attachment;
    int attachmentModule;

    AttachmentElement({
        required this.id,
        required this.attachment,
        required this.attachmentModule,
    });

    factory AttachmentElement.fromJson(Map<String, dynamic> json) => AttachmentElement(
        id: json["id"],
        attachment:json["attachment"] ==null?null: AttachmentAttachment.fromJson(json["attachment"]),
        attachmentModule: json["attachment_module"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "attachment": attachment?.toJson(),
        "attachment_module": attachmentModule,
    };
}
class AttachmentAttachment {
    int id;
    String source;
    String filename;
    dynamic subclass;
    AttachmentCategory category;

    AttachmentAttachment({
        required this.id,
        required this.source,
        required this.filename,
        required this.subclass,
        required this.category,
    });

    factory AttachmentAttachment.fromJson(Map<String, dynamic> json) => AttachmentAttachment(
        id: json["id"],
        source: json["source"],
        filename: json["filename"],
        subclass: json["subclass"],
        category: AttachmentCategory.fromJson(json["category"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "source": source,
        "filename": filename,
        "subclass": subclass,
        "category": category.toJson(),
    };
}




