import 'dart:convert';

import 'package:unit2/model/rbac/assigned_role.dart';
import 'package:unit2/utils/request.dart';
import 'package:unit2/utils/urls.dart';

import 'package:http/http.dart' as http;

import '../../../model/profile/basic_information/primary-information.dart';
import '../../../model/rbac/role_under.dart';

class EstPointPersonRoleAssignment {
  static final EstPointPersonRoleAssignment _instance =
      EstPointPersonRoleAssignment();
  static EstPointPersonRoleAssignment get instance => _instance;
  String xClientKey = "unitK3CQaXiWlPReDsBzmmwBZPd9Re1z";
  String xClientKeySecret = "unitcYqAN7GGalyz";

  Future<List<AssignedRole>> getAssignedRoles({required int webuserId}) async {
    List<AssignedRole> assignedRoles = [];
    String path = Url.instance.getRoleAssignment();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'X-Client-Key': xClientKey,
      'X-Client-Secret': xClientKeySecret
    };
    Map<String, String> param = {"created_by__id": webuserId.toString()};
    try {
      http.Response response = await Request.instance
          .getRequest(param: param, path: path, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          for (var role in data['data']) {
            AssignedRole newRole = AssignedRole.fromJson(role);
            assignedRoles.add(newRole);
          }
        }
      }
    } catch (e) {
      throw e.toString();
    }
    return assignedRoles;
  }

  Future<List<RolesUnder>> getRolesUnder({required int roleId}) async {
    List<RolesUnder> rolesUnder = [];
    String path = Url.instance.getRolesUnder();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'X-Client-Key': xClientKey,
      'X-Client-Secret': xClientKeySecret
    };
    Map<String, String> param = {"role_under_main__id": roleId.toString()};
    try {
      http.Response response = await Request.instance
          .getRequest(param: param, path: path, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          for (var roleUnd in data['data']) {
            RolesUnder newRoleUnder = RolesUnder.fromJson(roleUnd);
            rolesUnder.add(newRoleUnder);
          }
        }
      }
    } catch (e) {
      throw e.toString();
    }
    return rolesUnder;
  }

  Future<List<RolesUnder>> getRoleUnderFilterByUser(
      {required int userId}) async {
    List<RolesUnder> rolesUnder = [];
    String path = Url.instance.getRolesUnder();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'X-Client-Key': xClientKey,
      'X-Client-Secret': xClientKeySecret
    };
    Map<String, String> param = {"user_id": userId.toString()};
    try {
      http.Response response = await Request.instance
          .getRequest(param: param, path: path, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          for (var roleUnd in data['data']) {
            RolesUnder newRoleUnder = RolesUnder.fromJson(roleUnd);
            rolesUnder.add(newRoleUnder);
          }
        }
      }
    } catch (e) {
      throw e.toString();
    }
    return rolesUnder;
  }

  Future<bool> deleteAssignedRole({required int roleId}) async {
    bool success = false;
    String path = "${Url.instance.getRoleAssignment()}$roleId/";
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'X-Client-Key': xClientKey,
      'X-Client-Secret': xClientKeySecret
    };
    try {
      http.Response response = await Request.instance
          .deleteRequest(path: path, headers: headers, body: {}, param: {});
      if (response.statusCode == 200) {
        success = true;
      }
    } catch (e) {
      throw e.toString();
    }
    return success;
  }

  ////Add
  Future<Map<dynamic, dynamic>> add({
    required int userId,
    required int? assignerId,
    required List<int> roles,
  }) async {
    String path = Url.instance.getRoleAssignment();
    Map<dynamic, dynamic> statusResponse = {};
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'X-Client-Key': xClientKey,
      'X-Client-Secret': xClientKeySecret
    };
    Map body = {
      "user_id": userId,
      "roles": roles,
      "assigner_user_id": assignerId,
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

  Future<List<Profile>> searchUser(
      {required String? lastname, required int webUserId}) async {
    String path = Url.instance.searchUsers();
    List<Profile> profiles = [];
    Map<String, String> params;
    if (lastname == null) {
      params = {
        "page": 1.toString(),
        "is_paginated": "true",
        "available_to_user_assigned_area": webUserId.toString()
      };
    } else {
      params = {
        "profile__last_name__icontains": lastname,
        "page": 1.toString(),
        "is_paginated": "true",
        "available_to_user_assigned_area": webUserId.toString()
      };
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    http.Response response = await Request.instance
        .getRequest(param: params, path: path, headers: headers);
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      for (var profile in data['data']) {
        int webId = profile['webuserid'];
        Profile newUser = Profile.fromJson(profile['profile']);
        newUser.webuserId = webId;
        profiles.add(newUser);
        break;
      }
    }

    return profiles;
  }
}
