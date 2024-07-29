import 'dart:convert';

import 'package:unit2/model/rbac/permission.dart';
import 'package:unit2/model/rbac/rbac.dart';
import 'package:unit2/utils/request.dart';

import '../../model/profile/basic_information/primary-information.dart';
import '../../model/rbac/new_permission.dart';
import '../../utils/global.dart';
import '../../utils/urls.dart';
import 'package:http/http.dart' as http;

class RbacServices {
  static final RbacServices _instance = RbacServices();
  static RbacServices get instance => _instance;
  Future<List<RBAC>> getModules() async {
    List<RBAC> modules = [];
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'X-Client-Key': xClientKey,
      'X-Client-Secret': xClientSecret
    };
    String path = Url.instance.getModules();
    try {
      http.Response response = await Request.instance
          .getRequest(path: path, headers: headers, param: {});
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        data['data'].forEach((var module) {
          print(module);
          RBAC newModule = RBAC.fromJson(module);
          modules.add(newModule);
        });
      }
    } catch (e) {
      throw e.toString();
    }
    return modules;
  }

  Future<List<RBAC>> getObjects() async {
    List<RBAC> objects = [];
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'X-Client-Key': xClientKey,
      'X-Client-Secret': xClientSecret
    };
    String path = Url.instance.getObject();
    try {
      http.Response response = await Request.instance
          .getRequest(path: path, headers: headers, param: {});
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        data['data'].forEach((var object) {
          RBAC newObject = RBAC.fromJson(object);
          objects.add(newObject);
        });
      }
    } catch (e) {
      throw e.toString();
    }
    return objects;
  }

  Future<List<RBAC>> getRole() async {
    List<RBAC> roles = [];
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'X-Client-Key': xClientKey,
      'X-Client-Secret': xClientSecret
    };
    String path = Url.instance.getRoles();
    try {
      http.Response response = await Request.instance
          .getRequest(path: path, headers: headers, param: {});
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        data['data'].forEach((var role) {
          RBAC newRole = RBAC.fromJson(role);
          roles.add(newRole);
        });
      }
    } catch (e) {
      throw e.toString();
    }
    return roles;
  }

  Future<List<RBACPermission>> getPermission() async {
    List<RBACPermission> permissions = [];
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'X-Client-Key': xClientKey,
      'X-Client-Secret': xClientSecret
    };
    String path = Url.instance.getPersmissions();
    try {
      http.Response response = await Request.instance
          .getRequest(path: path, headers: headers, param: {});
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        data['data'].forEach((var permission) {
          RBACPermission newPermission = RBACPermission.fromJson(permission);
          permissions.add(newPermission);
        });
      }
    } catch (e) {
      throw e.toString();
    }
    return permissions;
  }

  Future<List<RBAC>> getOperations() async {
    List<RBAC> operations = [];
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'X-Client-Key': xClientKey,
      'X-Client-Secret': xClientSecret
    };
    String path = Url.instance.getOperations();
    try {
      http.Response response = await Request.instance
          .getRequest(path: path, headers: headers, param: {});
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        data['data'].forEach((var operation) {
          RBAC newOperation = RBAC.fromJson(operation);
          operations.add(newOperation);
        });
      }
    } catch (e) {
      throw e.toString();
    }
    return operations;
  }

  Future<List<Profile>> searchUser(
      {required int page, required String name, required String token}) async {
    List<Profile> users = [];
    String path = Url.instance.searchUsers();
    String authtoken = "Token $token";
    Map<String, String> params = {
      "profile__last_name__icontains": name,
      "page": page.toString(),
      "is_paginated": "true",
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authtoken
    };

    http.Response response = await Request.instance
        .getRequest(param: params, path: path, headers: headers);
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      data['data'].forEach((profile) {
        int websuerId = profile['webuserid'];
        Profile newUsers = Profile.fromJson(profile['profile']);
        newUsers.webuserId = websuerId;
        users.add(newUsers);
      });
    }

    return users;
  }

  Future<Map<dynamic, dynamic>> assignRBAC(
      {required int assigneeId,
      required int assignerId,
      required RBAC? selectedRole,
      required RBAC? selectedModule,
      required List<int> permissionId,
      required List<NewPermission> newPermissions}) async {
    bool success = false;
    String path = Url.instance.assignRbac();
    Map<dynamic,dynamic> responseStatus = {};
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'X-Client-Key': xClientKey,
      'X-Client-Secret': xClientSecret
    };
    Map body = {
      "assignee_user_id": assigneeId,
      "assigner_user_id": assignerId,
      "role_id": selectedRole?.id,
      "_new_role_name": selectedRole?.name,
      "_new_role_slug": selectedRole?.slug,
      "_new_role_shorthand": selectedRole?.shorthand,
      "module_id": selectedModule?.id,
      "_new_module_name": selectedModule?.name,
      "_new_module_slug": selectedModule?.slug,
      "_new_module_shorthand": selectedModule?.shorthand,
      "_new_module_icon": null,
      "permission_ids": permissionId,
      "_new_permissions": newPermissions,
      "assigned_areas": []
    };
    try {
      http.Response response = await Request.instance
          .postRequest(path: path, param: {}, body: body, headers: headers);
      Map data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        success = true;
        String message = data['message'];
        responseStatus.addAll({"success": success, "message": message});
      } else {
        success = false;
        String message = data['message'];
        responseStatus.addAll({"success": success, "message": message});
      }
    } catch (e) {
      throw e.toString();
    }

    return responseStatus;
  }
}
