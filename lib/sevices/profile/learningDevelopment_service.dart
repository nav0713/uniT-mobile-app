import 'dart:convert';

import 'package:unit2/utils/request.dart';

import '../../model/profile/learning_development.dart';
import '../../utils/urls.dart';
import 'package:http/http.dart' as http;

class LearningDevelopmentServices {
  static final LearningDevelopmentServices _instance =
      LearningDevelopmentServices();
  static LearningDevelopmentServices get instance => _instance;

  Future<List<LearningDevelopement>> getLearningDevelopments(
      int profileId, String token) async {
    List<LearningDevelopement> learningsAndDevelopments = [];
    String authToken = "Token $token";
    String path = "${Url.instance.learningAndDevelopments()}$profileId/";
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
        data['data'].forEach((var learnings) {
          LearningDevelopement learningDevelopement =
              LearningDevelopement.fromJson(learnings);
          learningsAndDevelopments.add(learningDevelopement);
        });
      }
    }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
    } catch (e) {
      throw e.toString();
    }
    return learningsAndDevelopments;
  }

  ////Add
  Future<Map<dynamic, dynamic>> add(
      {required LearningDevelopement learningDevelopement,
      required String token,
      required int profileId}) async {
    String authtoken = "Token $token";
    String path = '${Url.instance.learningAndDevelopments()}$profileId/';
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authtoken
    };
    Map<dynamic, dynamic> statusResponse = {};
    try {
      Map body = {
        "training_conduct_id": learningDevelopement.conductedTraining?.id,
        "total_hours_attended":
            learningDevelopement.totalHoursAttended.toString(),
        "sponsor_id": learningDevelopement.sponsoredBy?.id,
        "sponsor_name": learningDevelopement.sponsoredBy?.name,
        "sponsor_category": learningDevelopement.sponsoredBy?.category?.id,
        "sponsor_private": learningDevelopement.sponsoredBy?.privateEntity,
        "training_id": learningDevelopement.conductedTraining?.title?.id,
        "training_title": learningDevelopement.conductedTraining?.title?.title,
        "topic_id": learningDevelopement.conductedTraining?.topic?.id,
        "topic_title": learningDevelopement.conductedTraining?.topic?.title,
        "conductor_id": learningDevelopement.conductedTraining?.conductedBy?.id,
        "conductor_name":
            learningDevelopement.conductedTraining?.conductedBy?.name,
        "conductor_category":
            learningDevelopement.conductedTraining?.conductedBy?.category?.id!,
        "conductor_private":
            learningDevelopement.conductedTraining?.conductedBy?.privateEntity,
        "venue_city_municipality": learningDevelopement
            .conductedTraining?.venue?.cityMunicipality?.code,
        "venue_barangay":
            learningDevelopement.conductedTraining?.venue?.barangay?.code,
        "learning_development_type":
            learningDevelopement.conductedTraining?.learningDevelopmentType?.id,
        "from_date":
            learningDevelopement.conductedTraining?.fromDate?.toString(),
        "to_date": learningDevelopement.conductedTraining?.toDate?.toString(),
        "total_hours": learningDevelopement.conductedTraining?.totalHours,
        "locked": false,
        "venue_country":
            learningDevelopement.conductedTraining!.venue!.country!.id
      };
      http.Response response = await Request.instance
          .postRequest(path: path, param: {}, body: body, headers: headers);
      if (response.statusCode == 201) {
        Map data = jsonDecode(response.body);
        statusResponse = data;
      } else {
        statusResponse.addAll({'success': false});
      }
      return statusResponse;
    } catch (e) {
      throw e.toString();
    }
  }

  ////Add
  Future<Map<dynamic, dynamic>> update(
      {required LearningDevelopement learningDevelopement,
      required String token,
      required int profileId}) async {
    String authtoken = "Token $token";
    String path = '${Url.instance.learningAndDevelopments()}$profileId/';
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authtoken
    };
    Map<dynamic, dynamic> statusResponse = {};
    try {
      Map body = {
        "training_conduct_id": learningDevelopement.conductedTraining?.id,
        "total_hours_attended":
            learningDevelopement.totalHoursAttended.toString(),
        "sponsor_id": learningDevelopement.sponsoredBy?.id,
        "sponsor_name": learningDevelopement.sponsoredBy?.name,
        "sponsor_category": learningDevelopement.sponsoredBy?.category?.id,
        "sponsor_private": learningDevelopement.sponsoredBy?.privateEntity,
        "training_id": learningDevelopement.conductedTraining?.title?.id,
        "training_title": learningDevelopement.conductedTraining?.title?.title,
        "topic_id": learningDevelopement.conductedTraining?.topic?.id,
        "topic_title": learningDevelopement.conductedTraining?.topic?.title,
        "conductor_id": learningDevelopement.conductedTraining?.conductedBy?.id,
        "conductor_name":
            learningDevelopement.conductedTraining?.conductedBy?.name,
        "conductor_category":
            learningDevelopement.conductedTraining?.conductedBy?.category?.id!,
        "conductor_private":
            learningDevelopement.conductedTraining?.conductedBy?.privateEntity,
        "venue_city_municipality": learningDevelopement
            .conductedTraining?.venue?.cityMunicipality?.code,
        "venue_barangay":
            learningDevelopement.conductedTraining?.venue?.barangay?.code,
        "learning_development_type":
            learningDevelopement.conductedTraining?.learningDevelopmentType?.id,
        "from_date":
            learningDevelopement.conductedTraining?.fromDate?.toString(),
        "to_date": learningDevelopement.conductedTraining?.toDate?.toString(),
        "total_hours": learningDevelopement.conductedTraining?.totalHours,
        "locked": learningDevelopement.conductedTraining?.locked,
        "venue_country":
            learningDevelopement.conductedTraining!.venue!.country!.id
      };
      http.Response response = await Request.instance
          .putRequest(path: path, param: {}, body: body, headers: headers);
      if (response.statusCode == 201) {
        Map data = jsonDecode(response.body);
        statusResponse = data;
      } else {
        statusResponse.addAll({'success': false});
      }
      return statusResponse;
    } catch (e) {
      throw e.toString();
    }
  }

  ////Delete
  Future<bool> delete(
      {required int profileId,
      required String token,
      required int? sponsorId,
      required double totalHours,
      required int trainingId}) async {
    bool? success;
    Map<String, dynamic> params = {"force_mode": "true"};
    String authToken = "Token $token";
    String path = '${Url.instance.learningAndDevelopments()}$profileId/';
    Map body = {
      "sponsor_id": sponsorId,
      "total_hours_attended": totalHours,
      "training_conduct_id": trainingId
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': authToken
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
      throw e.toString();
    }
    return success!;
  }

  Future<List<ConductedTraining>> getConductedTrainings(
      {required String key, required int page}) async {
    List<ConductedTraining> trainings = [];
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    Map<String, String> params = {
      "title__title___ilike": key,
      "page": page.toString()
    };

    String path = Url.instance.conductedTrainings();
    try {
      http.Response response = await Request.instance
          .getRequest(path: path, param: params, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          data['data'].forEach((var element) {
            ConductedTraining training = ConductedTraining.fromJson(element);
            trainings.add(training);
          });
        }
      }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
    } catch (e) {
      throw e.toString();
    }
    return trainings;
  }

  Future<List<LearningDevelopmentType>> getLearningDevelopmentType() async {
    List<LearningDevelopmentType> types = [];
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    String path = Url.instance.learningAndDevelopmentType();
    try {
      http.Response response = await Request.instance
          .getRequest(path: path, param: {}, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          data['data'].forEach((var element) {
            LearningDevelopmentType type =
                LearningDevelopmentType.fromJson(element);
            types.add(type);
          });
        }
      }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
    } catch (e) {
      throw e.toString();
    }
    return types;
  }

  Future<List<LearningDevelopmentType>> getTrainingTopics() async {
    List<LearningDevelopmentType> topics = [];
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    String path = Url.instance.learningAndDevelopmentTopics();
    try {
      http.Response response = await Request.instance
          .getRequest(path: path, param: {}, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['data'] != null) {
          data['data'].forEach((var element) {
            LearningDevelopmentType type =
                LearningDevelopmentType.fromJson(element);
            topics.add(type);
          });
        }
      }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
    } catch (e) {
      throw e.toString();
    }
    return topics;
  }
}
