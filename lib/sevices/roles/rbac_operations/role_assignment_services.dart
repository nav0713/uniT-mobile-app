import 'dart:convert';

import 'package:unit2/model/rbac/assigned_role.dart';
import 'package:unit2/utils/global.dart';
import 'package:unit2/utils/request.dart';
import 'package:unit2/utils/urls.dart';
import 'package:http/http.dart' as http;
import '../../../model/profile/basic_information/primary-information.dart';

class RbacRoleAssignmentServices {
  static final RbacRoleAssignmentServices _instance =
      RbacRoleAssignmentServices();
  static RbacRoleAssignmentServices get instance => _instance;
  String path = Url.instance.getRoleAssignment();
  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'X-Client-Key': xClientKey,
    'X-Client-Secret': xClientSecret
  };
  Future<List<AssignedRole>> getAssignedRoles(
      {required String firstname, required String lastname}) async {
    List<AssignedRole> assignedRoles = [];

    Map<String, String> param = {
      "user__first_name__icontains": firstname,
      "user__last_name__icontains": lastname
    };
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
      }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
    } catch (e) {
      throw e.toString();
    }
    return assignedRoles;
  }

  Future<bool> deleteAssignedRole({required int roleId}) async {
    bool success = false;
    try {
      http.Response response = await Request.instance.deleteRequest(
          path: '${path + roleId.toString()}/',
          headers: headers,
          body: {},
          param: {});
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

  ////Add
  Future<Map<dynamic, dynamic>> add({
    required int userId,
    required int? assignerId,
    required List<int> roles,
  }) async {
    Map<dynamic, dynamic> statusResponse = {};
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

  Future<Profile?> searchUser(
      {required int page,
      required String name,
      required String lastname}) async {
    String path = Url.instance.searchUsers();
    Profile? user;
    Map<String, String> params = {
      "profile__last_name__icontains": lastname,
      "profile__first_name__icontains": name,
      "page": page.toString(),
      "is_paginated": "true",
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    // try {
      http.Response response = await Request.instance
          .getRequest(param: params, path: path, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        for (var profile in data['data']) {
          int websuerId = profile['webuserid'];
          Profile newUser = Profile.fromJson(profile['profile']);
          newUser.webuserId = websuerId;
          user = newUser;
          break;
        }
      }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
      return user;
    // } catch (e) {
    //   throw e.toString();
    // }
  }
}
