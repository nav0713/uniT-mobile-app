import 'dart:convert';
import 'package:unit2/model/communication/message.dart';
import 'package:unit2/model/communication/message_meta.dart';
import 'package:unit2/utils/request.dart';
import 'package:unit2/utils/urls.dart';
import 'package:http/http.dart' as http;

class MessagesService {
  static final MessagesService _instance = MessagesService();
  static MessagesService get instance => _instance;

  Future<MessageMeta> getAllMessages(
      {required String authToken,
      required int profileId,
      required pages}) async {
    List<Message> messages = [];
     MessageMeta messageMeta = MessageMeta(items: null, messages: messages, pages: null);
    String path = "${Url.instance.getMessages()}$profileId/";
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Token $authToken"
    };
    Map<String, String> params = {"page": pages.toString()};

    try {
    http.Response response = await Request.instance
        .getRequest(param: params, path: path, headers: headers);
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      if (data['data'].length != 0) {
        for (var element in data['data']) {
          Message message = Message.fromJson(element);
          messages.add(message);
        }
        messageMeta = MessageMeta(
            items: data['page_meta']['items'],
            messages: messages,
            pages: data['page_meta']['pages']);
      }
    }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
    } catch (e) {
      throw e.toString();
    }
    return messageMeta;
  }

  Future<MessageUpdateResponse?> acknowledgeMessage(
      {required String authToken,
      required int profileId,
      required,
      required int messageId,
      required String date,
      String? comment}) async {
    MessageUpdateResponse? messageUpdateResponse;
    String path = "${Url.instance.getMessages()}$profileId/";
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Token $authToken"
    };

    Map body = {
      "id": messageId,
      "date_acknowledged": date,
      "comments": comment
    };
    try {
      http.Response response = await Request.instance
          .putRequest(path: path, headers: headers, body: body, param: {});
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        Message message= Message.fromJson(data['data']);
        messageUpdateResponse = MessageUpdateResponse(message: data['message'], responseMessage: message, status: data['status']);
      }else{
             Map data = jsonDecode(response.body);
             throw data['message'];
      }
    } catch (e) {
      throw e.toString();
    }
    return messageUpdateResponse;
  }
}
