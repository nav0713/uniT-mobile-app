import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
// import 'package:platform_device_id/platform_device_id.dart';
import 'package:http/http.dart' as http;
import 'package:unit2/utils/request.dart';
import '../../model/sos/session.dart';
import '../../utils/urls.dart';

class SosService{
  static final SosService _instance = SosService();
  static SosService get instance => _instance;
   DateFormat todayFormat = DateFormat("yMdHms");
     Future<LocationData?> getUserLocation() async {
    Location location = Location();
    LocationData? locationData;
    bool serviceEnabled = false;
    PermissionStatus permissionGranted;

     serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
       try{
    LocationData newLocationData = await location.getLocation(); 
    locationData = newLocationData;
    return locationData;
   }catch(e){
    throw e.toString();
   }
  }
    Future<String> initPlatformState() async {
    String? deviceId;
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      // deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }
    return deviceId!;
  }


Future<SessionData> requestSos({required LocationData location, required String mobile1,
      String? mobile2, required String msg, required String requestedDate}) async {
              Map<String, String> body;
    String deviceId = await initPlatformState();
    String sessionToken =
        deviceId.toString() + todayFormat.format(DateTime.now());
    String path = Url.instance.sosRequest();
    SessionData? sessionData;

    if(mobile2 != null){
       body = {
      "mobile_id": deviceId.toString(),
      "mobile_gps":
          "${location.latitude.toString()},${location.longitude.toString()}",
      "mobile1": mobile1,
      "mobile2": mobile2,
      "respondent_message": msg,
      "session_token": sessionToken,
      "pushedbutton_date": requestedDate
    };
    }else{
     body = {
      "mobile_id": deviceId.toString(),
      "mobile_gps":
          "${location.latitude.toString()},${location.longitude.toString()}",
      "mobile1": mobile1,
      "respondent_message": msg,
      "session_token": sessionToken,
      "pushedbutton_date": requestedDate
    };
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    try {
      http.Response response = await Request.instance.postRequest(path: path,body: body,headers: headers);
      if (response.statusCode == 201) {
        var body = jsonDecode(response.body);
        SessionData newSessionData = SessionData.fromJson(body['data']);
        sessionData = newSessionData;
      }

    }on Error catch (e) {
      throw (e.toString());
    }
    return sessionData!;
  }


  Future<SessionData> checkAcknowledgement(String sessionToken) async {
    String path =  Url.instance.sosRequest();
    SessionData? sessionData;
    try {
      http.Response response = await Request.instance.getRequest(path: path,param:{"session_token":sessionToken} ); 
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        SessionData newSessionData = SessionData.fromJson(body['data'][0]);
  
          sessionData = newSessionData;

      }
    } on Error
     catch (e) {
      throw (e.toString());
    }
    return sessionData!;
  }
}