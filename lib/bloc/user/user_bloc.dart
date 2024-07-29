import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:unit2/model/login_data/user_info/assigned_area.dart';
import 'package:unit2/model/login_data/user_info/role.dart';
import 'package:unit2/model/login_data/user_info/user_data.dart';
import 'package:unit2/model/login_data/version_info.dart';
import 'package:unit2/screens/unit2/login/functions/get_app_version.dart';
import 'package:unit2/sevices/login_service/auth_service.dart';
import 'package:unit2/utils/global.dart';
import '../../utils/scanner.dart';
import '../../utils/text_container.dart';
part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserData? _userData;
  VersionInfo? _versionInfo;
  String? _apkVersion;
  bool save = false;
  String? uuid;
  String? username;
  String? password;
  List<AssignedArea> establishmentPointPersonAssignedAreas = [];
  UserBloc() : super(UserInitial()) {
    //// this event is called when opening the app to check if
    //// there is new app version
    on<GetApkVersion>((event, emit) async {
      const secureStorage = FlutterSecureStorage();
      try {
        emit(SplashScreen());
        save = false;
        if (_versionInfo == null) {
          VersionInfo versionInfo = await AuthService.instance.getVersionInfo();
          _versionInfo = versionInfo;
          //// please remove this for release
          // _versionInfo?.id="1.0.0";
        }
        String apkVersion = await getAppVersion();

        _apkVersion = apkVersion;
        final String? saved = CREDENTIALS?.get('saved');
        try {
          final key = await secureStorage.read(key: 'key');
          final encryptionKeyUint8List = base64Url.decode(key!);
          final encryptedBox = await Hive.openBox('vaultBox',
              encryptionCipher: HiveAesCipher(encryptionKeyUint8List));
          username = encryptedBox.get('username');
          password = encryptedBox.get('password');
        } catch (e) {
          debugPrint(e.toString());
        }

        if (apkVersion != _versionInfo!.id) {
          emit(VersionLoaded(
              versionInfo: _versionInfo,
              apkVersion: _apkVersion,
              username: event.username,
              password: event.password));
        } else if (saved != null) {
          save = true;
          add(UserLogin(username: username, password: password));
        } else {
          emit(VersionLoaded(
              versionInfo: _versionInfo,
              apkVersion: _apkVersion,
              username: event.username,
              password: event.password));
        }
      } catch (e) {
        emit(UserError(
          message: e.toString(),
        ));
      }
    });
////Loading the current version of the app
    on<LoadVersion>((event, emit) {
      username = event.username;
      password = event.password;
      emit(VersionLoaded(
          versionInfo: _versionInfo,
          apkVersion: _apkVersion,
          username: username,
          password: password));
    });
////userlogin
    on<UserLogin>((event, emit) async {
      username = event.username;
      password = event.password;
      try {
        Map<dynamic, dynamic> response = await AuthService.instance
            .webLogin(username: event.username, password: event.password);
        if (response['status'] == true) {
          UserData userData = UserData.fromJson(response['data']);
          Role? estPointPerson;
          if (userData.user?.login?.user?.roles != null &&
              userData.user!.login!.user!.roles!.isNotEmpty) {
            for (var element in userData.user!.login!.user!.roles!) {
              if (element!.name!.toLowerCase() ==
                  'establishment point-person') {
                estPointPerson = element;
              }
            }
            if (estPointPerson != null &&
                estPointPerson.assignedArea!.isNotEmpty) {
              for (var element in estPointPerson.assignedArea!) {
                establishmentPointPersonAssignedAreas.add(element!);
              }
            }
          }

          globalCurrentProfile = userData.profile!;
          emit(UserLoggedIn(
              estPersonAssignedArea: establishmentPointPersonAssignedAreas,
              userData: userData,
              success: true,
              message: response['message'],
              savedCredentials: save));
        } else {
          emit(UserLoggedIn(
              estPersonAssignedArea: establishmentPointPersonAssignedAreas,
              userData: null,
              success: false,
              message: response['message'],
              savedCredentials: save));
        }
      } on TimeoutException catch (_) {
        emit(InternetTimeout(message: timeoutError));
      } on SocketException catch (_) {
        emit(InternetTimeout(message: timeoutError));
      } on Error catch (e) {
        emit(LoginErrorState(message: e.toString()));
      } catch (e) {
        emit(LoginErrorState(message: e.toString()));
      }
    });
    on<UuidLogin>((event, emit) async {
      try {
        Map<dynamic, dynamic> response = await AuthService.instance
            .qrLogin(uuid: event.uuid, password: event.password);
        if (response['status'] == true) {
          UserData userData = UserData.fromJson(response['data']);
          Role? estPointPerson;
          if (userData.user?.login?.user?.roles != null &&
              userData.user!.login!.user!.roles!.isNotEmpty) {
            for (var element in userData.user!.login!.user!.roles!) {
              if (element!.name!.toLowerCase() ==
                  'establishment point-person') {
                estPointPerson = element;
              }
            }
            if (estPointPerson != null &&
                estPointPerson.assignedArea!.isNotEmpty) {
              for (var element in estPointPerson.assignedArea!) {
                establishmentPointPersonAssignedAreas.add(element!);
              }
            }
          }

          globalCurrentProfile = userData.profile!;
          emit(UserLoggedIn(
              estPersonAssignedArea: establishmentPointPersonAssignedAreas,
              userData: userData,
              success: true,
              message: response['message'],
              savedCredentials: save));
        } else {
          emit(UserLoggedIn(
              estPersonAssignedArea: establishmentPointPersonAssignedAreas,
              userData: null,
              success: false,
              message: response['message'],
              savedCredentials: save));
        }
      } on TimeoutException catch (_) {
        emit(InternetTimeout(message: timeoutError));
      } on SocketException catch (_) {
        emit(InternetTimeout(message: timeoutError));
      } on Error catch (e) {
        emit(LoginErrorState(message: e.toString()));
      } catch (e) {
        emit(LoginErrorState(message: e.toString()));
      }
    });
    on<LoadLoggedInUser>((event, emit) {
      emit(UserLoggedIn(
          estPersonAssignedArea: establishmentPointPersonAssignedAreas,
          userData: _userData,
          savedCredentials: save));
    });
    on<GetUuid>((event, emit) async {
      ScanResult result = await QRCodeBarCodeScanner.instance.scanner();
      if (result.rawContent.toString().isNotEmpty) {
        uuid = result.rawContent.toString();
        emit(UuidLoaded(uuid: uuid!));
      }
    });
    on<LoadUuid>((event, emit) {
      emit(UuidLoaded(uuid: uuid!));
    });
  }
}
