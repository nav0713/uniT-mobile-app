import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart'; 
 
 Future<void> launchInBrowser(String url) async {
    final UrlLauncherPlatform launcher = UrlLauncherPlatform.instance;
    if (!await launcher.launch(
      url,
      useSafariVC: false,
      useWebView: false,
      enableJavaScript: false,
      enableDomStorage: false,
      universalLinksOnly: false,
      headers: <String, String>{},
    )) {
      throw Exception('Could not launch $url');
    }
  }