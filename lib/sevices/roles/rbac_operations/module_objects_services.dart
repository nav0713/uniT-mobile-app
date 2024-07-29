import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:unit2/utils/global.dart';
import '../../../model/rbac/rbac_rbac.dart';
import '../../../utils/request.dart';
import '../../../utils/urls.dart';

class RbacModuleObjectsServices {
  static final RbacModuleObjectsServices _instance =
      RbacModuleObjectsServices();
  static RbacModuleObjectsServices get instance => _instance;
      Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'X-Client-Key': xClientKey,
      'X-Client-Secret':xClientSecret
    };
        String path = Url.instance.getModuleObjects();
  Future<List<ModuleObjects>> getModuleObjects() async {
    List<ModuleObjects> moduleObjects = [];
    try {
      http.Response response = await Request.instance
          .getRequest(param: {}, path: path, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          for (var modObj in data['data']) {
            ModuleObjects newModObj = ModuleObjects.fromJson(modObj);
            moduleObjects.add(newModObj);
          }
        }
      }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
    } catch (e) {
      throw e.toString();
    }
    return moduleObjects;
  }

  Future<Map<dynamic, dynamic>> add({
    required int assignerId,
    required int? moduleId,
    required List<int> objectsId,
  }) async {
    Map<dynamic, dynamic> statusResponse = {};
    Map body = {
      "module_id": moduleId,
      "objects": objectsId,
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

  Future<bool> delete({required int moduleObjectId}) async {
    bool success = false;
    try {
      http.Response response = await Request.instance
          .deleteRequest(path: "${path+moduleObjectId.toString()}/", headers: headers, body: {}, param: {});
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
}
