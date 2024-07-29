import 'dart:convert';

import '../../model/profile/basic_information/adress.dart';
import '../../utils/request.dart';
import '../../utils/urls.dart';
import 'package:http/http.dart' as http;

class AddressService {
  static final AddressService _instance = AddressService();
  static AddressService get instance => _instance;
////add
  Future<Map<String, dynamic>> add(
      {required AddressClass address,
      required int categoryId,
      required String? details,
      required int? blockNumber,
      required int? lotNumber,
      required String token,
      required int profileId}) async {
    Map<String, dynamic> response0 = {};
    String authtoken = "Token $token";
    String path = '${Url.instance.addressPath()}$profileId/';
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authtoken
    };
    Map body = {
      "id": address.id,
      "details": details,
      "_addressCatId": categoryId,
      "_areaClass": address.areaClass,
      "_blockNo": blockNumber,
      "_lotNo": lotNumber,
      "_citymunCode": address.cityMunicipality?.code,
      "_brgyCode": address.barangay?.code,
      "_countryId": address.country!.id
    };
    try {
      http.Response response = await Request.instance
          .postRequest(path: path, body: body, headers: headers, param: {});
      if (response.statusCode == 201) {
        Map data = jsonDecode(response.body);
        response0 = data['response'];
          response0.addAll({'data': data['response']['data']});
            response0.addAll(
          {'message': data['response']['message']},
        );
        response0.addAll(
          {'success': true},
        );
      } else {
        Map data = jsonDecode(response.body);
        String message = data['response']['details'];
        response0.addAll({'message': message});
        response0.addAll(
          {'success': false},
        );
      }
      return response0;
    } catch (e) {
      throw e.toString();
    }
  }

  ////delete
  Future<bool> delete(
      {required int addressId,
      required int profileId,
      required String token}) async {
    bool? success;
    String authtoken = "Token $token";
    String path = "${Url.instance.addressPath()}$profileId/";
    Map body = {"id": addressId};
    Map<String, dynamic> params = {"force_mode": "true"};
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authtoken
    };
    try {
      http.Response response = await Request.instance.deleteRequest(
          path: path, headers: headers, body: body, param: params);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        success = data['success'];
      } else {
        success = false;
      }
    } catch (e) {
      throw (e.toString());
    }
    return success!;
  }

  ////update
  Future<Map<String, dynamic>> update(
      {required AddressClass address,
      required int categoryId,
      required String? details,
      required int? blockNumber,
      required int? lotNumber,
      required String token,
      required int profileId}) async {
    Map<String, dynamic> response0 = {};
    String authtoken = "Token $token";
    String path = '${Url.instance.addressPath()}$profileId/';
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authtoken
    };
    Map body = {
      "id": address.id,
      "details": details,
      "_addressCatId": categoryId,
      "_areaClass": address.areaClass,
      "_blockNo": blockNumber,
      "_lotNo": lotNumber,
      "_citymunCode": address.cityMunicipality?.code,
      "_brgyCode": address.barangay?.code,
      "_countryId": address.country!.id
    };
    try {
      http.Response response = await http.patch(
          Uri.parse(
              'https://${Url.instance.host()}${Url.instance.addressPath()}$profileId/'),
          headers: headers,
          body: jsonEncode(<String, dynamic>{
            "id": address.id,
            "details": details,
            "_addressCatId": categoryId,
            "_areaClass": address.areaClass,
            "_blockNo": blockNumber,
            "_lotNo": lotNumber,
            "_citymunCode": address.cityMunicipality?.code,
            "_brgyCode": address.barangay?.code,
            "_countryId": address.country!.id
          }));
       if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        response0 = data['response'];
          response0.addAll({'data': data['response']['data']});
            response0.addAll(
          {'message': data['response']['message']},
        );
        response0.addAll(
          {'success': true},
        );
      } else {
        Map data = jsonDecode(response.body);
        String message = data['response']['details'];
        response0.addAll({'message': message});
        response0.addAll(
          {'success': false},
        );
      }

      return response0;
    } catch (e) {
      throw e.toString();
    }
  }
}
