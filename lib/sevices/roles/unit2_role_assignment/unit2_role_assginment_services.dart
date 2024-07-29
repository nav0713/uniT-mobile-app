// import 'dart:convert';

// import 'package:unit2/model/profile/basic_information/primary-information.dart';
// import 'package:unit2/model/rbac/assigned_role.dart';
// import 'package:unit2/utils/global.dart';
// import 'package:unit2/utils/request.dart';
// import 'package:unit2/utils/urls.dart';
// import 'package:http/http.dart' as http;

// class Unit2RoleAssignmentServices {
//   static final Unit2RoleAssignmentServices _instance =
//       Unit2RoleAssignmentServices();
//   static Unit2RoleAssignmentServices get instance => _instance;
//   Future<Profile?> searchUser(
//       {required String fname,
//       required String lname,
//       required int webUserId}) async {
//     String path = Url.instance.searchUsers();
//     Profile? user;
//     Map<String, String> params = {
//       "profile__last_name__icontains": lname,
//       "profile__first_name__icontains": fname,
//       "page": 1.toString(),
//       "is_paginated": "true",
//       "available_to_user_assigned_area": webUserId.toString()
//     };
//     Map<String, String> headers = {
//       'Content-Type': 'application/json; charset=UTF-8',
//     };
//     try {
//       http.Response response = await Request.instance
//           .getRequest(param: params, path: path, headers: headers);
//       if (response.statusCode == 200) {
//         Map data = jsonDecode(response.body);
//         for (var profile in data['data']) {
//           int websuerId = profile['webuserid'];
//           Profile newUser = Profile.fromJson(profile['profile']);
//           newUser.webuserId = websuerId;
//           user = newUser;
//           break;
//         }
//       }
//       return user;
//     } catch (e) {
//       throw e.toString();
//     }
//   }
//     Future<List<AssignedRole>> getAssignedRoles(
//       {required int assignerId,  required int webUserId}) async {
//     List<AssignedRole> assignedRoles = [];

//     Map<String, String> param = {
//       "user__id": webUserId.toString(),
//       "created_by__id": assignerId.toString()
//     };
//      String path = Url.instance.getRoleAssignment();
//   Map<String, String> headers = {
//     'Content-Type': 'application/json; charset=UTF-8',
//     'X-Client-Key': xClientKey,
//     'X-Client-Secret': xClientSecret
//   };
//     try {
//       http.Response response = await Request.instance
//           .getRequest(param: param, path: path, headers: headers);
//       if (response.statusCode == 200) {
//         Map data = jsonDecode(response.body);
//         if (data['data'] != null) {
//           for (var role in data['data']) {
//             AssignedRole newRole = AssignedRole.fromJson(role);
//             assignedRoles.add(newRole);
//           }
//         }
//       }
//     } catch (e) {
//       throw e.toString();
//     }
//     return assignedRoles;
//   }
// }
