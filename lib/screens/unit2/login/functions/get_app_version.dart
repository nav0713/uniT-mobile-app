import 'package:package_info_plus/package_info_plus.dart';

Future<String> getAppVersion() async{
  String appVersion;
  try{
PackageInfo packageInfo = await PackageInfo.fromPlatform();
appVersion = packageInfo.version;
  }catch(e){
    throw(e.toString());
  }
  return appVersion;

}