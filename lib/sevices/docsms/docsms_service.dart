import 'dart:convert';

import 'package:unit2/utils/request.dart';
import 'package:unit2/utils/urls.dart';
import 'package:http/http.dart' as http;
import '../../model/docsms/document.dart';

class AutoReceiveDocumentServices{
  static final AutoReceiveDocumentServices _instance = AutoReceiveDocumentServices();
  static AutoReceiveDocumentServices get instance => _instance;

  Future<Document?> getDocument(String documentId) async {
    String path = Url.instance.getDocument();
    Document? document;
    Map<String, String> params = {"t1.id": documentId.toString()};
      Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      http.Response response = await Request.instance.getRequest(param: params,path:path,headers:headers);
     
      if (response.statusCode == 200) {
       Map data = json.decode(response.body);
       if(data['message'].toString().toLowerCase() == "data successfully fetched."){
        document = Document.fromJson(data['data']);
       }else{
        document = null;
       }
      }
    }  catch (e) {
      throw (e.toString());
    }
    return document;
  }

}