import 'dart:convert';

import 'package:unit2/model/login_data/employee_info/employee_info.dart';

import '../../profile/basic_information/primary-information.dart';
import 'login_user.dart';

UserData? userDataFromJson(String str) => UserData.fromJson(json.decode(str));


class UserData {
  UserData({
    this.user,
    this.employeeInfo,
    this.profile,
  });

  UserDataUser? user;
  EmployeeInfo? employeeInfo;
  Profile? profile;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        user: UserDataUser.fromJson(json["user"]),
        employeeInfo: json["employee_info"] == null?null:EmployeeInfo.fromJson(json["employee_info"]),
        profile:Profile.fromJson(json['profile']['basic_information']['primary_information']),
      );

  Map<String, dynamic> toJson() => {
        "user": user!.toJson(),
        "employee_info": employeeInfo!.toJson(),
      };
}

class UserDataUser {
  UserDataUser({
    this.login,
  });

  Login? login;

  factory UserDataUser.fromJson(Map<String, dynamic> json) => UserDataUser(
        login: Login.fromJson(json["login"]),
      );

  Map<String, dynamic> toJson() => {
        "login": login!.toJson(),
      };
}

class Login {
  Login({
    this.dateTime,
    this.token,
    this.user,
  });

  DateTime? dateTime;
  String? token;
  LoginUser? user;

  factory Login.fromJson(Map<String, dynamic> json) => Login(
        dateTime: DateTime.parse(json["date_time"]),
        token: json["token"],
        user: LoginUser.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "date_time": dateTime?.toIso8601String(),
        "token": token,
        "user": user!.toJson(),
      };
}


