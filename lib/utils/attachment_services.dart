import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:unit2/utils/request.dart';
import 'package:unit2/utils/urls.dart';
import '../model/profile/attachment.dart';
import 'package:http/http.dart' as http;

class AttachmentServices {
  static final AttachmentServices _instance = AttachmentServices();
  static AttachmentServices get instance => _instance;

  Future<List<AttachmentCategory>> getCategories() async {
    List<AttachmentCategory> attachmentCategories = [];
    String path = Url.instance.attachmentCategories();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      http.Response response = await Request.instance
          .getRequest(param: {}, path: path, headers: headers);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        for (var cat in data['data']) {
          AttachmentCategory newCat = AttachmentCategory.fromJson(cat);
          attachmentCategories.add(newCat);
        }
      }
    } catch (e) {
      throw e.toString();
    }
    return attachmentCategories;
  }

  Future<Map<dynamic, dynamic>> attachment(
      {required String categoryId,
      required String module,
      required List<String> paths,
      required String token,
      required String profileId}) async {
    String authtoken = "Token $token";
    Map<String, String> headers = {'Authorization': authtoken};
    String path = Url.instance.attachments();
    Map<dynamic, dynamic>? response = {};
    Map<String, String> body = {
      "attachment_category_id": categoryId.toString(),
      "attachment_module": module.toString()
    };

    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('https://${Url.instance.host()}$path$profileId/'));
      request.fields.addAll(body);
      request.headers.addAll(headers);
      paths.forEach((element) async {
        request.files
            .add(await http.MultipartFile.fromPath('attachments', element));
      });
      http.StreamedResponse res = await request.send();
      final steamResponse = await res.stream.bytesToString();
      Map data = jsonDecode(steamResponse);
      if (res.statusCode == 201) {
        response = data;
      } else {
        String message = data['response']['details'];
        response.addAll({'message': message});
        response.addAll(
          {'success': false},
        );
      }
    } catch (e) {
      throw e.toString();
    }
    return response;
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
    body = {
      "attachment_module": moduleId,
      "attachments": [
        {
          "id": attachment.id,
          "created_at": attachment.createdAt?.toString(),
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

  Future<bool> downloadAttachment(
      {required String filename,
      required String source,
      required String downLoadDir}) async {
    bool success = false;
    var dio = Dio();
    Response response;
    try {
      // if (await requestPermission(Permission.storage)) {
        response = await dio.download(source, "$downLoadDir/$filename");
        if (response.statusCode == 200) {
          success = true;
        // }
      }
      return success;
    } catch (e) {
      throw e.toString();
    }
  }
}
