import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unit2/model/roles/pass_check/agency_area_type.dart';
import 'package:unit2/model/roles/pass_check/assign_role_area_type.dart';
import 'package:unit2/model/roles/pass_check/barangay_assign_area.dart';
import 'package:unit2/model/roles/pass_check/passer_info.dart';
import 'package:unit2/screens/unit2/homepage.dart/components/dashboard/dashboard.dart';
import 'package:unit2/utils/global.dart';
import 'package:http/http.dart' as http;
import 'package:unit2/utils/request.dart';
import 'package:unit2/utils/request_permission.dart';
import '../../model/roles/pass_check/pass_check_log.dart';
import '../../model/roles/pass_check/purok_assign_area.dart';
import '../../model/roles/pass_check/station_assign_area.dart';
import '../../utils/urls.dart';

class PassCheckServices {
  static final PassCheckServices _instance = PassCheckServices();
  static PassCheckServices get instance => _instance;

  Future<List<dynamic>> getPassCheckArea(
      {required RoleIdRoleName roleIdRoleName, required int userId}) async {
    String path = Url.instance.getAssignAreas();
    Map<String, String> params = {
      "assigned_role__role__name__icontains": roleIdRoleName.roleName,
      "assigned_role__user__id": userId.toString()
    };
    List<dynamic>? statusResponse;
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'X-Client-Key': xClientKey,
      'X-Client-Secret': xClientSecret
    };
    try {
      http.Response response = await Request.instance
          .getRequest(param: params, headers: headers, path: path);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        AssignRoleAreaType assignRoleAreaType = AssignRoleAreaType.fromJson(
            data['data'][0]['assigned_role_area_type']);
        ////station
        if (assignRoleAreaType.areaTypeName.toLowerCase() == "station") {
          List<ChildStationInfo> assignedArea = [];
          data['data'][0]['assigned_area'].forEach((element) {
            StationAssignArea stationAssignArea =
                StationAssignArea.fromJson(element);
            ChildStationInfo headStation = ChildStationInfo(
                id: stationAssignArea.area!.id,
                stationName: stationAssignArea.area!.stationName,
                acroym: stationAssignArea.area!.acronym,
                motherStation: true);
            ChildStationInfo childStationInfo = ChildStationInfo(
                id: stationAssignArea.area!.id,
                stationName: stationAssignArea.area!.stationName,
                acroym: stationAssignArea.area!.acronym,
                motherStation: false);
            assignedArea.add(headStation);
            assignedArea.add(childStationInfo);
            if (stationAssignArea.area?.childStationInfo != null) {
              for (var element in stationAssignArea.area!.childStationInfo!) {
                ChildStationInfo newStationInfo = ChildStationInfo(
                    id: element.id,
                    stationName: element.stationName,
                    acroym: element.acroym,
                    motherStation: false);
                assignedArea.add(newStationInfo);
              }
            }
          });

          statusResponse = assignedArea;
        }
        ////registration in-chage
        if (assignRoleAreaType.areaTypeName.toLowerCase() ==
            "registration in-charge") {
          List<ChildStationInfo> assignedArea = [];
          data['data'][0]['assigned_area'].forEach((element) {
            StationAssignArea stationAssignArea =
                StationAssignArea.fromJson(element);
            ChildStationInfo headStation = ChildStationInfo(
                id: stationAssignArea.area!.id,
                stationName: stationAssignArea.area!.stationName,
                acroym: stationAssignArea.area!.acronym,
                motherStation: true);
            ChildStationInfo childStationInfo = ChildStationInfo(
                id: stationAssignArea.area!.id,
                stationName: stationAssignArea.area!.stationName,
                acroym: stationAssignArea.area!.acronym,
                motherStation: false);
            assignedArea.add(headStation);
            assignedArea.add(childStationInfo);
            if (stationAssignArea.area?.childStationInfo != null) {
              for (var element in stationAssignArea.area!.childStationInfo!) {
                ChildStationInfo newStationInfo = ChildStationInfo(
                    id: element.id,
                    stationName: element.stationName,
                    acroym: element.acroym,
                    motherStation: false);
                assignedArea.add(newStationInfo);
              }
            }
          });
          statusResponse = assignedArea;
        }
        ////Barangay
        if (assignRoleAreaType.areaTypeName.toLowerCase() == "baranggay") {
          List<BaragayAssignArea> assignedArea = [];
          data['data'][0]['assigned_area'].forEach((var element) {
            BaragayAssignArea baragayAssignArea =
                BaragayAssignArea.fromJson(element['area']);
            assignedArea.add(baragayAssignArea);
          });
          statusResponse = assignedArea;
        }
        ////PUROK
        if (assignRoleAreaType.areaTypeName.toLowerCase() == 'purok') {
          List<PassCheckPurok> assignedArea = [];
          data['data'][0]['assigned_area'].forEach((var element) {
            PassCheckPurok purok = PassCheckPurok.fromJson(element['area']);
            assignedArea.add(purok);
          });
          statusResponse = assignedArea;
        }
        ////AGENCY
        if (assignRoleAreaType.areaTypeName.toLowerCase() == 'agency') {
          List<AgencyAssignedArea> assignedArea = [];
          data['data'][0]['assigned_area'].forEach((var element) {
            AgencyAssignedArea agencyAssignedArea =
                AgencyAssignedArea.fromJson(element);
            assignedArea.add(agencyAssignedArea);
          });
          statusResponse = assignedArea;
        }
      }
    } catch (e) {
      throw e.toString();
    }
    return statusResponse!;
  }

  Future<PasserInfo?> getPasserInfo(
      {required String uuid, required String token}) async {
    PasserInfo? passerInfo;
    String path = Url.instance.getPasserInfo();
    String authtoken = "Token $token";
    Map<String, String> params = {"uuid": uuid};
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authtoken
    };
    try {
      http.Response response = await Request.instance
          .getRequest(param: params, path: path, headers: headers);
      if (response.statusCode == 200) {
        Map body = jsonDecode(response.body);
        passerInfo = PasserInfo.fromJson(body['data'][0]);
      }
    } catch (e) {
      throw (e.toString());
    }
    return passerInfo;
  }

  Future<bool> performPostLogs(
      {required String passerId,
      required int chekerId,
      required String io,
      required bool otherInputs,
      String? destination,
      double? temp,
      int? stationId,
      String? cpId,
      required RoleIdRoleName roleIdRoleName}) async {
    String path = Url.instance.postLogs();
    bool success;
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'X-Client-Key': xClientKey,
      'X-Client-Secret': xClientSecret
    };
    Map body;
    if (otherInputs) {
      if (roleIdRoleName.roleName.toLowerCase() == "security guard" ||
          roleIdRoleName.roleName.toLowerCase() == "qr code scanner") {
        if (io == "i") {
          body = {
            "station_id": stationId,
            "temperature": temp,
            "passer": passerId,
            "checkedby_user_id": chekerId,
            "io": io
          };
        } else {
          body = {
            "station_id": stationId,
            "destination": destination,
            "passer": passerId,
            "checkedby_user_id": chekerId,
            "io": io
          };
        }
      } else {
        if (io == "i") {
          body = {
            "cp_id": cpId,
            "temperature": temp,
            "passer": passerId,
            "checkedby_user_id": chekerId,
            "io": io
          };
        } else {
          body = {
            "cp_id": cpId,
            "destination": destination,
            "passer": passerId,
            "checkedby_user_id": chekerId,
            "io": io
          };
        }
      }
    } else {
      if (roleIdRoleName.roleName.toLowerCase() == "security guard" ||
          roleIdRoleName.roleName.toLowerCase() == "qr code scanner") {
        body = {
          "station_id": stationId,
          "passer": passerId,
          "checkedby_user_id": chekerId,
          "io": io
        };
      } else {
        body = {
          "cp_id": cpId,
          "temperature": temp,
          "passer": passerId,
          "checkedby_user_id": chekerId,
          "io": io
        };
      }
    }
    try {
      http.Response response = await Request.instance
          .postRequest(path: path, headers: headers, body: body, param: {});
      if (response.statusCode == 201) {
        success = true;
      } else {
        success = false;
      }
    } catch (e) {
      throw e.toString();
    }
    return success;
  }

  Future setFailedAudio(AudioPlayer audioPlayer) async {
    AudioCache player = AudioCache();

    final url = await player.load("ScanFailed.mp3");
    audioPlayer.play(AssetSource(url.path));
  }

  Future<List<PassCheckLog>> viewPassCheckLogs({required int webUserId}) async {
    String path = Url.instance.getLogs();
    Map<String, String> params = {
      "for_today_only": "true",
      "checker_info__id": webUserId.toString(),
      "passer_info__familyname__icontains": "",
      "passer_info__givenname__icontains": ""
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'X-Client-Key': xClientKey,
      'X-Client-Secret': xClientSecret
    };
    List<PassCheckLog> logs = [];
    try {
      http.Response response = await Request.instance.getRequest(
        param: params,
        path: path,
        headers: headers,
      );
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        for (var log in data['data']) {
        
          PassCheckLog newlog = PassCheckLog.fromJson(log);
  
          logs.add(newlog);
        }
      }
    } catch (e) {
      throw e.toString();
    }
    return logs;
  }

  Future<List<PassCheckLog>> filterLogs(
      {required int webUserId,
      required String? passerName,
      required String? passerLname,
      required String? startDate,
      required String? endDate}) async {
    String path = Url.instance.getLogs();

    Map<String, String> params = {
      "for_today_only": "true",
      "checker_info__id": webUserId.toString(),
    };
    if (passerName != null) {
      params.addAll({"passer_info__givenname__icontains": passerName});
    }
    if (passerLname != null) {
      params.addAll({"passer_info__familyname__icontains": passerLname});
    }
    if (startDate != null) {
      params.addAll({"time_check__gte": startDate});
    }
    if (endDate != null) {
      params.addAll({"time_check__lte": endDate});
    }
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'X-Client-Key': xClientKey,
      'X-Client-Secret': xClientSecret
    };
    List<PassCheckLog> logs = [];
    try {
      http.Response response = await Request.instance.getRequest(
        param: params,
        path: path,
        headers: headers,
      );
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        for (var log in data['data']) {
          PassCheckLog newlog = PassCheckLog.fromJson(log);
          logs.add(newlog);
        }
      }
    } catch (e) {
      throw e.toString();
    }
    return logs;
  }

  Future<File?> downloadPDFLogs(
      {required int webUserId,
      required String? passerName,
      required String? passerLname,
      required String? startDate,
      required String? endDate}) async {
    String filename = "${DateTime.now()}.pdf";
    Directory directory;
    String? appDocumentPath;
    final String path = Url.instance.getLogs();

  directory = await getApplicationDocumentsDirectory();
            appDocumentPath = directory.path;
    
    if (appDocumentPath.isEmpty) {
    if (await requestPermission(Permission.storage)) {
      directory = await getApplicationDocumentsDirectory();
      appDocumentPath = directory.path;
    }
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'X-Client-Key': xClientKey,
      'X-Client-Secret': xClientSecret
    };
    File? file;
    Map<String, String> params = {
      "for_today_only": "true",
      "checker_info__id": webUserId.toString(),
      "for_pdf": "true"
    };
    if (passerName != null) {
      params.addAll({"passer_info__givenname__icontains": passerName});
    }
    if (passerLname != null) {
      params.addAll({"passer_info__familyname__icontains": passerLname});
    }
    if (startDate != null) {
      params.addAll({"time_check__gte": startDate});
    }
    if (endDate != null) {
      params.addAll({"time_check__lte": endDate});
    }
    try {
      http.Response response = await Request.instance
          .getRequest(path: path, param: params, headers: headers);
      if (response.statusCode == 200) {
        File? newFile = File('$appDocumentPath/$filename');
        if (!await newFile.exists()) {
          await newFile.create();
        }
        await newFile.writeAsBytes(response.bodyBytes);
        file = newFile;
      }
      return file;
    } catch (e) {
      throw e.toString();
    }
  }
}
