 import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:unit2/model/login_data/version_info.dart';
import 'package:system_info2/system_info2.dart';
Future<String> getCPUArchitecture() async {
    String downloadURL = "";
    String cpuArchitecture = SysInfo.kernelArchitecture.name;
    VersionInfo? apkVersion;
      Dio dio = Dio();
    try {
      Response response = await dio.get(apkUrl,
          options: Options(
              receiveTimeout:const Duration(seconds: 25),
              receiveDataWhenStatusError: true,
              responseType: ResponseType.json,
              followRedirects: false,
              validateStatus: (status) {
                return status! < 500;
              }));
      if (response.statusCode == 200) {
        apkVersion = VersionInfo.fromJson(response.data['data']);
        if (cpuArchitecture.toUpperCase() == 'ARM' ||
            cpuArchitecture.toUpperCase() == 'MIPS') {
          downloadURL = apkVersion.armeabiv7aDownloadUrl!;
        } else if (cpuArchitecture.toUpperCase() == 'I686' ||
            cpuArchitecture.toUpperCase() == 'UNKNOWN' ||
            cpuArchitecture.toUpperCase() == 'X86_64') {
          downloadURL = apkVersion.x8664DownloadUrl!;
        } else if (cpuArchitecture.toUpperCase() == 'AARCH64') {
          downloadURL = apkVersion.arm64v8aDownloadUrl!;
        }
      }
    } on TimeoutException catch (_) {
      throw TimeoutException("Connection timeout");
    } on SocketException catch (_) {
      throw const SocketException("Connection timeout");
    } on DioException catch (e) {
      throw e.toString();
    }
    return downloadURL;
  }
