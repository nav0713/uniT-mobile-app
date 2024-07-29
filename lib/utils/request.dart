import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:unit2/utils/text_container.dart';
import 'package:unit2/utils/urls.dart';

class Request {
  var client = http.Client();
  static final Request _instance = Request();
  static Request get instance => _instance;
  int requestTimeout = 35;
  String host = Url.instance.host();
String prefixHost = Url.instance.prefixHost();
  Future<http.Response> getRequest(
      {required String path,
      Map<String, String>? headers,
      Map<String, String>? param}) async {
    http.Response response;
    try {
      Uri uri = Uri.parse("$prefixHost$host$path").replace(queryParameters: param,);
      response = await client.get(uri,headers: headers).timeout(Duration(seconds: requestTimeout));
      // response = await http.get(Uri.https(host, path, param), headers: headers)
      //     .timeout(Duration(seconds: requestTimeout));
    } on TimeoutException catch (_) {
      // Fluttertoast.showToast(1
      //   msg: timeoutError,
      //   toastLength: Toast.LENGTH_LONG,
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.black,
      // );
      throw (timeoutError);
    } on SocketException catch (_) {
      // Fluttertoast.showToast(
      //   msg: timeoutError,
      //   toastLength: Toast.LENGTH_LONG,
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.black,
      // );
      throw (timeoutError);
    } on FormatException catch (_) {
      throw const FormatException(formatError);
    } on HttpException catch (_) {
      throw const HttpException(httpError);
    } on Error catch (e) {
      debugPrint("get request error: $e");
      // Fluttertoast.showToast(
      //   msg: onError,
      //   toastLength: Toast.LENGTH_LONG,
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.black,
      // );
      throw (onError);
    }
    return response;
  }

  Future<http.Response> postRequest(
      {String? path,
      Map<String, String>? headers,
      Map? body,
      Map<String, String>? param}) async {
    http.Response response;
    try {
      Uri uri = Uri.parse("$prefixHost$host$path").replace(queryParameters: param);
      response = await client.post(uri,headers: headers,body: json.encode(body)).timeout(Duration(seconds: requestTimeout));
      // response = await http.post(Uri.https(host, path!, param),
      //         headers: headers, body: jsonEncode(body))
      //     .timeout(Duration(seconds: requestTimeout));
    } on TimeoutException catch (_) {
      // Fluttertoast.showToast(
      //   msg: timeoutError,
      //   toastLength: Toast.LENGTH_LONG,
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.black,
      // );
      throw (timeoutError);
    } on SocketException catch (_) {
      // Fluttertoast.showToast(
      //   msg: timeoutError,
      //   toastLength: Toast.LENGTH_LONG,
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.black,
      // );
      throw (timeoutError);
    } on FormatException catch (_) {
      throw const FormatException(formatError);
    } on HttpException catch (_) {
      throw const HttpException(httpError);
    } on Error catch (e) {
      debugPrint("post request error: $e");
      // Fluttertoast.showToast(
      //   msg: onError,
      //   toastLength: Toast.LENGTH_LONG,
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.black,
      // );
      throw (e.toString());
    }
    return response;
  }

  Future<http.Response> putRequest(
      {required String path,
      required Map<String, String>? headers,
      required Map? body,
      required Map<String, dynamic>? param}) async {
    http.Response response;
    try {
      Uri uri = Uri.parse("$prefixHost$host$path").replace(queryParameters: param);
      response = await client.put(uri,headers: headers,body: json.encode(body)).timeout(Duration(seconds: requestTimeout));
      // response = await http.put(Uri.https(host, path, param),
      //     headers: headers, body: jsonEncode(body));
    } on TimeoutException catch (_) {
      // Fluttertoast.showToast(
      //   msg: timeoutError,
      //   toastLength: Toast.LENGTH_LONG,
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.black,
      // );
      throw (timeoutError);
    } on SocketException catch (_) {
      // Fluttertoast.showToast(
      //   msg: timeoutError,
      //   toastLength: Toast.LENGTH_LONG,
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.black,
      // );
      throw (timeoutError);
    } on FormatException catch (_) {
      throw const FormatException(formatError);
    } on HttpException catch (_) {
      throw const HttpException(httpError);
    } on Error catch (e) {
      debugPrint("post request error: $e");
      // Fluttertoast.showToast(
      //   msg: onError,
      //   toastLength: Toast.LENGTH_LONG,
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.black,
      // );
      throw (e.toString());
    }
    return response;
  }

  Future<http.Response> patch(
      {required String path,
      required Map<String, String>? headers,
      required Map? body,
      required Map<String, dynamic>? param}) async {
    http.Response response;
    try {
      Uri uri = Uri.parse("$prefixHost$host$path").replace(queryParameters: param);
      response = await client.patch(uri,headers: headers,body: json.encode(body)).timeout(Duration(seconds: requestTimeout));

    } on TimeoutException catch (_) {
      // Fluttertoast.showToast(
      //   msg: timeoutError,
      //   toastLength: Toast.LENGTH_LONG,
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.black,
      // );
      throw (timeoutError);
    } on SocketException catch (_) {
      // Fluttertoast.showToast(
      //   msg: timeoutError,
      //   toastLength: Toast.LENGTH_LONG,
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.black,
      // );
      throw (timeoutError);
    } on FormatException catch (_) {
      throw const FormatException(formatError);
    } on HttpException catch (_) {
      throw const HttpException(httpError);
    } on Error catch (e) {
      debugPrint("post request error: $e");
      // Fluttertoast.showToast(
      //   msg: onError,
      //   toastLength: Toast.LENGTH_LONG,
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.black,
      // );
      throw (e.toString());
    }
    return response;
  }

  Future<http.Response> deleteRequest(
      {required String path,
      required Map<String, String>? headers,
      required Map? body,
      required Map<String, dynamic>? param}) async {
    http.Response response;
    try {
            Uri uri = Uri.parse("$prefixHost$host$path").replace(queryParameters: param);
            response = await http.delete(uri,headers: headers,body: json.encode(body)).timeout(Duration(seconds: requestTimeout));
    } on TimeoutException catch (_) {
      // Fluttertoast.showToast(
      //   msg: timeoutError,
      //   toastLength: Toast.LENGTH_LONG,
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.black,
      // );
      throw (timeoutError);
    } on SocketException catch (_) {
      // Fluttertoast.showToast(
      //   msg: timeoutError,
      //   toastLength: Toast.LENGTH_LONG,
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.black,
      // );
      throw (timeoutError);
    } on FormatException catch (_) {
      throw const FormatException(formatError);
    } on HttpException catch (_) {
      throw const HttpException(httpError);
    } on Error catch (e) {
      // Fluttertoast.showToast(
      //   msg: onError,
      //   toastLength: Toast.LENGTH_LONG,
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.black,
      // );
      throw (e.toString());
    }
    return response;
  }
}
