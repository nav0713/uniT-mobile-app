import 'package:unit2/model/login_data/employee_info/office.dart';

import '../../profile/basic_information/primary-information.dart';

class EmployeeInfo {
  EmployeeInfo({
    this.employeeId,
    this.empid,
    this.classid,
    this.uuid,
    // this.office,
    // this.profile,
  });

  String? employeeId;
  int? empid;
  String? classid;
  String? uuid;
  // Office? office;
  // Profile? profile;

  factory EmployeeInfo.fromJson(Map<String, dynamic> json) => EmployeeInfo(
        employeeId: json["employee_id"],
        empid: json["empid"],
        classid: json["classid"],
        uuid: json["uuid"],
        // office: json["office"]==null?null:Office.fromJson(json["office"]),
        // profile: json["profile"]==null?null:Profile.fromJson(json["profile"]),
      );

  Map<String, dynamic> toJson() => {
        "employee_id": employeeId,
        "empid": empid,
        "classid": classid,
        "uuid": uuid,
        // "office": office!.toJson(),
        // "profile": profile!.toJson(),
      };
}

