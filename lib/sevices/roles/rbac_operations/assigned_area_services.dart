import 'dart:convert';

import 'package:unit2/model/profile/assigned_area.dart';
import 'package:unit2/utils/global.dart';
import 'package:unit2/utils/urls.dart';
import 'package:http/http.dart' as http;
import '../../../utils/request.dart';

class RbacAssignedAreaServices {
  static final RbacAssignedAreaServices _instance = RbacAssignedAreaServices();
  static RbacAssignedAreaServices get instance => _instance;
  String path = Url.instance.getAssignAreas();
  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'X-Client-Key': xClientKey,
    'X-Client-Secret': xClientSecret
  };
  Future<List<UserAssignedArea>> getAssignedArea({required int id}) async {
    List<UserAssignedArea> userAssignedAreas = [];
    Map<String, String> param = {
      "assigned_role__user__id": id.toString(),
    };
    try {
      http.Response response = await Request.instance
          .getRequest(param: param, path: path, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          for (var assignedArea in data['data']) {
            UserAssignedArea newArea = UserAssignedArea.fromJson(assignedArea);
            userAssignedAreas.add(newArea);
          }
        }
      }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
    } catch (e) {
      throw e.toString();
    }
    return userAssignedAreas;
  }

  Future<bool> deleteAssignedArea({required int areaId}) async {
    bool success = false;
    try {
      http.Response response = await Request.instance.deleteRequest(
          path: "${path + areaId.toString()}/",
          headers: headers,
          body: {},
          param: {});
      if (response.statusCode == 200) {
        success = true;
      } else {
        success = false;
      }
    } catch (e) {
      throw e.toString();
    }
    return success;
  }

  Future<Map<dynamic, dynamic>> add(
      {required int userId,
      required int roleId,
      required int areaTypeId,
      required String areaId}) async {
    Map<dynamic, dynamic>? responseStatus = {};
    Map body = {
      "user_id": userId,
      "role_id": roleId,
      "assigned_areas": [
        {"areatypeid": areaTypeId, "areaid": areaId}
      ]
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
    } catch (e) {
      throw e.toString();
    }
    return responseStatus;
  }
}
