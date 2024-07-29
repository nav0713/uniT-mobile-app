import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:unit2/utils/request.dart';

import '../../model/profile/other_information/non_acedimic_recognition.dart';
import '../../utils/urls.dart';

class NonAcademicRecognitionServices {
  static final NonAcademicRecognitionServices _instance =
      NonAcademicRecognitionServices();
  static NonAcademicRecognitionServices get instance => _instance;
////GET
  Future<List<NonAcademicRecognition>> getNonAcademicRecognition(
      int profileId, String token) async {
    List<NonAcademicRecognition> nonAcademicRecognitions = [];
    String authToken = "Token $token";
    String path = "${Url.instance.getNonAcademicRecognition()}$profileId/";
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
          data['data'].forEach((var recognition) {
            NonAcademicRecognition nonAcademicRecognition =
                NonAcademicRecognition.fromJson(recognition);
            nonAcademicRecognitions.add(nonAcademicRecognition);
          });
        }
      }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
    } catch (e) {
      throw e.toString();
    }
    return nonAcademicRecognitions;
  }

////ADD
  Future<Map<dynamic, dynamic>> add(
      {required String token,
      required int profileId,
      required NonAcademicRecognition nonAcademicRecognition}) async {
    String authToken = "Token $token";
    String path = "${Url.instance.getNonAcademicRecognition()}$profileId/";
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authToken
    };
    Map body = {
      "title": nonAcademicRecognition.title,
      "presenter_id": nonAcademicRecognition.presenter?.id,
      "_presenterName": nonAcademicRecognition.presenter!.name,
      "_presenterCatId": nonAcademicRecognition.presenter!.category!.id,
      "_privateEntity": nonAcademicRecognition.presenter!.privateEntity,
    };

    Map<dynamic, dynamic> statusResponse = {};
    try {
      http.Response response = await Request.instance
          .postRequest(path: path, body: body, param: {}, headers: headers);
      if (response.statusCode == 201) {
        Map data = jsonDecode(response.body);
        statusResponse = data;
      } else {
        statusResponse.addAll({"success": false});
      }
    } catch (e) {
      throw e.toString();
    }
    return statusResponse;
  }

  ////UPDATE
  Future<Map<dynamic, dynamic>> update(
      {required NonAcademicRecognition nonAcademicRecognition,
      required int profileId,
      required String token}) async {
    String authToken = "Token $token";
    String path = "${Url.instance.getNonAcademicRecognition()}$profileId/";
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authToken
    };
    Map<dynamic, dynamic> statusResponse = {};
    Map body = {
      "id": nonAcademicRecognition.id,
      "title": nonAcademicRecognition.title,
      "presenter_id": nonAcademicRecognition.presenter?.id,
      "_presenterName": nonAcademicRecognition.presenter!.name,
      "_presenterCatId": nonAcademicRecognition.presenter!.category!.id,
      "_privateEntity": nonAcademicRecognition.presenter!.privateEntity
    };
    try {
      http.Response response = await Request.instance
          .putRequest(path: path, headers: headers, body: body, param: {});
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

////DELETE
  Future<bool> delete(
      {required String title,
      required int id,
      required String token,
      required int profileId}) async {
    String authToken = "Token $token";
    Map<String, dynamic> params = {"force_mode": "true"};
    String path = "${Url.instance.getNonAcademicRecognition()}$profileId/";
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authToken
    };
    bool success = false;
    Map body = {
      "id": id,
      "title": title,
    };
    try {
      http.Response response = await Request.instance.deleteRequest(
          path: path, headers: headers, body: body, param: params);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        success = data['success'];
      }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
    } catch (e) {
      throw e.toString();
    }
    return success;
  }
}
