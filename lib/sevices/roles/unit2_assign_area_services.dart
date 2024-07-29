import 'dart:convert';

import 'package:unit2/model/profile/basic_information/primary-information.dart';
import 'package:unit2/utils/request.dart';
import 'package:unit2/utils/urls.dart';
import 'package:http/http.dart' as http;

import '../../model/rbac/role_under.dart';
import '../../utils/global.dart';

class Uni2AssignAreaServices {
  static final Uni2AssignAreaServices _instance = Uni2AssignAreaServices();
  static Uni2AssignAreaServices get instance => _instance;
  Future<Profile?> searchUser(
      {required int userId,
      required String firstname,
      required String lastname}) async {
    String path = Url.instance.searchUsers();
    Profile? user;
    Map<String, String> params = {
      "profile__last_name__icontains": lastname,
      "profile__first_name__icontains": firstname,
      "available_to_user_assigned_area": userId.toString(),
      "is_paginated": "true",
      "page": "1",
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
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
      }
      return user;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<RolesUnder>> getRolesUnder({required int websuerId}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'X-Client-Key': xClientKey,
      'X-Client-Secret': xClientSecret
    };
    String path = Url.instance.getRolesUnder();
    List<RolesUnder> rolesUnder = [];
    Map<String,String> params = {"user_id":websuerId.toString()};
    try {
      http.Response response = await Request.instance
          .getRequest(param: params, path: path, headers: headers);
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
}
