import 'dart:convert';

import 'package:unit2/model/profile/basic_information/citizenship.dart';

import '../../utils/request.dart';
import '../../utils/urls.dart';
import 'package:http/http.dart' as http;

class CitizenshipServices {
  static final CitizenshipServices _instance = CitizenshipServices();
  static CitizenshipServices get instance => _instance;

  Future<Map<dynamic, dynamic>> add(
      {required int profileId,
      required String token,
      required int countryId,
      required bool naturalBorn}) async {
    String path = "${Url.instance.citizenship()}$profileId/";
    String authToken = "Token $token";
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authToken
    };
    Map<dynamic, dynamic> responseStatus = {};
    Map body = {
      "country_id": countryId,
      "natural_born": naturalBorn,
    };
    try {
      http.Response response = await Request.instance
          .postRequest(path: path, headers: headers, body: body, param: {});
      if (response.statusCode == 201) {
        Map data = jsonDecode(response.body);
        responseStatus = data;
      } else {
        responseStatus.addAll({'success': false});
      }
      return responseStatus;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Map<dynamic, dynamic>> update(
      {required int profileId,
      required String token,
      required Citizenship citizenship,
      required int oldCountry}) async {
    String path = "${Url.instance.citizenship()}$profileId/";
    String authToken = "Token $token";
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authToken
    };
    Map body = {
      "country_id": citizenship.country!.id,
      "natural_born": citizenship.naturalBorn,
      "_oldCountryId": oldCountry
    };
    Map<dynamic, dynamic> responseStatus = {};
    try {
      http.Response response = await Request.instance
          .putRequest(path: path, headers: headers, body: body, param: {});
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        responseStatus = data;
      } else {
         Map data = jsonDecode(response.body);
         String message = data['message'];
        responseStatus.addAll({'success': false});
            responseStatus.addAll({'message': message});
      }
      return responseStatus;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> delete(
      {required int profileId,
      required String token,
      required countryId,
      required bool naturalBorn}) async {
    Map<String, dynamic> params = {"force_mode": "true"};
    String authtoken = "Token $token";
    String path = "${Url.instance.citizenship()}$profileId/";
    bool success = false;
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authtoken
    };
    Map body = {"country_id": countryId, "natural_born": naturalBorn};
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
      throw (e.toString());
    }
    return success;
  }
}
