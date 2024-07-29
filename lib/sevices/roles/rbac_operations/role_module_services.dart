import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:unit2/model/rbac/role_module.dart';
import 'package:unit2/utils/global.dart';
import '../../../utils/request.dart';
import '../../../utils/urls.dart';

class RbacRoleModuleServices {
  static final RbacRoleModuleServices _instance =
      RbacRoleModuleServices();
  static RbacRoleModuleServices get instance => _instance;
    String path = Url.instance.getRoleModules();
   Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'X-Client-Key': xClientKey,
      'X-Client-Secret': xClientSecret
    };
  Future<List<RoleModules>> getRoleModules() async {
    List<RoleModules> roleModules = [];
    try {
      http.Response response = await Request.instance
          .getRequest(param: {}, path: path, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          for (var roleMod in data['data']) {
            RoleModules newRoleMod = RoleModules.fromJson(roleMod);
            roleModules.add(newRoleMod);
          }
        }
      }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
    } catch (e) {
      throw e.toString();
    }
    return roleModules;
  }

  ////Add
  Future<Map<dynamic, dynamic>> add({
    required int assignerId,
    required int? roleId,
    required List<int> moduleIds,
  }) async {
    Map<dynamic, dynamic> statusResponse = {};
    Map body = {
      "role_id": roleId,
      "modules": moduleIds,
      "assigner_user_id": assignerId
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

  Future<bool> deleteRbacRoleModule({required int moduleObjectId}) async {
    bool success = false;
    try {
      http.Response response = await Request.instance
          .deleteRequest(path: "${path+moduleObjectId.toString()}/", headers: headers, body: {}, param: {});
      if (response.statusCode == 200) {
        success = true;
      }else{
        success = false;
      }
    } catch (e) {
      throw e.toString();
    }
    return success;
  }
}
