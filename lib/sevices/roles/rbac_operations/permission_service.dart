import 'dart:convert';
import 'package:unit2/model/rbac/permission.dart';
import 'package:http/http.dart' as http;
import 'package:unit2/utils/global.dart';
import 'package:unit2/utils/request.dart';
import '../../../utils/urls.dart';

class RbacPermissionServices {
  static final RbacPermissionServices _instance = RbacPermissionServices();
  static RbacPermissionServices get instance => _instance;
    String path = Url.instance.getPersmissions();
  Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'X-Client-Key':xClientKey,
      'X-Client-Secret': xClientSecret
    };
  Future<List<RBACPermission>> getRbacPermission() async {
    List<RBACPermission> permissions = [];
    try {
      http.Response response = await Request.instance
          .getRequest(param: {}, path: path, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          for (var rbac in data['data']) {
            RBACPermission newRbac = RBACPermission.fromJson(rbac);
            permissions.add(newRbac);
          }
        }
      }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
    } catch (e) {
      throw e.toString();
    }

    return permissions;
  }


  ////Add
  Future<Map<dynamic, dynamic>> add({
    required int assignerId,
    required int? objectId,
    required List<int> operationsId,
  }) async {
    Map<dynamic, dynamic> statusResponse = {};
    Map body = {
      "object_id": objectId,
      "operations": operationsId,
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

  Future<bool> deletePermission ({required int permissionId}) async {
    bool success = false;
    try {
      http.Response response = await Request.instance
          .deleteRequest(path: "${path+permissionId.toString()}/", headers: headers, body: {}, param: {});
      if (response.statusCode == 200) {
        success = true;
      }
    } catch (e) {
      throw e.toString();
    }
    return success;
  }
}
