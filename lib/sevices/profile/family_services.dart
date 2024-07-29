import 'dart:convert';

import 'package:unit2/utils/request.dart';

import '../../model/profile/family_backround.dart';
import '../../utils/urls.dart';
import 'package:http/http.dart' as http;

class FamilyService {
  static final FamilyService _instance = FamilyService();
  static FamilyService get instance => _instance;

  Future<List<FamilyBackground>> getFamilies(
      int profileId, String token) async {
    List<FamilyBackground> families = [];
    String authToken = "Token $token";
    String path = "${Url.instance.getFamilies()}$profileId/";
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
          data['data'].forEach((var family) {
            FamilyBackground familyBackground =
                FamilyBackground.fromJson(family);
            families.add(familyBackground);
          });
        }
      }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
    } catch (e) {
      throw e.toString();
    }
    return families;
  }

  Future<Map<dynamic, dynamic>> add(
      {required int profileId,
      required String token,
      required int relationshipId,
      required FamilyBackground? family}) async {
    Map<dynamic, dynamic>? response0 = {};
    String authtoken = "Token $token";
    String path = "${Url.instance.getFamilies()}$profileId/";
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authtoken
    };
    Map body = {
      "relation_type_id": relationshipId,
      "company_address": family?.companyAddress,
      "company_contact_number": family?.companyContactNumber,
      "first_name": family!.relatedPerson!.firstName,
      "middle_name": family.relatedPerson!.middleName,
      "last_name": family.relatedPerson!.lastName,
      "name_extension": family.relatedPerson?.nameExtension,
      "birthdate": family.relatedPerson!.birthdate.toString(),
      "sex": family.relatedPerson!.sex,
      "blood_type": family.relatedPerson?.bloodType,
      "civil_status": family.relatedPerson?.civilStatus,
      "height": family.relatedPerson?.heightM,
      "weight": family.relatedPerson?.weightKg,
      "position_id": family.position?.id,
      "agency_id": family.company?.id,
      "_positionName": family.position?.title,
      "_agencyName": family.company?.name,
      "_agencyCatId": family.company?.category?.id,
      "_privateEntity": family.company?.privateEntity,
      "maidenMiddleName": family.relatedPerson?.maidenName?.middleName,
      "maidenLastName": family.relatedPerson?.maidenName?.lastName,
      "gender": family.relatedPerson!.gender,
      "deceased": family.relatedPerson!.deceased,
    };
    try {
      http.Response response = await Request.instance
          .postRequest(param: {}, path: path, body: body, headers: headers);
      if (response.statusCode == 201) {
        Map data = jsonDecode(response.body);
        response0 = data;
      } else {
        response0.addAll({'success': false});
      }
    } catch (e) {
      throw (e.toString());
    }
    return response0;
  }
//// Add Emergency
  Future<Map<dynamic, dynamic>> addEmergency(
      {required int profileId,
      required String token,
      required int relatedPersonId,
      required String? numberMail,
      required int? contactInfoId,
      required String requestType,
      }) async {
    Map<dynamic, dynamic>? response0 = {};
    String authtoken = "Token $token";
    String path = Url.instance.addEmergency();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authtoken
    };
    Map body = { "personid": profileId, "related_personid": relatedPersonId, "request_type": requestType, "number_mail": numberMail, "contactinfoid": contactInfoId };
    try {
      http.Response response = await Request.instance
          .postRequest(param: {}, path: path, body: body, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        response0 = data;
      } else {
        response0.addAll({'success': false});
      }
    } catch (e) {
      throw (e.toString());
    }
    return response0;
  }
  ////Update
  Future<Map<dynamic, dynamic>> update(
      {required int profileId,
      required String token,
      required int relationshipId,
      required FamilyBackground family}) async {
    Map<dynamic, dynamic>? response0 = {};
    String authtoken = "Token $token";
    String path = "${Url.instance.getFamilies()}$profileId/";
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authtoken
    };
    Map body = {
      "relation_type_id": relationshipId,
       "related_person_id": family.relatedPerson!.id,
      "company_address": family.companyAddress,
      "company_contact_number": family.companyContactNumber,
      "first_name": family.relatedPerson!.firstName,
      "middle_name": family.relatedPerson!.middleName!.isEmpty?null:family.relatedPerson!.middleName!,
      "last_name": family.relatedPerson!.lastName,
      "name_extension": family.relatedPerson?.nameExtension,
      "birthdate": family.relatedPerson!.birthdate.toString(),
      "sex": family.relatedPerson!.sex,
      "blood_type": family.relatedPerson?.bloodType,
      "civil_status": family.relatedPerson?.civilStatus,
      "height": family.relatedPerson!.heightM,
      "weight": family.relatedPerson!.weightKg,
      "position_id": family.position?.id,
      "agency_id": family.company?.id,
      "_positionName": family.position?.title,
      "_agencyName": family.company?.name,
      "_agencyCatId": family.company?.category?.id,
      "_privateEntity": family.company?.privateEntity,
      "maidenMiddleName": family.relatedPerson?.maidenName?.middleName,
      "maidenLastName": family.relatedPerson?.maidenName?.lastName,
      "gender": family.relatedPerson!.gender,
      "deceased": family.relatedPerson!.deceased,
    };
    try {
      http.Response response = await Request.instance
          .putRequest(param: {}, path: path, body: body, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        response0 = data;
      } else {
        response0.addAll({'success': false});
      }
    } catch (e) {
      throw (e.toString());
    }
    return response0;
  }
////delete
  Future<bool> delete(
      {required int personRelatedId,
      required int profileId,
      required String token}) async {
    bool? success;
    String authtoken = "Token $token";
    String path = "${Url.instance.getFamilies()}$profileId/";
    Map body = {"related_person_id": personRelatedId};
    Map<String, dynamic> params = {"force_mode": "true"};
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authtoken
    };
    try {
      http.Response response = await Request.instance.deleteRequest(
          path: path, headers: headers, body: body, param: params);
      if (response.statusCode == 200) {
        success = true;
      } else {
        success = false;
      }
    } catch (e) {
      throw (e.toString());
    }
    return success;
  }


}
