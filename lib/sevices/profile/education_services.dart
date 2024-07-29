import 'dart:convert';

import 'package:unit2/model/profile/educational_background.dart';
import 'package:unit2/utils/request.dart';

import '../../utils/urls.dart';
import 'package:http/http.dart' as http;

class EducationService {
  static final EducationService _instance = EducationService();
  static EducationService get instace => _instance;
////get educational background
  Future<List<EducationalBackground>> getEducationalBackground(
      int profileId, String token) async {
    List<EducationalBackground> educationalBackgrounds = [];
    String authToken = "Token $token";
    String path = "${Url.instance.educationalBackground()}$profileId/";
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authToken
    };
    try {
      http.Response response = await Request.instance
          .getRequest(path: path, param: {}, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          data['data'].forEach((var education) {
            EducationalBackground educationalBackground =
                EducationalBackground.fromJson(education);
            educationalBackgrounds.add(educationalBackground);
          });
        }
      }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
    } catch (e) {
      throw e.toString();
    }

    return educationalBackgrounds;
  }

  ////Add
  Future<Map<dynamic, dynamic>> add(
      {required EducationalBackground educationalBackground,
      required String token,
      required int profileId,
      required List<Honor> honors}) async {
    String authtoken = "Token $token";
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authtoken
    };
    String path = '${Url.instance.educationalBackground()}$profileId/';
    Map<dynamic, dynamic> statusResponse = {};
    Map body = {
      "_level": educationalBackground.education!.level,
      "_schoolId": educationalBackground.education?.school?.id,
      "_schoolName": educationalBackground.education!.school!.name,
      "_programId": educationalBackground.education?.course?.id,
      "_programName": educationalBackground.education?.course?.program,
      "_course": null,
      "period_from": educationalBackground.periodFrom.toString(),
      "period_to": educationalBackground.periodTo.toString(),
      "units_earned": educationalBackground.unitsEarned,
      "year_graduated": educationalBackground.yearGraduated,
      "honors": honors.isEmpty ? [] : honors,
    };
    try {
      http.Response response = await Request.instance
          .postRequest(path: path, param: {}, body: body, headers: headers);
      if (response.statusCode == 201) {
        Map data = jsonDecode(response.body);
        statusResponse = data;
      } else {
        statusResponse.addAll({'success': false});
      }
    } catch (e) {
      throw e.toString();
    }
    return statusResponse;
  }

  ////Edit
  Future<Map<dynamic, dynamic>> edit(
      {required EducationalBackground educationalBackground,
      required String token,
      required int profileId,
      required List<Honor> honors}) async {
    String authtoken = "Token $token";
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authtoken
    };
    String path = '${Url.instance.educationalBackground()}$profileId/';
    Map<dynamic, dynamic> statusResponse = {};
    Map body = {
      "id": educationalBackground.id,
      "_level": educationalBackground.education!.level,
      "_schoolId": educationalBackground.education?.school?.id,
      "_schoolName": educationalBackground.education!.school!.name,
      "_programId": educationalBackground.education?.course?.id,
      "_programName": educationalBackground.education?.course?.program,
      "_course": null,
      "period_from": educationalBackground.periodFrom.toString(),
      "period_to": educationalBackground.periodTo.toString(),
      "units_earned": educationalBackground.unitsEarned,
      "year_graduated": educationalBackground.yearGraduated,
      "honors": honors.isEmpty ? [] : honors,
    };
    try {
      http.Response response = await Request.instance
          .putRequest(path: path, param: {}, body: body, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        statusResponse = data;
      } else {
        statusResponse.addAll({'success': false});
      }
    } catch (e) {
      throw e.toString();
    }
    return statusResponse;
  }

  //// delete
  Future<bool> delete(
      {required int profileId,
      required String token,
      required EducationalBackground educationalBackground}) async {
    String authToken = "Token $token";
    String path = "${Url.instance.educationalBackground()}$profileId/";
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authToken
    };
    bool? success;
    Map<String, dynamic> params = {"force_mode": "true"};
    Map body = {
      "id": educationalBackground.id,
      "_level": educationalBackground.education!.level,
      "_schoolId": educationalBackground.education!.school!.id,
      "education_id": educationalBackground.education!.id,
      "period_from": educationalBackground.periodFrom,
      "period_to": educationalBackground.periodTo,
      "units_earned": educationalBackground.unitsEarned,
      "year_graduated": educationalBackground.yearGraduated,
      "honors": educationalBackground.honors
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

//// get schools
  Future<List<School>> getSchools() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    List<School> schools = [];
    String path = Url.instance.getSchools();
    try {
      http.Response response = await Request.instance
          .getRequest(param: {}, path: path, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          data['data'].forEach((school) {
            School newSchool = School.fromJson(school);
            schools.add(newSchool);
          });
        }
      }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
    } catch (e) {
      throw e.toString();
    }
    return schools;
  }

  Future<List<Course>> getPrograms() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    List<Course> programs = [];
    String path = Url.instance.getPrograms();
    try {
      http.Response response = await Request.instance
          .getRequest(param: {}, path: path, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          data['data'].forEach((course) {
            Course newCourse = Course.fromJson(course);
            programs.add(newCourse);
          });
        }
      }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
    } catch (e) {
      throw e.toString();
    }
    return programs;
  }

////get honors
  Future<List<Honor>> getHonors() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    List<Honor> honors = [];
    String path = Url.instance.getHonors();
    try {
      http.Response response = await Request.instance
          .getRequest(param: {}, path: path, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          data['data'].forEach((honor) {
            Honor newHonor = Honor.fromJson(honor);
            honors.add(newHonor);
          });
        }
      }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
    } catch (e) {
      throw e.toString();
    }
    return honors;
  }
}
