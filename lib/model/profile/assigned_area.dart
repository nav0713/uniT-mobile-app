import 'package:unit2/model/rbac/assigned_role.dart';

import '../roles/pass_check/assign_role_area_type.dart';

class UserAssignedArea {
     AssignedRole? assignedRole;
     AssignRoleAreaType? assignedRoleAreaType;
     dynamic assignedArea;

    UserAssignedArea({
        required this.assignedRole,
        required this.assignedRoleAreaType,
        required this.assignedArea,
    });

    factory UserAssignedArea.fromJson(Map<String, dynamic> json) => UserAssignedArea(
        assignedRole: json['assigned_role'] == null? null: AssignedRole.fromJson(json["assigned_role"]),
        assignedRoleAreaType: json['assigned_role_area_type'] == null? null : AssignRoleAreaType.fromJson(json["assigned_role_area_type"]),
        assignedArea: json["assigned_area"],
    );

    Map<String, dynamic> toJson() => {
        "assigned_role": assignedRole?.toJson(),
        "assigned_role_area_type": assignedRoleAreaType?.toJson(),
        "assigned_area": assignedArea,
    };
}




