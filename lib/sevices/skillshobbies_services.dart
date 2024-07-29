import 'dart:convert';

import 'package:unit2/utils/request.dart';

import '../model/profile/other_information/skills_and_hobbies.dart';
import '../utils/urls.dart';
import 'package:http/http.dart' as http;

class SkillsHobbiesServices {
  static final SkillsHobbiesServices _instance = SkillsHobbiesServices();
  static SkillsHobbiesServices get instance => _instance;
////GET
  Future<List<SkillsHobbies>> getSkillsHobbies(
      int profileId, String token) async {
    List<SkillsHobbies> skillsAndHobbies = [];
    String authToken = "Token $token";
    String path = "${Url.instance.skillsHobbies()}$profileId/";
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authToken
    };
    try {
      http.Response response = await Request.instance
          .getRequest(path: path, param: {}, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data']['skill_hobby'] != null) {
          data['data']['skill_hobby'].forEach((var hobby) {
            SkillsHobbies skillsHobby = SkillsHobbies.fromJson(hobby);
            skillsAndHobbies.add(skillsHobby);
          });
        }
      }
    } catch (e) {
      throw e.toString();
    }
    return skillsAndHobbies;
  }

////ADD
  Future<Map<dynamic, dynamic>> add(
      {required List<SkillsHobbies> skillsHobbies,
      required int profileId,
      required String token}) async {
    String authToken = "Token $token";
    String path = "${Url.instance.skillsHobbies()}$profileId/";
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authToken
    };
    List<Map<String,dynamic>> skillsHobbiesBody=[];
     for(var element in skillsHobbies){
      skillsHobbiesBody.add({"id":element.id,"name":element.name});
     }
    Map body = {"skill_hobby": skillsHobbiesBody};
    Map<dynamic, dynamic> statusResponse = {};
    try {
      http.Response response = await Request.instance
          .postRequest(path: path, param: {}, headers: headers, body: body);
      if (response.statusCode == 201) {
        Map data = jsonDecode(response.body);
        statusResponse = data;
      } else {
        statusResponse.addAll({'success': false});
      }
    } catch (e) {
      throw e.toString();
    }
    return statusResponse;
  }

  Future<bool> delete(
      {required int profileId,
      required String token,
      required List<SkillsHobbies> skillsHobbies}) async {
    String authToken = "Token $token";
    bool success = false;
    String path = "${Url.instance.skillsHobbies()}$profileId/";
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authToken
    };
       Map<String, dynamic> params = {"force_mode": "true"};

    Map body = {
      "skill_hobby": [{"id":skillsHobbies[0].id, "name":skillsHobbies[0].name}]

    };
    try {
      http.Response response = await Request.instance.deleteRequest(
          path: path, headers: headers, body: body, param: params);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        success = data['success'];
      }
    } catch (e) {
      throw e.toString();
    }
    return success;
  }

  ////GET ALL
  Future<List<SkillsHobbies>> getAllSkillsHobbies() async {
    List<SkillsHobbies> skillsAndHobbies = [];
    String path = Url.instance.getAllSkillsHobbies();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      http.Response response = await Request.instance.getRequest(
        param: {},
        path: path,
        headers: headers,
      );
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          data['data'].forEach((var element) {
            SkillsHobbies skillsHobbies = SkillsHobbies.fromJson(element);
            skillsAndHobbies.add(skillsHobbies);
          });
        }
      }
    } catch (e) {
      throw e.toString();
    }
    return skillsAndHobbies;
  }
}
