import 'package:unit2/model/rbac/rbac_station.dart';
import 'package:unit2/model/roles/pass_check/passer_info.dart';
import 'package:unit2/screens/profile/components/basic_information/profile_other_info.dart';

class PassCheckLog {
    final String? id;
    final DateTime? timeCheck;
    final String? io;
    final String? regcode;
    final String? checkedby;
    final String? passer;
    final String? grantedPass;
    final SecurityPointLocation? securityPointLocation;
    final CheckerInfo? checkerInfo;
    final dynamic checkPoint;
    final PasserInfo? passerInfo;
    final String? brgy;
    final String? cityMunicipality;
    final String? province;

    PassCheckLog({
        required this.id,
        required this.timeCheck,
        required this.io,
        required this.regcode,
        required this.checkedby,
        required this.passer,
        required this.grantedPass,
        required this.securityPointLocation,
        required this.checkerInfo,
        required this.checkPoint,
        required this.passerInfo,
        required this.brgy,
        required this.cityMunicipality,
        required this.province,
    });

    factory PassCheckLog.fromJson(Map<String, dynamic> json) => PassCheckLog(
        id: json["id"],
        timeCheck: json['time_check'] == null?null: DateTime.parse(json["time_check"]),
        io: json["io"],
        regcode: json["regcode"],
        checkedby: json["checkedby"],
        passer: json["passer"],
        grantedPass: json["granted_pass"],
        securityPointLocation: SecurityPointLocation.fromJson(json["security_point_location"]),
        checkerInfo: CheckerInfo.fromJson(json["checker_info"]),
        checkPoint: json["check_point"],
        passerInfo: json['passer_info'] == null?null: PasserInfo.fromJson(json["passer_info"]),
        brgy: json["brgy"],
        cityMunicipality: json["city_municipality"],
        province: json["province"],
    );
    Map<String, dynamic> toJson() => {
        "id": id,
        "time_check": timeCheck?.toIso8601String(),
        "io": io,
        "regcode": regcode,
        "checkedby": checkedby,
        "passer": passer,
        "granted_pass": grantedPass,
        "security_point_location": securityPointLocation?.toJson(),
        "checker_info": checkerInfo?.toJson(),
        "check_point": checkPoint,
        "passer_info": passerInfo?.toJson(),
        "brgy": brgy,
        "city_municipality": cityMunicipality,
        "province": province,
    };
}

class CheckerInfo {
    final int id;
    final String username;
    final String firstName;
    final String lastName;
    final String email;
    final bool isActive;

    CheckerInfo({
        required this.id,
        required this.username,
        required this.firstName,
        required this.lastName,
        required this.email,
        required this.isActive,
    });

    factory CheckerInfo.fromJson(Map<String, dynamic> json) => CheckerInfo(
        id: json["id"],
        username: json["username"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        isActive: json["is_active"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "is_active": isActive,
    };
}


class SecurityPointLocation {
    final String? id;
    final ProfileOtherInfo? securityPointType;
    final RbacStation? station;

    SecurityPointLocation({
        required this.id,
        required this.securityPointType,
        required this.station,
    });

    factory SecurityPointLocation.fromJson(Map<String, dynamic> json) => SecurityPointLocation(
        id: json["id"],
        securityPointType: json["security_point_type"] == null? null: ProfileOtherInfo.fromJson(json["security_point_type"]),
        station:json['station'] == null?null: RbacStation.fromJson(json["station"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "security_point_type": securityPointType?.toJson(),
        "station": station?.toJson(),
    };
}