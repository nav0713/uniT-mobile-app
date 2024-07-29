import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:logger/web.dart';
import 'package:unit2/model/profile/attachment.dart';
import 'package:unit2/model/profile/work_history.dart';
import 'package:http/http.dart' as http;
import 'package:unit2/model/utils/agency_position.dart';
import 'package:unit2/model/utils/position.dart';
import 'package:unit2/utils/request.dart';

import '../../utils/urls.dart';

class WorkHistoryService {
  static final WorkHistoryService _instance = WorkHistoryService();
  static WorkHistoryService get instance => _instance;

////get all workhistories
  Future<List<WorkHistory>> getWorkExperiences(
      int profileId, String token) async {
    List<WorkHistory> workExperiences = [];
    String authToken = "Token $token";
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authToken
    };
    String path = Url.instance.workhistory() + profileId.toString();
    try {
      http.Response response = await Request.instance
          .getRequest(path: path, headers: headers, param: {});
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          data['data'].forEach((var workHistory) {
            WorkHistory newWorkHistory = WorkHistory.fromJson(workHistory);
            workExperiences.add(newWorkHistory);
            if (workHistory['attachments'] != null) {
              workHistory['attachments'].forEach((var attachment) {
                AttachmentCategory category = AttachmentCategory.fromJson(
                    attachment['attachment']['category']);
                Attachment newAttachment = Attachment(
                    id: attachment['attachment']['id'],
                    source: attachment['attachment']['source'],
                    category: category,
                    filename: attachment['attachment']['filename'],
                    subclass: attachment['attachment']['subclass'],
                    createdAt: null);
                newWorkHistory.attachments!.add(newAttachment);
              });
            }
          });
        }
      } else {
        Map data = jsonDecode(response.body);
        throw data['message'];
      }
    } catch (e) {
      throw e.toString();
    }
    return workExperiences;
  }

////delete workhistory
  Future<bool> delete(
      {required int profileId,
      required String token,
      required WorkHistory work}) async {
    bool? success;
    Map<String, dynamic> params = {"force_mode": "true"};
    String authToken = "Token $token";
    String path = "${Url.instance.deleteWorkHistory()}$profileId/";
    Map body = {
      "id": work.id,
      "position_id": work.position!.id,
      "agency_id": work.agency!.id,
      "from_date": work.fromDate?.toString(),
      "to_date": work.toDate?.toString(),
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authToken
    };
    try {
      http.Response response = await Request.instance.deleteRequest(
          path: path, headers: headers, body: body, param: params);

      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        success = data['success'];
      } else {
        success = false;
      }
    } catch (e) {
      throw e.toString();
    }
    return success!;
  }

  ////edit work history
  // Future<Map<dynamic,dynamic>> update({required WorkHistory oldWorkHistory, required WorkHistory newWorkHistory, required String token, required String profileId})async{
  //   Map<dynamic, dynamic>? statusResponse={};
  //   String authtoken = "Token $token";
  //   String path = '${Url.instance.workhistory()}$profileId/';
  //    Map<String, String> headers = {
  //     'Content-Type': 'application/json; charset=UTF-8',
  //     'Authorization': authtoken
  //   };
  //   Map body = {
  //     "id":newWorkHistory.id,
  //     "position_id":newWorkHistory.position!.id,
  //     "agency_id":newWorkHistory.agency!.id,
  //     "from_date":newWorkHistory.fromDate?.toString(),
  //     "to_date":newWorkHistory.toDate?.toString(),
  //     "monthly_salary":newWorkHistory.monthlysalary,
  //     "appointment_status":newWorkHistory.statusAppointment,
  //     "salary_grade":newWorkHistory.salarygrade,
  //     "sg_step":newWorkHistory.sgstep,
  //     "_positionName":newWorkHistory.position!.title!,
  //     "_agencyName":newWorkHistory.agency!.name!,
  //     "_agencyCatId":newWorkHistory.agency!.category!.id!,
  //     "_privateEntity":newWorkHistory.agency!.privateEntity,
  //     "oldPosId":oldWorkHistory.position!.id,
  //     "_oldAgencyId":oldWorkHistory.agency!.id,
  //     "oldFromDate":oldWorkHistory.fromDate?.toString(),
  //   };

  //   try{
  //     http.Response response = await Request.instance.putRequest(path: path, headers: headers, body: body, param: {});
  //     if(response.statusCode == 200 ){
  //       Map data = jsonDecode(response.body);
  //       statusResponse = data;
  //     }else{
  //       statusResponse.addAll({'success':false});
  //     }
  //     return statusResponse;
  //   }catch(e){
  //     throw e.toString();
  //   }
  // }

  ////Add work history
  Future<Map<dynamic, dynamic>> add(
      {required WorkHistory workHistory,
      required String token,
      required int profileId,
      required bool isPrivate,
      required String? accomplishment,
      required String? actualDuties}) async {
    String authtoken = "Token $token";
    String path = '${Url.instance.workhistory()}$profileId/';
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authtoken
    };
    Map<String, String> body = {};
    Map<dynamic, dynamic> statusResponse = {};
    String fromDate = DateFormat('yyyy-MM-dd').format(workHistory.fromDate!);
    String? toDate = workHistory.toDate == null
        ? null
        : DateFormat('yyyy-MM-dd').format(workHistory.toDate!);

    if (workHistory.toDate == null) {
      body = {
        "a_category_id ": workHistory.agency?.category?.id == null
            ? ""
            : workHistory.agency!.category!.id.toString(),
        "a_name":
            workHistory.agency?.name == null ? "" : workHistory.agency!.name!,
        "a_private_entity":
            workHistory.agency!.privateEntity! == true ? "True" : "False",
        "accomplishment": accomplishment ?? "",
        "actual_duties ": actualDuties!,
        "agency_id": workHistory.agency?.id == null
            ? ""
            : workHistory.agency!.id.toString(),
        "from_date": fromDate,
        "monthly_salary": workHistory.monthlysalary == null
            ? ""
            : workHistory.monthlysalary.toString(),
        "position_id": workHistory.position?.id == null
            ? ""
            : workHistory.position!.id.toString(),
        "position_name": workHistory.position?.title == null
            ? ""
            : workHistory.position!.title!,
        "s_fname": workHistory.supervisor!.firstname!,
        "s_lname":  workHistory.supervisor!.lastname!,
        "s_mname": workHistory.supervisor?.middlename == null
            ? ""
            : workHistory.supervisor!.middlename!,
        "s_office": workHistory.supervisor!.stationName!,
        "salary_grade": workHistory.salarygrade == null
            ? ""
            : workHistory.salarygrade.toString(),
        "sg_step":
            workHistory.sgstep == null ? "" : workHistory.sgstep.toString(),
        'status_appointment': workHistory.statusAppointment ?? "",
      };
    } else {
      body = {
        "a_category_id ": workHistory.agency?.category?.id == null
            ? ""
            : workHistory.agency!.category!.id.toString(),
        "a_name":
            workHistory.agency?.name == null ? "" : workHistory.agency!.name!,
        "a_private_entity":
            workHistory.agency!.privateEntity! == true ? "True" : "False",
        "accomplishment": accomplishment ?? "",
        "actual_duties ": actualDuties!,
        "agency_id": workHistory.agency?.id == null
            ? ""
            : workHistory.agency!.id.toString(),
        "from_date": fromDate,
        "monthly_salary": workHistory.monthlysalary == null
            ? ""
            : workHistory.monthlysalary.toString(),
        "position_id": workHistory.position?.id == null
            ? ""
            : workHistory.position!.id.toString(),
        "position_name": workHistory.position?.title == null
            ? ""
            : workHistory.position!.title!,
        "s_fname":workHistory.supervisor!.firstname!,
        "s_lname": workHistory.supervisor!.lastname!,
        "s_mname": workHistory.supervisor?.middlename == null
            ? ""
            : workHistory.supervisor!.middlename!,
        "office_unit":  workHistory.supervisor!.stationName!,
        "salary_grade": workHistory.salarygrade == null
            ? ""
            : workHistory.salarygrade.toString(),
        "sg_step":
            workHistory.sgstep == null ? "" : workHistory.sgstep.toString(),
        'status_appointment': workHistory.statusAppointment ?? "",
        "to_date": toDate!,
      };
    }

    var request = http.MultipartRequest('POST',
        Uri.parse('${Url.instance.prefixHost()}${Url.instance.host()}$path'));
    request.fields.addAll(body);
    request.headers.addAll(headers);
    try {
      http.StreamedResponse response = await request.send();
      final steamResponse = await response.stream.bytesToString();
      Map data = jsonDecode(steamResponse);
      if (response.statusCode == 201) {
        statusResponse = data;

      } else {
        String message = data['response']['details'];
        statusResponse.addAll({'message': message});
        statusResponse.addAll(
          {'success': false},
        );
      }
    } catch (e) {
      throw e.toString();
    }
    return statusResponse;
  }

  Future<Map<dynamic, dynamic>> update(
      {required WorkHistory workHistory,
      required String token,
      required int profileId,
      required bool isPrivate}) async {
    String authtoken = "Token $token";
    String path = '${Url.instance.workhistory()}$profileId/';
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authtoken
    };

    Map<String, String> body = {};
    Map<dynamic, dynamic> statusResponse = {};
    String fromDate = DateFormat('yyyy-MM-dd').format(workHistory.fromDate!);
    String? toDate = workHistory.toDate == null
        ? null
        : DateFormat('yyyy-MM-dd').format(workHistory.toDate!);
    if (workHistory.toDate == null) {
      body = {
        "a_category_id ": workHistory.agency?.category?.id == null
            ? ""
            : workHistory.agency!.category!.id.toString(),
        "a_name":
            workHistory.agency?.name == null ? "" : workHistory.agency!.name!,
        " a_private_entity ":     workHistory.agency!.privateEntity! == true ? "True" : "False",
        "accomplishment": workHistory.accomplishment == null
            ? ""
            : workHistory.accomplishment!.first.accomplishment!,
        "actual_duties ": workHistory.actualDuties == null
            ? ""
            : workHistory.actualDuties!.first.description,
        "agency_id": workHistory.agency?.id == null
            ? ""
            : workHistory.agency!.id.toString(),
        "from_date": fromDate,
        "monthly_salary": workHistory.monthlysalary == null
            ? ""
            : workHistory.monthlysalary.toString(),
        "position_id": workHistory.position?.id == null
            ? ""
            : workHistory.position!.id.toString(),
        "position_name": workHistory.position?.title == null
            ? ""
            : workHistory.position!.title!,
        "s_fname": workHistory.supervisor?.firstname == null
            ? ""
            : workHistory.supervisor!.firstname!,
        "s_lname": workHistory.supervisor?.lastname == null
            ? ""
            : workHistory.supervisor!.lastname!,
        "s_mname": workHistory.supervisor?.middlename == null
            ? ""
            : workHistory.supervisor!.middlename!,
        "office_unit": workHistory.supervisor?.stationName == null
            ? ""
            : workHistory.supervisor!.stationName!,
        "salary_grade": workHistory.salarygrade == null
            ? ""
            : workHistory.salarygrade.toString(),
        "sg_step":
            workHistory.sgstep == null ? "" : workHistory.sgstep.toString(),
        'status_appointment': workHistory.statusAppointment ?? "",
      };
    } else {
      body = {
        "a_category_id ": workHistory.agency?.category?.id == null
            ? ""
            : workHistory.agency!.category!.id.toString(),
        "a_name":
            workHistory.agency?.name == null ? "" : workHistory.agency!.name!,
        " a_private_entity ":     workHistory.agency!.privateEntity! == true ? "True" : "False",
        "accomplishment": workHistory.accomplishment == null
            ? ""
            : workHistory.accomplishment!.first.accomplishment!,
        "actual_duties ": workHistory.actualDuties == null
            ? ""
            : workHistory.actualDuties!.first.description,
        "agency_id": workHistory.agency?.id == null
            ? ""
            : workHistory.agency!.id.toString(),
        "from_date": fromDate,
        "monthly_salary": workHistory.monthlysalary == null
            ? ""
            : workHistory.monthlysalary.toString(),
        "position_id": workHistory.position?.id == null
            ? ""
            : workHistory.position!.id.toString(),
        "position_name": workHistory.position?.title == null
            ? ""
            : workHistory.position!.title!,
        "s_fname": workHistory.supervisor?.firstname == null
            ? ""
            : workHistory.supervisor!.firstname!,
        "s_lname": workHistory.supervisor?.lastname == null
            ? ""
            : workHistory.supervisor!.lastname!,
        "s_mname": workHistory.supervisor?.middlename == null
            ? ""
            : workHistory.supervisor!.middlename!,
        "s_office": workHistory.supervisor?.stationName == null
            ? ""
            : workHistory.supervisor!.stationName!,
        "salary_grade": workHistory.salarygrade == null
            ? ""
            : workHistory.salarygrade.toString(),
        "sg_step":
            workHistory.sgstep == null ? "" : workHistory.sgstep.toString(),
        'status_appointment': workHistory.statusAppointment ?? "",
        "to_date": toDate!,
      };
    }

    var request = http.MultipartRequest(
        'PUT',
        Uri.parse(
            '${Url.instance.prefixHost()}${Url.instance.host()}$path'));
    request.fields.addAll(body);
    request.headers.addAll(headers);
    try {
    http.StreamedResponse response = await request.send();
    final steamResponse = await response.stream.bytesToString();
    Map data = jsonDecode(steamResponse);
    if (response.statusCode == 201) {
      statusResponse = data;
    } 
    
    else {
      String message = data['message'];
      statusResponse.addAll({'message': message});
      statusResponse.addAll(
        {'success': false},
      );
    }
    } catch (e) {
      throw e.toString();
    }
    return statusResponse;
  }

////get agency position
  Future<List<PositionTitle>> getAgencyPosition() async {
    List<PositionTitle> agencyPositions = [];
    String path = Url.instance.getPositions();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      http.Response response = await Request.instance
          .getRequest(param: {}, path: path, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          data['data'].forEach((var agencyPosition) {
            PositionTitle position = PositionTitle.fromJson(agencyPosition);
            agencyPositions.add(position);
          });
        }
      } else {
        Map data = jsonDecode(response.body);
        throw data['message'];
      }
    } catch (e) {
      throw (e.toString());
    }
    return agencyPositions;
  }

//get appointment status
  List<AppoinemtStatus> getAppointmentStatusList() {
    return [
      AppoinemtStatus(value: "Appointed", label: "Appointed"),
      AppoinemtStatus(value: "Casual", label: "Casual"),
      AppoinemtStatus(
          value: "Contact of Service", label: "Contract of Service"),
      AppoinemtStatus(value: "Coterminous", label: "Coterminous"),
      AppoinemtStatus(value: "Elected", label: "Elected"),
      AppoinemtStatus(value: "Job Order", label: "Job Order"),
      AppoinemtStatus(value: "Permanent", label: "Permanent"),
      AppoinemtStatus(value: "Elected", label: "Elected"),
    ];
  }
}
