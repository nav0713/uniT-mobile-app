import 'dart:convert';

import 'package:unit2/screens/profile/components/basic_information/profile_other_info.dart';
import 'package:unit2/utils/urls.dart';
import 'package:http/http.dart' as http;

import '../../utils/request.dart';
class ProfileOtherInfoServices{
  static final ProfileOtherInfoServices _instance = ProfileOtherInfoServices();
  
  static ProfileOtherInfoServices get instace => _instance;

  Future<List<ProfileOtherInfo>>getReligions({String? token})async{
    String path = Url.instance.getReligions();
    List<ProfileOtherInfo> religions = [];
       String authToken = "Token $token";
     Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
   'Authorization': authToken
    };
      try {
      http.Response response = await Request.instance
          .getRequest(path: path, headers: headers, param: {});
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          data['data'].forEach((var e) {
            religions.add(ProfileOtherInfo.fromJson(e));
          });
        }
      }
    } catch (e) {
      throw e.toString();
    }
    return religions;
  }
    Future<List<ProfileOtherInfo>>getEthnicity({String? token})async{
    String path = Url.instance.getEthnicity();
    List<ProfileOtherInfo> ethnicity = [];
          String authToken = "Token $token";
     Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
   'Authorization': authToken
    };
      try {
      http.Response response = await Request.instance
          .getRequest(path: path, headers: headers, param: {});
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          data['data'].forEach((var e) {
            ethnicity.add(ProfileOtherInfo.fromJson(e));
          });
        }
      }
    } catch (e) {
      throw e.toString();
    }
    return ethnicity;
  }

   Future<List<ProfileOtherInfo>>getDisability({required token})async{
    String path = Url.instance.getDisability();
    List<ProfileOtherInfo> disabilities = [];
           String authToken = "Token $token";
     Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
   'Authorization': authToken
    };
      try {
      http.Response response = await Request.instance
          .getRequest(path: path, headers: headers, param: {});
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          data['data'].forEach((var e) {
            disabilities.add(ProfileOtherInfo.fromJson(e));
          });
        }
      }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
    } catch (e) {
      throw e.toString();
    }
    return disabilities;
  }
  Future<List<ProfileOtherInfo>>getGenders({required token})async{
    String path = Url.instance.getGenders();
    List<ProfileOtherInfo> genders = [];
           String authToken = "Token $token";
     Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
   'Authorization': authToken
    };
      try {
      http.Response response = await Request.instance
          .getRequest(path: path, headers: headers, param: {});
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          data['data'].forEach((var e) {
            genders.add(ProfileOtherInfo.fromJson(e));
          });
        }
      }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
    } catch (e) {
      throw e.toString();
    }
    return genders;
  }

   Future<List<ProfileOtherInfo>>getIndigency({required String? token})async{
    String path = Url.instance.getIndigency();
    List<ProfileOtherInfo> indigencies = [];
          String authToken = "Token $token";
     Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
   'Authorization': authToken
    };
      try {
      http.Response response = await Request.instance
          .getRequest(path: path, headers: headers, param: {});
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          data['data'].forEach((var e) {
            indigencies.add(ProfileOtherInfo.fromJson(e));
          });
        }
      }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
    } catch (e) {
      throw e.toString();
    }
    return indigencies;
  }


}