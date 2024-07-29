import 'dart:convert';

import 'package:unit2/model/profile/attachment.dart';
import 'package:unit2/model/profile/eligibility.dart';
import 'package:unit2/utils/request.dart';
import 'package:unit2/utils/urls.dart';
import 'package:http/http.dart' as http;

class EligibilityService {
  static final EligibilityService _instance = EligibilityService();
  static EligibilityService get instance => _instance;

  Future<List<EligibityCert>> getEligibilities(
      int profileId, String token) async {
    List<EligibityCert> eligibilities = [];
    String authToken = "Token $token";
    String path = "${Url.instance.getEligibilities()}$profileId/";
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
          data['data'].forEach((var cert) {
            EligibityCert eligibility = EligibityCert.fromJson(cert);
            eligibilities.add(eligibility);
          });
        }
      }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
    } catch (e) {
      throw e.toString();
    }
    return eligibilities;
  }

  Future<bool> delete(
      {required int eligibilityId,
      required int profileId,
      required String token}) async {
    bool? success;
    String authtoken = "Token $token";
    String path = "${Url.instance.deleteEligibility()}$profileId/";
    Map body = {"eligibility_id": eligibilityId};
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

  Future<Map<dynamic, dynamic>> add(
      {required EligibityCert eligibityCert,
      required String token,
      required int profileId}) async {
    Map<dynamic, dynamic>? response0 = {};
    String authtoken = "Token $token";
    String path = '${Url.instance.addEligibility()}$profileId/';
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authtoken
    };

    Map body = {
      'eligibility_id': eligibityCert.eligibility!.id,
      'license_number': eligibityCert.licenseNumber,
      'exam_date': eligibityCert.examDate?.toString(),
      'validity_date': eligibityCert.validityDate?.toString(),
      'rating': eligibityCert.rating,
      '_citymunCode': eligibityCert.examAddress?.cityMunicipality?.code,
      '_countryId': eligibityCert.examAddress?.country!.id
    };
    try {
      http.Response response = await Request.instance
          .postRequest(path: path, body: body, headers: headers, param: {});
      if (response.statusCode == 201) {
        Map data = jsonDecode(response.body);
        response0 = data;
      } else {
        response0.addAll({'success': false});
      }

      return response0;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Map<dynamic, dynamic>> update(
      {required EligibityCert eligibityCert,
      required String token,
      required int profileId,
      required int oldEligibility}) async {
    Map<dynamic, dynamic>? response = {};
    String authtoken = "Token $token";
    String path = '${Url.instance.addEligibility()}$profileId/';
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authtoken
    };

    Map body = {
      'eligibility_id': eligibityCert.eligibility!.id,
      'license_number': eligibityCert.licenseNumber,
      'exam_date': eligibityCert.examDate?.toString(),
      'validity_date': eligibityCert.validityDate?.toString(),
      'rating': eligibityCert.rating,
      '_citymunCode': eligibityCert.examAddress?.cityMunicipality?.code,
      '_countryId': eligibityCert.examAddress?.country!.id,
      '_oldEligibilityId': oldEligibility
    };
    try {
      http.Response res = await Request.instance
          .putRequest(path: path, body: body, headers: headers, param: {});
      if (res.statusCode == 200) {
        Map data = jsonDecode(res.body);
        response = data;
      } else {
        response.addAll({'success': false});
      }

      return response;
    } catch (e) {
      throw e.toString();
    }
  }

 

  Future<bool> deleteAttachment(
      {required Attachment attachment,
      required int moduleId,
      required String profileId,
      required String token}) async {
    bool? success;
    String authtoken = "Token $token";
    String path = "${Url.instance.attachments()}$profileId/";
      Map? body;
    try{
     body = {
      "attachment_module": moduleId,
      attachment: [
        {
          "id": attachment.id,
          "created_at": attachment.createdAt,
          "source": attachment.source,
          "filename": attachment.filename,
          "category": {
            "id": attachment.category?.id,
            "subclass": {
              "id": attachment.category?.subclass?.id,
              "name": attachment.category?.subclass?.name,
              "attachment_class": {
                "id": attachment.category?.subclass?.attachmentClass?.id,
                "name": attachment.category?.subclass?.attachmentClass?.name
              }
            },
            "description": attachment.category?.description
          }
        }
      ]
    };
    }catch(e){
    throw e.toString();
    }

    Map<String, dynamic> params = {"force_mode": "true"};
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authtoken
    };
    try {
    http.Response response = await Request.instance
        .deleteRequest(path: path, headers: headers, body: body, param: params);
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
}
