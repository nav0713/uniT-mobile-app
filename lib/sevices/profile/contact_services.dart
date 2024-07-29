import 'dart:convert';

import 'package:unit2/model/profile/basic_information/contact_information.dart';
import 'package:unit2/utils/request.dart';
import 'package:unit2/utils/urls.dart';
import 'package:http/http.dart' as http;

class ContactService {
  static final ContactService _instance = ContactService();
  static ContactService get instance => _instance;

  Future<List<CommService>> getServiceProvider(
      {required int serviceTypeId}) async {
    String path = Url.instance.getCommunicationProvider();
    Map<String, String> params = {"service_type__id": serviceTypeId.toString()};
    List<CommService> serviceProviders = [];
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      http.Response response = await Request.instance
          .getRequest(param: params, path: path, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          for (var element in data['data']) {
            CommService commService = CommService.fromJson(element);
            serviceProviders.add(commService);
          }
        }
      }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
    } catch (e) {
      throw e.toString();
    }
    return serviceProviders;
  }

//// update
  Future<Map<dynamic, dynamic>> update(
      {required int profileId,
      required String token,
      required ContactInfo contactInfo}) async {
    String path = "${Url.instance.contactPath()}$profileId/";
    String authToken = "Token $token";
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authToken
    };
    Map body = {
      "personid": profileId,
      "contactinfoid": contactInfo.id,
      "_numbermail": contactInfo.numbermail,
      "_active": contactInfo.active,
      "_primary": contactInfo.primary,
      "_commServiceId": contactInfo.commService!.id
    };
    Map<dynamic, dynamic> responseStatus = {};
    try {
      http.Response response = await Request.instance
          .putRequest(path: path, headers: headers, body: body, param: {});
      if (response.statusCode == 200) {
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

  //// add
  Future<Map<dynamic, dynamic>> add(
      {required int profileId,
      required String token,
      required ContactInfo contactInfo}) async {
    String path = "${Url.instance.contactPath()}$profileId/";
    String authToken = "Token $token";
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authToken
    };
    Map<dynamic, dynamic> responseStatus = {};
    Map body = {
      "personid": profileId,
      "_numbermail": contactInfo.numbermail,
      "_active": contactInfo.active,
      "_primary": contactInfo.primary,
      "_commServiceId": contactInfo.commService!.id
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

////delete
  Future<bool> deleteContact(
      {required int profileId,
      required String token,
      required ContactInfo contactInfo}) async {
    String path = "${Url.instance.deleteContact()}$profileId/";
    String authToken = "Token $token";
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'mode': 'same-origin',
      'include': 'credentials',
      'Authorization': authToken
    };
    bool success = false;
    Map<String, dynamic> params = {"force_mode": "true"};
    Map body = {
      "personid": profileId,
      "contactinfoid": contactInfo.id,
      "_numbermail": contactInfo.numbermail,
      "_active": contactInfo.active,
      "_primary": contactInfo.primary,
      "_commServiceId": contactInfo.commService!.id
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
