import 'dart:convert';

import 'package:unit2/model/profile/basic_information/identification_information.dart';
import 'package:http/http.dart' as http;
import '../../utils/request.dart';
import '../../utils/urls.dart';

class IdentificationServices {
  static final IdentificationServices _instance = IdentificationServices();
  static IdentificationServices get instance => _instance;

  Future<Map<dynamic, dynamic>> add(
      {required Identification identification,
      required int profileId,
      required String token}) async {
    Map<dynamic, dynamic>? responseData = {};
    String authToken = "Token $token";
    String path = "${Url.instance.identifications()}$profileId/";
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authToken
    };
    Map body = {
      "agency_id": identification.agency!.id,
      "identification_number": identification.identificationNumber,
      "date_issued": identification.dateIssued == null
          ? null
          : identification.dateIssued.toString(),
      "expiration_date": identification.expirationDate == null
          ? null
          : identification.expirationDate.toString(),
      "as_pdf_reference": identification.asPdfReference,
      "_agencyName": identification.agency!.name,
      "_agencyCatId": identification.agency!.category!.id,
      "_privateEntity": identification.agency!.privateEntity,
      "_citymunCode": identification.issuedAt?.cityMunicipality?.code,
      "_countryId": identification.issuedAt!.country!.id
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

  ////delete
  Future<bool> delete(
      {required int identificationId,
      required String token,
      required int profileId}) async {
    bool success = false;
    String authToken = "Token $token";
    String path = "${Url.instance.identifications()}$profileId/";
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authToken
    };
    Map<String, dynamic> params = {"force_mode": "true"};
    Map body = {
      "id": identificationId,
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

  Future<Map<dynamic, dynamic>> update(
      {required Identification identification,
      required int profileId,
      required String token}) async {
    Map<dynamic, dynamic>? responseData = {};
    String authToken = "Token $token";
    String path = "${Url.instance.identifications()}$profileId/";
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authToken
    };
    Map body = {
      "id":identification.id,
      "agency_id": identification.agency!.id,
      "identification_number": identification.identificationNumber,
      "date_issued": identification.dateIssued == null
          ? null
          : identification.dateIssued.toString(),
      "expiration_date": identification.expirationDate == null
          ? null
          : identification.expirationDate.toString(),
      "as_pdf_reference": identification.asPdfReference,
      "_agencyName": identification.agency!.name,
      "_agencyCatId": identification.agency!.category!.id,
      "_privateEntity": identification.agency!.privateEntity,
      "_citymunCode":identification.issuedAt!.country!.id == 175? identification.issuedAt?.cityMunicipality?.code:null,
      "_countryId": identification.issuedAt!.country!.id
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
}
