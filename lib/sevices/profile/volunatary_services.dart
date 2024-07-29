import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:unit2/utils/request.dart';
import '../../model/profile/voluntary_works.dart';
import '../../utils/urls.dart';

class VoluntaryService {
  static final VoluntaryService _instance = VoluntaryService();
  static VoluntaryService get instance => _instance;

  Future<List<VoluntaryWork>> getVoluntaryWorks(
      int profileId, String token) async {
    List<VoluntaryWork> voluntaryWorks = [];
    String authToken = "Token $token";
    String path = "${Url.instance.getVoluntaryWorks()}$profileId/";
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authToken
    };

    try {
      http.Response response = await Request.instance
          .getRequest(path: path, param: {}, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          data['data'].forEach((var work) {
            VoluntaryWork voluntaryWork = VoluntaryWork.fromJson(work);
            voluntaryWorks.add(voluntaryWork);
          });
        }
      }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
    } catch (e) {
      throw (e.toString());
    }

    return voluntaryWorks;
  }

  Future<Map<dynamic, dynamic>> add(
      {required VoluntaryWork voluntaryWork,
      required int profileId,
      required String token}) async {
    Map<dynamic, dynamic>? responseData = {};
    String authToken = "Token $token";
    String path = "${Url.instance.getVoluntaryWorks()}$profileId/";
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authToken
    };
    Map body = {
      "position_id": voluntaryWork.position?.id,
      "agency_id": voluntaryWork.agency?.id,
      "address_id": voluntaryWork.address?.id,
      "from_date": voluntaryWork.fromDate.toString(),
      "to_date": voluntaryWork.toDate == null?null:voluntaryWork.toDate.toString(),
      "total_hours": voluntaryWork.totalHours,
      "_positionName": voluntaryWork.position!.title,
      "_agencyName": voluntaryWork.agency!.name,
      "_agencyCatId": voluntaryWork.agency!.category!.id,
      "_privateEntity": voluntaryWork.agency!.privateEntity,
      "_citymunCode": voluntaryWork.address?.cityMunicipality?.code,
      "_countryId": voluntaryWork.address?.country?.id
    };
    try {
      http.Response response = await Request.instance
          .postRequest(param: {}, path: path, body: body, headers: headers);
      if (response.statusCode == 201) {
        Map data = jsonDecode(response.body);
        responseData = data;
      } else {
        responseData.addAll({'success': false});
      }
    } catch (e) {
      throw e.toString();
    }
    return responseData;
  }

////update
  Future<Map<dynamic, dynamic>> update(
      {required VoluntaryWork voluntaryWork,
      required int profileId,
      required String token,
      required int oldPosId,
      required int oldAgencyId,
      required String oldFromDate}) async {
    Map<dynamic, dynamic>? responseData = {};
    String authToken = "Token $token";
    String path = "${Url.instance.getVoluntaryWorks()}$profileId/";
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authToken
    };
    Map body = {
      "position_id": voluntaryWork.position?.id,
      "agency_id": voluntaryWork.agency?.id,
      "address_id": voluntaryWork.address!.id,
      "from_date": voluntaryWork.fromDate.toString(),
  "to_date": voluntaryWork.toDate==null?null:voluntaryWork.toDate.toString(),
      "total_hours": voluntaryWork.totalHours,
      "_positionName": voluntaryWork.position!.title,
      "_agencyName": voluntaryWork.agency!.name,
      "_agencyCatId": voluntaryWork.agency!.category!.id,
      "_privateEntity": voluntaryWork.agency!.privateEntity,
      "_citymunCode": voluntaryWork.address?.cityMunicipality?.code,
      "_countryId": voluntaryWork.address!.country!.id,
      "_oldPosId": oldPosId,
      "_oldAgencyId": oldAgencyId,
      "_oldFromDate": oldFromDate
    };
    try {
      http.Response response = await Request.instance
          .putRequest(param: {}, path: path, body: body, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        responseData = data;
      } else {
        responseData.addAll({'success': false});
      }
    } catch (e) {
      throw e.toString();
    }
    return responseData;
  }

  ////delete
  Future<bool> delete(
      {required int agencyId,
      required int positionId,
      required String fromDate,
      required String token,
      required int profileId}) async {
    bool success = false;
    String authToken = "Token $token";
    String path = "${Url.instance.getVoluntaryWorks()}$profileId/";
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authToken
    };
    Map<String, dynamic> params = {"force_mode": "true"};
    Map body = {
      "agency_id": agencyId,
      "position_id": positionId,
      "from_date": fromDate,
    };
    try {
      http.Response response = await Request.instance.deleteRequest(
          path: path, headers: headers, body: body, param: params);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        success = data['success'];
      }
    } catch (e) {
      throw (e.toString());
    }
    return success;
  }
}
