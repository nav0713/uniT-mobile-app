import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:unit2/model/offline/offline_profile.dart';

import '../model/profile/basic_information/primary-information.dart';

double screenWidth = 0;
double screenHeight = 0;
double blockSizeHorizontal = 0;
double blockSizeVertical = 0;
double safeAreaHorizontal = 0;
double safeAreaVertical = 0;
double safeBlockHorizontal = 0;
double safeBlockVertical = 0;
const xClientKey = "unitK3CQaXiWlPReDsBzmmwBZPd9Re1z";
const xClientSecret = "unitcYqAN7GGalyz";
 final DateFormat dteFormat2 = DateFormat.yMMMMd('en_US');
  DateFormat dteTimeForm = DateFormat.yMMMMd('en_US').add_jm();

Profile? globalCurrentProfile;
///offline data
bool? globalOfflineAvailable;
OfflineProfile? globalOfflineProfile;
//// hive boxes
Box? CREDENTIALS;
Box? SOS;
Box? OFFLINE;
Box? encryptedBox;
