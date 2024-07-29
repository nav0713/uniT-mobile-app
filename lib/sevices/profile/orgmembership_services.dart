import 'dart:convert';

import 'package:unit2/utils/request.dart';

import '../../model/profile/other_information/organization_memberships.dart';
import 'package:http/http.dart' as http;

import '../../model/utils/agency.dart';
import '../../utils/urls.dart';

class OrganizationMembershipServices {
  static final OrganizationMembershipServices _instance =
      OrganizationMembershipServices();
  static OrganizationMembershipServices get instance => _instance;

  Future<List<OrganizationMembership>> getOrgMemberships(
      int profileId, String token) async {
    List<OrganizationMembership> orgMemberships = [];
    String authToken = "Token $token";
    String path = "${Url.instance.getOrgMemberShips()}$profileId/";
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
          data['data'].forEach((var org) {
            OrganizationMembership organizationMembership =
                OrganizationMembership.fromJson(org);
            orgMemberships.add(organizationMembership);
          });
        }
      }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
    } catch (e) {
      throw e.toString();
    }
    return orgMemberships;
  }
  Future<Map<dynamic,dynamic>>add({required Agency? agency,required String token, required String profileId})async{
        String authToken = "Token $token";
    String path = "${Url.instance.getOrgMemberShips()}$profileId/";
     Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authToken
    };
        Map<dynamic,dynamic> statusResponse = {};
    Map body = {
      "agency_id": agency?.id,
    "_agencyName": agency!.name,
    "_agencyCatId": agency.category!.id,
    "_privateEntity": agency.privateEntity
    };
   try{
     http.Response response = await Request.instance.postRequest(path: path,body: body,headers: headers,param: {});
     if(response.statusCode == 201){
      Map data = jsonDecode(response.body);
      statusResponse = data;
     }else{
      statusResponse.addAll({"success":false});
     }
   }catch(e){
    throw e.toString();
   }
   return statusResponse;

  }

  Future<bool> delete({required Agency agency, required int profileId, required String token})async{
    bool success = false;
       Map<String, dynamic> params = {"force_mode": "true"};
    String authToken = "Token $token";
        String path = "${Url.instance.getOrgMemberShips()}$profileId/";
        Map body ={
             "agency_id": agency.id
        };
         Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authToken
    };
        try{
          http.Response response = await Request.instance.deleteRequest(path: path, headers: headers, body: body, param: params);
          if(response.statusCode == 200){
            Map data = jsonDecode(response.body);
            success = data["success"];
          }
        }catch(e){
          throw e.toString();
        }
        return success;
  }
}
