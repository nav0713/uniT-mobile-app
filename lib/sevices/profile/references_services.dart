


import 'dart:convert';

import 'package:unit2/utils/request.dart';

import '../../model/profile/references.dart';
import '../../utils/urls.dart';
import 'package:http/http.dart' as http;
class ReferencesServices{
  static final ReferencesServices _instance = ReferencesServices();
  static ReferencesServices get instace => _instance;

  Future<List<PersonalReference>> getRefences(int profileId, String token)async{

List<PersonalReference> references = [];
     String authToken = "Token $token";
       String path = "${Url.instance.reference()}$profileId/";
           Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authToken
    };
    try{
    http.Response response = await Request.instance.getRequest(path: path,param: {},headers: headers);
    if(response.statusCode == 200){
      Map data = jsonDecode(response.body);
      if(data['data'] != null){
        data['data'].forEach((var ref){
          PersonalReference reference = PersonalReference.fromJson(ref);
          references.add(reference);
        });
      }
    }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
    }catch(e){
      throw e.toString();
    }
    return references;
  }
  Future<Map<dynamic,dynamic>>addReference({required PersonalReference ref, required String token, required int profileId})async{
   String authToken = "Token $token";
       String path = "${Url.instance.reference()}$profileId/";
           Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authToken
    };
    Map<dynamic,dynamic> responseStatus ={};
    bool overseas = ref.address!.country !=null?true:false;
    Map body = {
    "first_name": ref.firstName,
    "middle_name": ref.middleName,
    "last_name": ref.lastName,
    "contact_no":ref.contactNo,
    "_addressCatId": ref.address!.addressCategory!.id,
    "_areaClass": "Village",
    "_citymunCode": overseas?null: ref.address?.cityMunicipality?.code,
    "_brgyCode": overseas?null:ref.address?.barangay?.code,
    "_countryId": overseas?ref.address!.country!.id:175
    };
     try{
      http.Response response = await Request.instance.postRequest(path: path,body: body,param: {},headers: headers);
      if(response.statusCode == 201){
        Map data = jsonDecode(response.body);
      responseStatus = data;
      }else{
        responseStatus.addAll({'success':false});
      }
      return responseStatus;
    }catch(e){
      throw e.toString();
    }
}
Future<Map<dynamic, dynamic>> update({required PersonalReference ref,required String token, required int profileId})async{
  String authToken = "Token $token";
       String path = "${Url.instance.reference()}$profileId/";
           Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authToken
    };
      Map<dynamic,dynamic> responseStatus ={};
    bool overseas = ref.address!.country!.id != 175;
    Map body = {
      "id":ref.id,
          "related_person_id": profileId,
    "first_name": ref.firstName,
    "middle_name": ref.middleName,
    "last_name": ref.lastName,
    "contact_no":ref.contactNo,
    "_addressCatId": ref.address!.addressCategory!.id,
    "_areaClass": "Village",
    "_citymunCode": overseas?null: ref.address?.cityMunicipality?.code,
    "_brgyCode": overseas?null:ref.address?.barangay?.code,
    "_countryId": overseas?ref.address!.country!.id:175
    };
       try{
      http.Response response = await Request.instance.putRequest(path: path,body: body,param: {},headers: headers);
      if(response.statusCode == 200){
        Map data = jsonDecode(response.body);
      responseStatus = data;
      }else{
        responseStatus.addAll({'success':false});
      }
      return responseStatus;
    }catch(e){
      throw e.toString();
    }
}

Future<bool>delete({required int profileId, required String token, required int id })async{
  bool? success;
      String authtoken = "Token $token";
         String path = "${Url.instance.reference()}$profileId/";
       Map<String, dynamic> params = {"force_mode": "true"};
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authtoken
    };
    try{
      http.Response response = await Request.instance.deleteRequest(path: path, headers: headers, body: {"id":id}, param: params);
      if(response.statusCode == 200){
        Map data = jsonDecode(response.body);
        success=data['success'];
      }else{
        success = false;
      }
      return success!;
    }catch(e){
      throw e.toString();
    }

}

}


   
