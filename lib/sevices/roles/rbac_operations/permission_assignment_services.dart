import 'dart:convert';

import 'package:unit2/model/rbac/permission_assignment.dart';
import 'package:unit2/utils/global.dart';
import 'package:unit2/utils/request.dart';
import 'package:unit2/utils/urls.dart';
import 'package:http/http.dart' as http;

class RbacPermissionAssignmentServices {
  static final RbacPermissionAssignmentServices _instance =
      RbacPermissionAssignmentServices();
  static RbacPermissionAssignmentServices get instance => _instance;
    String path = Url.instance.getPermissionAssignment();
  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'X-Client-Key': xClientKey,
    'X-Client-Secret': xClientSecret
  };
  Future<List<PermissionAssignment>> getPermissionAssignment() async {
    List<PermissionAssignment> permissionAssignments = [];
    try {
      http.Response response = await Request.instance
          .getRequest(param: {}, path: path, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          for (var rbac in data['data']) {
            PermissionAssignment permissionAssignment =
                PermissionAssignment.fromJson(rbac);
            permissionAssignments.add(permissionAssignment);
          }
        }
      }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
    } catch (e) {
      e.toString();
    }
    return permissionAssignments;
  }

  Future<bool> deletePermissionAssignment({required int id}) async {
    bool success = false;
    try {
      http.Response response = await Request.instance
          .deleteRequest(path: "${path+id.toString()}/", headers: headers, body: {}, param: {});
      if (response.statusCode == 200) {
        success = true;
      }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
    } catch (e) {
      throw e.toString();
    }
    return success;
  }

  Future<Map<dynamic, dynamic>> addPermissionAssignment(
      {required int assignerId,
      required List<int> opsId,
      required int roleId}) async {
    Map<dynamic, dynamic> statusResponse = {};
    Map body = {
      "role_id": roleId,
      "permissions": opsId,
      "assigner_user_id": assignerId
    };
    try {
      http.Response response = await Request.instance
          .postRequest(param: {}, path: path, body: body, headers: headers);
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
}
