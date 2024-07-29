import 'dart:convert';

import 'package:unit2/model/rbac/role_extend.dart';
import 'package:http/http.dart' as http;
import 'package:unit2/utils/global.dart';
import '../../../utils/request.dart';
import '../../../utils/urls.dart';

class RbacRoleExtendServices {
  static final RbacRoleExtendServices _instance = RbacRoleExtendServices();
  static RbacRoleExtendServices get instance => _instance;
  String path = Url.instance.getRoleExtend();
  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'X-Client-Key': xClientKey,
    'X-Client-Secret': xClientSecret
  };
  Future<List<RolesExtend>> getRolesExtend() async {
    List<RolesExtend> rolesextend = [];
    try {
      http.Response response = await Request.instance
          .getRequest(param: {}, path: path, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          for (var roleExt in data['data']) {
            RolesExtend newRoleExtend = RolesExtend.fromJson(roleExt);
            rolesextend.add(newRoleExtend);
          }
        }
      }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
    } catch (e) {
      throw e.toString();
    }
    return rolesextend;
  }

  Future<List<RolesExtend>> getUnit2RolesExtend({required int webUserId})async{
      List<RolesExtend> rolesextend = [];
      Map<String,String> params = {
        "user_id": webUserId.toString(),
      };
         try {
      http.Response response = await Request.instance
          .getRequest(param: params, path: path, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          for (var roleExt in data['data']) {
            RolesExtend newRoleExtend = RolesExtend.fromJson(roleExt);
            rolesextend.add(newRoleExtend);
          }
        }
      }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
    } catch (e) {
      throw e.toString();
    }
    return rolesextend;
  }

  ////Add
  Future<Map<dynamic, dynamic>> add({
    required int? roleId,
    required List<int> rolesExtendsId,
  }) async {
    Map<dynamic, dynamic> statusResponse = {};
    Map body = {
      "role_main_id": roleId,
      "roles_extend": rolesExtendsId,
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

  Future<bool> delete({required int roleExtendId}) async {
    bool success = false;
    try {
      http.Response response = await Request.instance.deleteRequest(
          path: '${path + roleExtendId.toString()}/',
          headers: headers,
          body: {},
          param: {});
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
