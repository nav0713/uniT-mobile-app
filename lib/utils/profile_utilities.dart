import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:unit2/model/utils/eligibility.dart';
import 'package:unit2/utils/request.dart';
import 'package:unit2/utils/urls.dart';

import '../model/profile/basic_information/contact_information.dart';
import '../model/profile/family_backround.dart';
import '../model/utils/agency.dart';
import '../model/utils/category.dart';
import '../model/utils/position.dart';

class ProfileUtilities {
  static final ProfileUtilities _instance = ProfileUtilities();
  static ProfileUtilities get instance => _instance;

  Future<List<Eligibility>> getEligibilities() async {
    List<Eligibility> eligibilities = [];
    String path = Url.instance.eligibilities();

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      http.Response response = await Request.instance
          .getRequest(path: path, param: {}, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          data['data'].forEach((var eligibility) {
            Eligibility newEligibilities = Eligibility.fromJson(eligibility);
            eligibilities.add(newEligibilities);
          });
        }
      }
    } catch (e) {
      throw (e.toString());
    }
    return eligibilities;
  }

  ////get paginated agencies
  Future<List<Agency>>getPaginatedAgencies({required  key})async{
    List<Agency> agecies = [];
      Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
        String path = Url.instance.getPaginatedAgency();
        Map<String, String> params = {
      "filter": key,
    };
    try{
      http.Response response = await Request.instance.getRequest(path: path,param: params,headers: headers);
     if(response.statusCode == 200){
       Map data = jsonDecode(response.body);
       if(data['data']!=null){
        data['data'].forEach((var element){
          Agency newAgency = Agency.fromJson(element);
          agecies.add(newAgency);
        });
       }
     }
        }catch(e){
      throw e.toString();
    }
    return agecies;
  }

////get agency position
  Future<List<PositionTitle>> getAgencyPosition() async {
    List<PositionTitle> agencyPositions = [];
    String path = Url.instance.getPositions();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      http.Response response = await Request.instance
          .getRequest(param: {}, path: path, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          data['data'].forEach((var agencyPosition) {
            PositionTitle position = PositionTitle.fromJson(agencyPosition);
            agencyPositions.add(position);
          });
        }
      }
    } catch (e) {
      throw (e.toString());
    }
    return agencyPositions;
  }

  ////get agencies
  Future<List<Agency>> getAgecies() async {
    List<Agency> agencies = [];
    String path = Url.instance.getAgencies();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      http.Response response = await Request.instance
          .getRequest(path: path, param: {}, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          data['data'].forEach((var agency) {
            Agency newAgency = Agency.fromJson(agency);
            agencies.add(newAgency);
          });
        }
      }
    } catch (e) {
      throw e.toString();
    }
    return agencies;
  }

  ////get agencies available to user
  Future<List<Agency>> getAgenciesAvailableToUser({required int userId}) async {
    List<Agency> agencies = [];
    String path = Url.instance.getAgencies();
    Map<String,String> params = {"user_id":userId.toString()};
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      http.Response response = await Request.instance
          .getRequest(path: path, param: params, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          data['data'].forEach((var agency) {
            Agency newAgency = Agency.fromJson(agency);
            agencies.add(newAgency);
          });
        }
      }
    } catch (e) {
      throw e.toString();
    }
    return agencies;
  }


////get agency category
  Future<List<Category>> agencyCategory() async {
    List<Category> agencyCategory = [];
    String path = Url.instance.getAgencyCategory();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      http.Response response = await Request.instance
          .getRequest(param: {}, path: path, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          data['data'].forEach((var agency) {
            Category category = Category.fromJson(agency);
            agencyCategory.add(category);
          });
        }
      }
    } catch (e) {
      throw e.toString();
    }
    return agencyCategory;
  }

//// get service type
  Future<List<ServiceType>> getServiceType() async {
    List<ServiceType> serviceTypes = [];
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    String path = Url.instance.getServiceTypes();

    try {
      http.Response response = await Request.instance
          .getRequest(param: {}, path: path, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          for (var element in data['data']) {
            ServiceType newServiceType = ServiceType.fromJson(element);
            serviceTypes.add(newServiceType);
          }
        }
      }
    } catch (e) {
      throw e.toString();
    }
    return serviceTypes;
  }

  //// get relationship type
  Future<List<Relationship>> getRelationshipType() async {
    List<Relationship> relationshipTypes= [];
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    String path = Url.instance.getRelationshipTypes();

    try {
      http.Response response = await Request.instance
          .getRequest(param: {}, path: path, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          for (var element in data['data']) {
            Relationship relationship = Relationship.fromJson(element);
            if(relationship.category=="personal reference"){
            relationshipTypes.add(relationship);
            }

          }
        }
      }
    } catch (e) {
      throw e.toString();
    }
    return relationshipTypes;
  }
}
