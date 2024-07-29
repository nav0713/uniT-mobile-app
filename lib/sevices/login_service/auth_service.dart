import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:unit2/model/login_data/version_info.dart';
import 'package:http/http.dart' as http;
import 'package:unit2/utils/request.dart';
import '../../utils/urls.dart';

class AuthService {
  static final AuthService _instance = AuthService();
  static AuthService get instance => _instance;

  Future<VersionInfo> getVersionInfo() async {
    VersionInfo versionInfo = VersionInfo();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'UniT2',
      'X-User': ""
    };
    try {
      String path = Url.instance.latestApk();
      http.Response response = await Request.instance
          .getRequest(path: path, headers: headers, param: {});

      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        versionInfo = VersionInfo.fromJson(data['data']);
      }
    } catch (e) {
      throw (e.toString());
    }
    return versionInfo;
  }

  Future<Map<dynamic, dynamic>> webLogin(
      {String? username, String? password}) async {
    Map<String, String> body = {'username': username!, 'password': password!};
    Map<String, String> baseHeaders = {'Content-Type': 'application/json'};
    Map<dynamic, dynamic> responseStatus = {};
    String path = Url.instance.authentication();
    try {
      http.Response response = await Request.instance
          .postRequest(path: path, param: {}, headers: baseHeaders, body: body);
      Map data = jsonDecode(response.body);
      responseStatus = data;

      return responseStatus;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<Map<dynamic,dynamic>> qrLogin({String? uuid, String? password}) async {

  Map<dynamic, dynamic> responseStatus = {};
    Map<String, dynamic> body = {
      'uuid': uuid!,
      'password': password!,
      "login_only": false,
      "token": false
    };
    Map<String, String> baseHeaders = {'Content-Type': 'application/json'};
    String path = Url.instance.authentication();
    try {
      http.Response response = await Request.instance
          .postRequest(path: path, param: {}, headers: baseHeaders, body: body);
    
        Map data = jsonDecode(response.body);
        responseStatus = data;

    } catch (e) {
      throw (e.toString());
    }
    return responseStatus;
  }
}
