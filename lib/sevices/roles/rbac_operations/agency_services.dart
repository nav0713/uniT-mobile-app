import 'dart:convert';
import 'package:unit2/utils/global.dart';
import 'package:unit2/utils/request.dart';
import 'package:unit2/utils/urls.dart';
import '../../../model/utils/agency.dart';
import 'package:http/http.dart' as http;

class AgencyServices {
  static final AgencyServices _instance = AgencyServices();
  static AgencyServices get instance => _instance;
  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'X-Client-Key': xClientKey,
    'X-Client-Secret': xClientSecret
  };
  String path = Url.instance.agencies();
  
  Future<List<Agency>> getAgencies() async {
    List<Agency> agencies = [];
    try {
      http.Response response = await Request.instance
          .getRequest(path: path, headers: headers, param: {});
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          for (var element in data['data']) {
            Agency newAgency = Agency.fromJson(element);
            agencies.add(newAgency);
          }
        }
      }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
    } catch (e) {
      throw e.toString();
    }
    return agencies;
  }

  Future<Map<dynamic, dynamic>> add({required Agency agency}) async {
    Map<dynamic, dynamic> statusResponse = {};
    Map body = {
      "name": agency.name,
      "category_id": agency.category!.id,
      "private_entity": agency.privateEntity,
      "contact_info": null,
    };
    String path = Url.instance.postAgencies();
    try {
      http.Response response = await Request.instance
          .postRequest(param: {}, path: path, body: body, headers: headers);
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
