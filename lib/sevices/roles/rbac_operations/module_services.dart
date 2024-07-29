import 'dart:convert';
import 'package:unit2/model/rbac/rbac.dart';
import 'package:http/http.dart' as http;
import 'package:unit2/utils/global.dart';
import 'package:unit2/utils/request.dart';
import '../../../utils/urls.dart';

class RbacModuleServices {
  static final RbacModuleServices _instance = RbacModuleServices();
  static RbacModuleServices get instance => _instance;
    String path = Url.instance.getModules();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'X-Client-Key':xClientKey,
      'X-Client-Secret':xClientSecret
    };
  Future<List<RBAC>> getRbacModule() async {
    List<RBAC> modules = [];
    try {
      http.Response response = await Request.instance
          .getRequest(param: {}, path: path, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          for (var rbac in data['data']) {
            RBAC newModule = RBAC.fromJson(rbac);
            modules.add(newModule);
          }
        }
      }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
    } catch (e) {
      throw e.toString();
    }

    return modules;
  }
  ////Add
  Future<Map<dynamic, dynamic>> add(
      {required String name,
      required String? slug,
      required String? short,
      required int id}) async {
    Map<dynamic, dynamic> statusResponse = {};
    String? newSlug = slug?.replaceAll(" ", "-");
    Map body = {
      "name": name,
      "slug": newSlug?.toLowerCase(),
      "shorthand": short,
             "fontawesome_icon":"mobile",
      "created_by_id": id,
      "updated_by_id": id
    };
    try {
      http.Response response = await Request.instance
          .postRequest(path: path, body: body, headers: headers);
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

  ////Update
  Future<Map<dynamic, dynamic>> update({
    required int moduleId,
    required String name,
    required String? slug,
    required String? short,
    required int? createdBy,
    required int updatedBy,
  }) async {
    Map<dynamic, dynamic> statusResponse = {};
    String? newSlug = slug?.replaceAll(" ", "-");
    Map body = {
      "name": name,
      "slug": newSlug?.toLowerCase(),
      "shorthand": short,
      "created_by_id": createdBy,
      "updated_by_id": updatedBy,
       "fontawesome_icon":"mobile",
    };
    try {
      http.Response response = await Request.instance
          .putRequest(path: "${path+moduleId.toString()}/", body: body, headers: headers, param: {});
      if (response.statusCode == 200) {
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

  Future<bool> deleteRbacModule({required int moduleId}) async {
    bool success = false;
    try {
      http.Response response = await Request.instance
          .deleteRequest(path: '${path+moduleId.toString()}/', headers: headers, body: {}, param: {});
      if (response.statusCode == 200) {
        success = true;
      }
    } catch (e) {
      throw e.toString();
    }
    return success;
  }
}
