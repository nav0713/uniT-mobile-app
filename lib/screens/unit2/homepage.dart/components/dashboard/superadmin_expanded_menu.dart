import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:unit2/bloc/rbac/rbac_operations/agency/agency_bloc.dart';
import 'package:unit2/bloc/rbac/rbac_operations/assign_area/assign_area_bloc.dart';
import 'package:unit2/bloc/rbac/rbac_operations/module/module_bloc.dart';
import 'package:unit2/bloc/rbac/rbac_operations/module_objects/module_objects_bloc.dart';
import 'package:unit2/bloc/rbac/rbac_operations/object/object_bloc.dart';
import 'package:unit2/bloc/rbac/rbac_operations/operation/operation_bloc.dart';
import 'package:unit2/bloc/rbac/rbac_operations/permission/permission_bloc.dart';
import 'package:unit2/bloc/rbac/rbac_operations/permission_assignment/permission_assignment_bloc.dart';
import 'package:unit2/bloc/rbac/rbac_operations/role/role_bloc.dart';
import 'package:unit2/bloc/rbac/rbac_operations/role_extend/role_extend_bloc.dart';
import 'package:unit2/bloc/rbac/rbac_operations/role_module/role_module_bloc.dart';
import 'package:unit2/bloc/rbac/rbac_operations/roles_under/roles_under_bloc.dart';
import 'package:unit2/bloc/rbac/rbac_operations/station/station_bloc.dart';
import 'package:unit2/bloc/role_assignment/role_assignment_bloc.dart';
import 'package:unit2/screens/superadmin/assign_area/assign_area_screen.dart';
import 'package:unit2/screens/superadmin/module/module_screen.dart';
import 'package:unit2/screens/superadmin/object/object_screen.dart';
import 'package:unit2/screens/superadmin/operation/operation_screen.dart';
import 'package:unit2/screens/superadmin/permission/permission_screen.dart';
import 'package:unit2/screens/superadmin/permission_assignment/permission_assignment_screen.dart';
import 'package:unit2/screens/superadmin/role/role_screen.dart';
import 'package:unit2/screens/superadmin/role_assignment.dart/role_assignment_screen.dart';
import 'package:unit2/screens/superadmin/role_extend/role_extend_screen.dart';
import 'package:unit2/screens/superadmin/roles_under/assignable_roles.dart';
import 'package:unit2/screens/superadmin/stations/stations_screen.dart';
import 'package:unit2/screens/unit2/homepage.dart/module-screen.dart';
import 'package:unit2/theme-data.dart/btn-style.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/theme-data.dart/form-style.dart';
import '../../../../superadmin/agency/agency_screen.dart';
import '../../../../superadmin/module_objects/module_objects_screen.dart';
import '../../../../superadmin/role_module/role_module_scree.dart';
import './shared_card_label.dart';
import 'dashboard_icon_generator.dart';

class SuperAdminMenu extends StatelessWidget {
  final int id;
  final DisplayCard object;
  final int index;
  final int columnCount;
  const SuperAdminMenu(
      {super.key,
      required this.id,
      required this.object,
      required this.index,
      required this.columnCount});

  @override
  Widget build(BuildContext context) {
    final roleAssignmentKey = GlobalKey<FormBuilderState>();
    final areaKey = GlobalKey<FormBuilderState>();
    return AnimationConfiguration.staggeredGrid(
      position: index,
      columnCount: columnCount,
      child: ScaleAnimation(
        child: FlipAnimation(
          child: Container(
              child: (object.roleName == 'superadmin' ||
                          object.object.name == 'Agency' ||
                          object.object.name == 'Assignable Role' ||
                          object.object.name == 'Role' ||
                          object.object.name == 'Module' ||
                          object.object.name == 'Object' ||
                          object.object.name == 'Operation' ||
                          object.object.name == 'Permission' ||
                          object.object.name == 'Area' ||
                          object.object.name == 'Station' ||
                          object.object.name == 'Purok' ||
                          object.object.name == 'Barangay' ||
                          object.object.name == 'Role Module' ||
                          object.object.name == 'Module Object' ||
                          object.object.name == 'Roles Extend' ||
                          object.object.name == "Role Member") &&
                      object.moduleName == 'superadmin'
                  ? CardLabel(
                      icon: iconGenerator(name: object.object.name!),
                      title: object.object.name!.toLowerCase() == 'role based access control'? 'RBAC': object.object.name!,
                      ontap: () {
                        if (object.object.name == 'Role') {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return BlocProvider(
                              create: (context) => RoleBloc()..add(GetRoles()),
                              child: RbacRoleScreen(
                                id: id,
                              ),
                            );
                          }));
                        }
                        if (object.object.name == 'Operation') {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return BlocProvider(
                              create: (context) =>
                                  OperationBloc()..add(GetOperations()),
                              child: RbacOperationScreen(
                                id: id,
                              ),
                            );
                          }));
                        }
                        if (object.object.name == 'Module') {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return BlocProvider(
                              create: (context) =>
                                  ModuleBloc()..add(GetModule()),
                              child: RbacModuleScreen(
                                id: id,
                              ),
                            );
                          }));
                        }
                        if (object.object.name == 'Object') {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return BlocProvider(
                              create: (context) =>
                                  ObjectBloc()..add(GetObjects()),
                              child: RbacObjectScreen(
                                id: id,
                              ),
                            );
                          }));
                        }
                        if (object.object.name == 'Permission') {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return BlocProvider(
                              create: (context) =>
                                  PermissionBloc()..add(GetPermissions()),
                              child: RbacPermissionScreen(
                                id: id,
                              ),
                            );
                          }));
                        }
                        if (object.object.name == 'Module Object') {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return BlocProvider(
                              create: (context) =>
                                  ModuleObjectsBloc()..add(GetModuleObjects()),
                              child: RbacModuleObjectsScreen(
                                id: id,
                              ),
                            );
                          }));
                        }
                        if (object.object.name == 'Agency') {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return BlocProvider(
                              create: (context) =>
                                  AgencyBloc()..add(GetAgencies()),
                              child: const RbacAgencyScreen(),
                            );
                          }));
                        }
                        if (object.object.name == 'Role Module') {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return BlocProvider(
                              create: (context) =>
                                  RoleModuleBloc()..add(GetRoleModules()),
                              child: RbacRoleModuleScreen(
                                id: id,
                              ),
                            );
                          }));
                        }
                        if (object.object.name == 'Assignable Role') {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return BlocProvider(
                              create: (context) =>
                                  RolesUnderBloc()..add(GetRolesUnder()),
                              child: RbacRoleUnderScreen(
                                id: id,
                              ),
                            );
                          }));
                        }
                        if (object.object.name == 'Roles Extend') {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return BlocProvider(
                              create: (context) =>
                                  RoleExtendBloc()..add(GetRoleExtend()),
                              child: RbacRoleExtendScreen(
                                id: id,
                              ),
                            );
                          }));
                        }
                        if(object.object.name == 'Role Based Access Control'){
                                      Navigator.pushNamed(context, '/rbac');
                        }
                        if(object.object.name == 'Permission Assignment'){
                             Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return BlocProvider(
                              create: (context) =>
                                  PermissionAssignmentBloc()..add(GetPermissionAssignments()),
                              child: RbacPermissionAssignmentScreen(
                                id: id,
                              ),
                            );
                          }));
                        }
                        if (object.object.name == 'Station') {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return BlocProvider(
                              create: (context) => StationBloc()
                                ..add(const GetStations(agencyId: 1)),
                              child: const RbacStationScreen(
                                agencyId: 1,
                              ),
                            );
                          }));
                        }
                        ////////////////////////////////
                        if (object.object.name == 'Area') {
                          Navigator.of(context).pop();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Row(
                                    children: [
                                      const Expanded(
                                          child: Text("Search User")),
                                      IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: const Icon(Icons.close))
                                    ],
                                  ),
                                  content: FormBuilder(
                                      key: areaKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          FormBuilderTextField(
                                            name: "firstname",
                                            validator:
                                                FormBuilderValidators.required(
                                                    errorText:
                                                        "This field is required"),
                                            decoration: normalTextFieldStyle(
                                                "First name", "first name"),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          FormBuilderTextField(
                                            validator:
                                                FormBuilderValidators.required(
                                                    errorText:
                                                        "This field is required"),
                                            name: "lastname",
                                            decoration: normalTextFieldStyle(
                                                "Last name", "last tname"),
                                          ),
                                          const SizedBox(
                                            height: 24,
                                          ),
                                          SizedBox(
                                            height: 60,
                                            width: double.maxFinite,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                if (areaKey.currentState!
                                                    .saveAndValidate()) {
                                                  String fname =
                                                      areaKey
                                                          .currentState!
                                                          .value['firstname'];
                                                  String lname = areaKey
                                                      .currentState!
                                                      .value['lastname'];
                                                  Navigator.of(context).pop();
                                                  Navigator.push(context,
                                                      MaterialPageRoute(builder:
                                                          (BuildContext
                                                              context) {
                                                    return BlocProvider(
                                                      create: (context) =>
                                                          AssignAreaBloc()
                                                            ..add(
                                                              GetAssignArea(
                                                                  firstname:
                                                                      fname,
                                                                  lastname:
                                                                      lname),
                                                            ),
                                                      child:
                                                           RbacAssignedAreaScreen(lname: lname,fname: fname,id: id,),
                                                    );
                                                  }));
                                                }
                                              },
                                              style: mainBtnStyle(primary,
                                                  Colors.transparent, second),
                                              child: const Text("Submit"),
                                            ),
                                          )
                                        ],
                                      )),
                                );
                              });
                        }
                        if (object.object.name == 'Role Member') {
                    
                          showDialog(  
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Row(
                                    children: [
                                      const Expanded(
                                          child: Text("Search User")),
                                      IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: const Icon(Icons.close))
                                    ],
                                  ),
                                  content: FormBuilder(
                                      key: roleAssignmentKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          FormBuilderTextField(
                                            name: "firstname",
                                            validator:
                                                FormBuilderValidators.required(
                                                    errorText:
                                                        "This field is required"),
                                            decoration: normalTextFieldStyle(
                                                "First name", "first name"),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          FormBuilderTextField(
                                            validator:
                                                FormBuilderValidators.required(
                                                    errorText:
                                                        "This field is required"),
                                            name: "lastname",
                                            decoration: normalTextFieldStyle(
                                                "Last name", "last tname"),
                                          ),
                                          const SizedBox(
                                            height: 24,
                                          ),
                                          SizedBox(
                                            height: 60,
                                            width: double.maxFinite,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                if (roleAssignmentKey
                                                    .currentState!
                                                    .saveAndValidate()) {
                                                  String fname =
                                                      roleAssignmentKey
                                                          .currentState!
                                                          .value['firstname'];
                                                  String lname =
                                                      roleAssignmentKey
                                                          .currentState!
                                                          .value['lastname'];
                                                  Navigator.of(context).pop();
                                                  Navigator.push(context,
                                                      MaterialPageRoute(builder:
                                                          (BuildContext
                                                              context) {
                                                    return BlocProvider(
                                                      create: (context) =>
                                                          RoleAssignmentBloc()
                                                            ..add(
                                                              GetAssignedRoles(
                                                                  firstname:
                                                                      fname,
                                                                  lastname:
                                                                      lname),
                                                            ),
                                                      child: RbacRoleAssignment(
                                                        id: id,
                                                        name: fname,
                                                        lname: lname,
                                                      ),
                                                    );
                                                  }));
                                                }
                                              },
                                              style: mainBtnStyle(primary,
                                                  Colors.transparent, second),
                                              child: const Text("Submit"),
                                            ),
                                          )
                                        ],
                                      )),
                                );
                              });
                        }
                      })
                  : Container(
                      color: Colors.black,
                    )),
        ),
      ),
    );
  }
}
