import 'dart:convert';
import 'package:unit2/model/utils/position.dart';
import 'package:unit2/utils/global.dart';
import 'package:unit2/utils/request.dart';
import 'package:unit2/utils/urls.dart';
import 'package:http/http.dart' as http;
import '../../../model/rbac/rbac_station.dart';
import '../../../model/rbac/station_type.dart';

class RbacStationServices {
  static final RbacStationServices _instance = RbacStationServices();
  static RbacStationServices get instance => _instance;
    String path = Url.instance.getStation();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'X-Client-Key': xClientKey,
      'X-Client-Secret': xClientSecret
    };
  Future<List<RbacStation>> getStations({required String agencyId}) async {
    List<RbacStation> stations = [];
    Map<String, String> param = {"government_agency_id": agencyId.toString()};
    try {
      http.Response response = await Request.instance
          .getRequest(param: param, path: path, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          for (var station in data['data']) {
            RbacStation area = RbacStation.fromJson(station);
            stations.add(area);
          }
        }
      }
    } catch (e) {
      throw e.toString();
    }
    return stations;
  }
 ////get stations available to user
   Future<List<RbacStation>> getStationsAvailableToUser({required int userId}) async {
    List<RbacStation> stations = [];
    Map<String, String> param = {"user_id": userId.toString()};
    try {
      http.Response response = await Request.instance
          .getRequest(param: param, path: path, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          for (var station in data['data']) {
            RbacStation area = RbacStation.fromJson(station);
            stations.add(area);
          }
        }
      }
    } catch (e) {
      throw e.toString();
    }
    return stations;
  }
  Future<List<StationType>> getStationTypes() async {
    String path = Url.instance.getStationType();
    List<StationType> stationTypes = [];

    try {
      http.Response response = await Request.instance
          .getRequest(path: path, param: {}, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          for (var st in data['data']) {
            StationType stationType = StationType.fromJson(st);
            stationTypes.add(stationType);
          }
        }
      }
    } catch (e) {
      throw e.toString();
    }
    return stationTypes;
  }

  Future<List<PositionTitle>> getPositionTitle() async {
    String path = Url.instance.getPositionTitle();
    List<PositionTitle> positions = [];
    try {
      http.Response response = await Request.instance
          .getRequest(path: path, param: {}, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          for (var pos in data['data']) {
            PositionTitle posTitle = PositionTitle.fromJson(pos);
            positions.add(posTitle);
          }
        }
      }
    } catch (e) {
      throw e.toString();
    }
    return positions;
  }

  Future<Map<dynamic, dynamic>> addStation(
      {required RbacStation station}) async {
    Map<dynamic, dynamic> statusResponse = {};
    String path = Url.instance.postStation();
    try {
          Map body = {
      "station_name": station.stationName,
      "acronym": station.acronym,
      "station_type_id": station.stationType?.id,
      "_station_type_name": station.stationType?.id != null?null:station.stationType?.typeName,
      "parent_station_id": station.parentStation,
      "hierarchy_order_no": station.hierarchyOrderNo,
      "agency_id": station.governmentAgency!.agencyid,
      "is_location_under_parent": station.islocationUnderParent,
      "head_position": station.headPosition,
      "code": station.code,
      "full-code": station.fullcode,
      "main_parent_station_id": station.mainParentStation,
      "description": station.description,
      "ishospital": station.ishospital,
    };
      http.Response response = await Request.instance
          .postRequest(param: {}, body: body, headers: headers,path: path);
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
}
