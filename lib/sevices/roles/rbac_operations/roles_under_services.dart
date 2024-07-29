import 'dart:convert';

import 'package:unit2/model/rbac/role_under.dart';
import 'package:http/http.dart' as http;
import 'package:unit2/utils/global.dart';
import '../../../utils/request.dart';
import '../../../utils/urls.dart';

class RbacRoleUnderServices {
  static final RbacRoleUnderServices _instance = RbacRoleUnderServices();
  static RbacRoleUnderServices get instance => _instance;
      String path = Url.instance.getRolesUnder();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'X-Client-Key': xClientKey,
      'X-Client-Secret': xClientSecret
    };
  Future<List<RolesUnder>> getRolesUnder() async {
    List<RolesUnder> rolesUnder = [];
    try {
      http.Response response = await Request.instance
          .getRequest(param: {}, path: path, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          for (var roleUnd in data['data']) {
            RolesUnder newRoleUnder = RolesUnder.fromJson(roleUnd);
            rolesUnder.add(newRoleUnder);
          }
        }
      }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
    } catch (e) {
      throw e.toString();
    }
    return rolesUnder;
  }

  ////Add
  Future<Map<dynamic, dynamic>> add({
    required int? roleId,
    required List<int> rolesId,
  }) async {
    Map<dynamic, dynamic> statusResponse = {};

    Map body = {
      "role_main_id": roleId,
      "roles_under": rolesId,
    };
    try {
      http.Response response = await Request.instance
          .postRequest(path: path, body: body, headers: headers, param: {});
      if (response.statusCode == 201) {
        Map data = jsonDecode(response.body);
        statusResponse = data;
      } else {
        Map data = jsonDecode(response.body);
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


  Future<bool> deleteRbacRoleUnder({required int roleUnderId}) async {
    bool success = false;
    try {
      http.Response response = await Request.instance
          .deleteRequest(path: "${path+roleUnderId.toString()}/", headers: headers, body: {}, param: {});
      if (response.statusCode == 200) {
        success = true;
      }
    } catch (e) {
      throw e.toString();
    }
    return success;
  }
}
