import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:unit2/bloc/role/unit2_assign_area/unit2_assign_area_bloc.dart';
import 'package:unit2/bloc/role/unit2_role_assignment/unit2_role_assignment_bloc.dart';
import 'package:unit2/bloc/role/unit2_roles_extend/unit2_roles_extend_bloc.dart';
import 'package:unit2/bloc/role/unit2_roles_under/unit2_assignable_role_bloc.dart';
import 'package:unit2/model/login_data/user_info/assigned_area.dart';
import 'package:unit2/screens/unit2/homepage.dart/components/dashboard/dashboard_icon_generator.dart';
import 'package:unit2/screens/unit2/homepage.dart/components/dashboard/superadmin_expanded_menu.dart';
import 'package:unit2/screens/unit2/homepage.dart/module-screen.dart';
import 'package:unit2/screens/unit2/roles/roles_extend/unit2_roles_extend.dart';
import 'package:unit2/screens/unit2/roles/unit2_admin_operations/unit2_assign_area_screen.dart';
import 'package:unit2/theme-data.dart/btn-style.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/theme-data.dart/form-style.dart';
import '../../../../../bloc/role/pass_check/est_point_person/assign_area/assign_area_agency_bloc.dart';
import '../../../../../bloc/role/pass_check/est_point_person/est_point_person_station/est_point_person_station_bloc.dart';
import '../../../roles/unit2_admin_operations/unit2_agecies.dart';
import '../../../roles/unit2_admin_operations/unit2_role_member_screen.dart';
import '../../../roles/unit2_admin_operations/unit2_role_under_screen.dart';
import '../../../roles/unit2_admin_operations/unit2_station.dart';
import './shared_card_label.dart';

class DashBoard extends StatefulWidget {
  final List<AssignedArea>? estPersonAssignedArea;
  final List<DisplayCard> cards;
  final int userId;
  const DashBoard(
      {super.key,
      required this.cards,
      required this.userId,
      required this.estPersonAssignedArea});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

List<String> finishRoles = [];
List<DisplayCard> unit2Cards = [];
List<DisplayCard> superadminCards = [];
List<DisplayCard> rpassCards = [];
List<DisplayCard> docSmsCards = [];
List<DisplayCard> tempSuperAdminCards = [];
List<DisplayCard> tempUnit2Cards = [];
final areaKey = GlobalKey<FormBuilderState>();

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    setState(() {
      finishRoles.clear();
      unit2Cards.clear();
      superadminCards.clear();
      rpassCards.clear();
      docSmsCards.clear();
      tempSuperAdminCards.clear();
    });
    for (var e in widget.cards) {
      if (e.moduleName == "unit2") {
        if (!finishRoles.contains(e.object.name)) {
          unit2Cards.add(e);
        }
        finishRoles.add(e.object.name!);
      }
      if (e.moduleName == 'superadmin') {
        superadminCards.add(e);
      }
      if (e.moduleName == 'rpass') {
        rpassCards.add(e);
      }
      if (e.moduleName == 'document management') {
        docSmsCards.add(e);
      }
    }
    if (superadminCards.length > 3) {
      tempSuperAdminCards = superadminCards.sublist(0, 4);
    }
    if (unit2Cards.length > 3) {
      tempUnit2Cards = unit2Cards.sublist(0, 4);
    }

    return Container(
      padding:
          const EdgeInsetsDirectional.symmetric(vertical: 24, horizontal: 24),
      child: ListView(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ////unit2 module operations
              Container(
                child: unit2Cards.isEmpty
                    ? const SizedBox()
                    : Text(
                        "Unit2 module operations",
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(
                                fontSize: 16,
                                color: primary,
                                fontWeight: FontWeight.w300),
                      ),
              ),
              SizedBox(
                height: unit2Cards.isEmpty ? 0 : 8,
              ),
              Container(
                child: unit2Cards.isEmpty
                    ? const SizedBox.shrink()
                    : GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 4,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 10,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        children: unit2Cards.length > 3
                            ? tempUnit2Cards.map((
                                e,
                              ) {
                                int index = tempUnit2Cards.indexOf(e);
                                //// if unit2 cards is greater then 3 and the modal menu
                                return AnimationConfiguration.staggeredGrid(
                                  position: index,
                                  columnCount: 3,

                                  child: ScaleAnimation(
                                    child: FlipAnimation(
                                      child: Container(
                                          child: index == 3
                                              ? CardLabel(
                                                  icon: FontAwesome5
                                                      .chevron_circle_right,
                                                  title: "See More",
                                                  ontap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder:
                                                            (BuildContext context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                              "Unit2 Admin Module Operations",
                                                              textAlign:
                                                                  TextAlign.center,
                                                            ),
                                                            content: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize.min,
                                                              children: [
                                                                SizedBox(
                                                                  height: 300,
                                                                  width: double
                                                                      .maxFinite,
                                                                  child:
                                                                      GridView.count(
                                                                          shrinkWrap:
                                                                              true,
                                                                          crossAxisCount:
                                                                              3,
                                                                          crossAxisSpacing:
                                                                              8,
                                                                          mainAxisSpacing:
                                                                              10,
                                                                          physics:
                                                                              const BouncingScrollPhysics(),
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              vertical:
                                                                                  5,
                                                                              horizontal:
                                                                                  5),
                                                                          children:
                                                                              unit2Cards
                                                                                  .map((
                                                                            e,
                                                                          ) {
                                                                            int index =
                                                                                unit2Cards
                                                                                    .indexOf(e);
                                                                            //// if unit2 cards is greater then 3
                                                                            return AnimationConfiguration
                                                                                .staggeredGrid(
                                                                              position:
                                                                                  index,
                                                                              columnCount:
                                                                                  3,
                                                                              child:
                                                                                  ScaleAnimation(
                                                                                child:
                                                                                    FadeInAnimation(
                                                                         
                                                                                  child: Container(
                                                                                      child: (e.roleName == 'qr code scanner' || e.roleName == 'security guard' || e.roleName == 'establishment point-person' || e.roleName == 'registration in-charge' || e.roleName == 'checkpoint in-charge') && e.moduleName == 'unit2'
                                                                                          ? CardLabel(
                                                                                              icon: iconGenerator(name: e.object.name!),
                                                                                              title: e.object.name!.toLowerCase() == 'role based access control'
                                                                                                  ? "RBAC"
                                                                                                  : e.object.name!.toLowerCase() == "person basic information"
                                                                                                      ? "Basic Info"
                                                                                                      : e.object.name!,
                                                                                              ontap: () {
                                                                                                Navigator.pop(context);
                                                                                                if (e.object.name!.toLowerCase() == 'pass check') {
                                                                                                  PassCheckArguments passCheckArguments = PassCheckArguments(roleIdRoleName: RoleIdRoleName(roleId: e.roleId, roleName: e.roleName), userId: widget.userId);
                                                                                                  Navigator.pushNamed(context, '/pass-check', arguments: passCheckArguments);
                                                                                                }
                                                                                                if (e.object.name!.toLowerCase() == 'role based access control') {
                                                                                                  Navigator.pushNamed(context, '/rbac');
                                                                                                }
                                                                                                if (e.object.name!.toLowerCase() == 'agency') {
                                                                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                                                    return BlocProvider(
                                                                                                      create: (context) => AssignAreaAgencyBloc()..add((EstPointPersonGetAgencies(assignedAreas: widget.estPersonAssignedArea))),
                                                                                                      child: const EstPorintPersonAgencyScreen(),
                                                                                                    );
                                                                                                  }));
                                                                                                }
                                      
                                                                                                if (e.object.name!.toLowerCase() == "role member") {
                                                                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                                                    return BlocProvider<Unit2RoleAssignmentBloc>(
                                                                                                      create: (context) => Unit2RoleAssignmentBloc()..add(GetEstPointPersonRolesUnder(userId: widget.userId)),
                                                                                                      child: EstPointPersonRoleAssignmentScreen(
                                                                                                        id: widget.userId,
                                                                                                      ),
                                                                                                    );
                                                                                                  }));
                                                                                                }
                                                                                                if (e.object.name!.toLowerCase() == 'assignable role') {
                                                                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                                                    return BlocProvider<Unit2AssinableRoleBloc>(
                                                                                                      create: (context) => Unit2AssinableRoleBloc()..add(GetUnit2AssignableRoles(userId: widget.userId)),
                                                                                                      child: EstPointPersonRoleUnderScreen(
                                                                                                        id: widget.userId,
                                                                                                      ),
                                                                                                    );
                                                                                                  }));
                                                                                                }
                                                                                                if (e.object.name == "Roles Extend") {
                                                                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                                                    return BlocProvider(
                                                                                                      create: (context) => Unit2RolesExtendBloc()..add((GetUnit2RolesExtend(webUserId: widget.userId))),
                                                                                                      child: Unit2RolesExtendScreen(
                                                                                                        userId: widget.userId,
                                                                                                      ),
                                                                                                    );
                                                                                                  }));
                                                                                                }
                                      
                                                                                                ////Station
                                                                                                if (e.object.name == 'Station') {
                                                                                                  showDialog(
                                                                                                      context: context,
                                                                                                      builder: (BuildContext context) {
                                                                                                        return AlertDialog(
                                                                                                          title: const Text("Select Agency"),
                                                                                                          content: Column(
                                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                                            children: [
                                                                                                              DropdownButtonFormField(
                                                                                                                  isDense: true,
                                                                                                                  decoration: normalTextFieldStyle("select agency", "select agency"),
                                                                                                                  isExpanded: true,
                                                                                                                  items: widget.estPersonAssignedArea!.map((e) {
                                                                                                                    return DropdownMenuItem(
                                                                                                                      value: e,
                                                                                                                      child: FittedBox(child: Text(e.areaName!)),
                                                                                                                    );
                                                                                                                  }).toList(),
                                                                                                                  onChanged: (value) {
                                                                                                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                                                                      return BlocProvider(
                                                                                                                        create: (context) => EstPointPersonStationBloc()
                                                                                                                          ..add(EstPointPersonGetStations(
                                                                                                                            agencyId: value.areaid!,
                                                                                                                          )),
                                                                                                                        child: EstPointPersonStationScreen(
                                                                                                                          agencyId: value!.areaid!,
                                                                                                                        ),
                                                                                                                      );
                                                                                                                    }));
                                                                                                                  })
                                                                                                            ],
                                                                                                          ),
                                                                                                        );
                                                                                                      });
                                                                                                }
                                                                                                if (e.object.name == 'Area') {
                                                                                                  showDialog(
                                                                                                      context: context,
                                                                                                      builder: (BuildContext context) {
                                                                                                        return AlertDialog(
                                                                                                          title: Row(
                                                                                                            children: [
                                                                                                              const Expanded(child: Text("Search User")),
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
                                                                                                                    validator: FormBuilderValidators.required(errorText: "This field is required"),
                                                                                                                    decoration: normalTextFieldStyle("First name", "first name"),
                                                                                                                  ),
                                                                                                                  const SizedBox(
                                                                                                                    height: 8,
                                                                                                                  ),
                                                                                                                  FormBuilderTextField(
                                                                                                                    validator: FormBuilderValidators.required(errorText: "This field is required"),
                                                                                                                    name: "lastname",
                                                                                                                    decoration: normalTextFieldStyle("Last name", "last tname"),
                                                                                                                  ),
                                                                                                                  const SizedBox(
                                                                                                                    height: 24,
                                                                                                                  ),
                                                                                                                  SizedBox(
                                                                                                                    height: 60,
                                                                                                                    width: double.maxFinite,
                                                                                                                    child: ElevatedButton(
                                                                                                                      onPressed: () {
                                                                                                                        if (areaKey.currentState!.saveAndValidate()) {
                                                                                                                          String fname = areaKey.currentState!.value['firstname'];
                                                                                                                          String lname = areaKey.currentState!.value['lastname'];
                                                                                                                          Navigator.of(context).pop();
                                                                                                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                                                                            return BlocProvider(
                                                                                                                              create: (context) => Unit2AssignAreaBloc()
                                                                                                                                ..add(
                                                                                                                                  Unit2GetAssignArea(firstname: fname, lastname: lname, id: widget.userId),
                                                                                                                                ),
                                                                                                                              child: Unit2AssignArea(
                                                                                                                                firstname: fname,
                                                                                                                                lastname: lname,
                                                                                                                                id: widget.userId,
                                                                                                                              ),
                                                                                                                            );
                                                                                                                          }));
                                                                                                                        }
                                                                                                                      },
                                                                                                                      style: mainBtnStyle(primary, Colors.transparent, second),
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
                                                                          }).toList()),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        });
                                                  })
                                              //// unit card is greater than 3 but in not in modal menu
                                              : (e.roleName == 'superadmin' ||
                                                          e.roleName ==
                                                              'qr code scanner' ||
                                                          e.roleName ==
                                                              'security guard' ||
                                                          e.roleName ==
                                                              'establishment point-person' ||
                                                          e.roleName ==
                                                              'registration in-charge' ||
                                                          e.roleName ==
                                                              'checkpoint in-charge') &&
                                                      e.moduleName == 'unit2'
                                                  ? CardLabel(
                                                      icon: iconGenerator(
                                                          name: e.object.name!),
                                                      title: e.object.name!
                                                                  .toLowerCase() ==
                                                              'role based access control'
                                                          ? "RBAC"
                                                          : e.object.name!
                                                                      .toLowerCase() ==
                                                                  "person basic information"
                                                              ? "Basic Info"
                                                              : e.object.name!,
                                                      ontap: () {
                                                        if (e.object.name ==
                                                            "Roles Extend") {
                                                          Navigator.push(context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                            return BlocProvider(
                                                              create: (context) =>
                                                                  Unit2RolesExtendBloc()
                                                                    ..add((GetUnit2RolesExtend(
                                                                        webUserId: widget
                                                                            .userId))),
                                                              child:
                                                                  Unit2RolesExtendScreen(
                                                                userId: widget.userId,
                                                              ),
                                                            );
                                                          }));
                                                        }
                                                        if (e.object.name!
                                                                .toLowerCase() ==
                                                            'assignable role') {
                                                          Navigator.push(context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                            return BlocProvider<
                                                                Unit2AssinableRoleBloc>(
                                                              create: (context) =>
                                                                  Unit2AssinableRoleBloc()
                                                                    ..add(GetUnit2AssignableRoles(
                                                                        userId: widget
                                                                            .userId)),
                                                              child:
                                                                  EstPointPersonRoleUnderScreen(
                                                                id: widget.userId,
                                                              ),
                                                            );
                                                          }));
                                                        }
                                                        if (e.object.name!
                                                                .toLowerCase() ==
                                                            "role member") {
                                                          Navigator.push(context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                            return BlocProvider<
                                                                Unit2RoleAssignmentBloc>(
                                                              create: (context) =>
                                                                  Unit2RoleAssignmentBloc()
                                                                    ..add(GetEstPointPersonRolesUnder(
                                                                        userId: widget
                                                                            .userId)),
                                                              child:
                                                                  EstPointPersonRoleAssignmentScreen(
                                                                id: widget.userId,
                                                              ),
                                                            );
                                                          }));
                                                        }
                                      
                                                        if (e.object.name!
                                                                .toLowerCase() ==
                                                            'pass check') {
                                                          PassCheckArguments
                                                              passCheckArguments =
                                                              PassCheckArguments(
                                                                  roleIdRoleName:
                                                                      RoleIdRoleName(
                                                                          roleId: e
                                                                              .roleId,
                                                                          roleName: e
                                                                              .roleName),
                                                                  userId:
                                                                      widget.userId);
                                                          Navigator.pushNamed(
                                                              context, '/pass-check',
                                                              arguments:
                                                                  passCheckArguments);
                                                        }
                                                        if (e.object.name!
                                                                .toLowerCase() ==
                                                            'role based access control') {
                                                          Navigator.pushNamed(
                                                              context, '/rbac');
                                                        }
                                      
                                                        if (e.object.name!
                                                                .toLowerCase() ==
                                                            'agency') {
                                                          Navigator.push(context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                            return BlocProvider(
                                                              create: (context) =>
                                                                  AssignAreaAgencyBloc()
                                                                    ..add((EstPointPersonGetAgencies(
                                                                        assignedAreas:
                                                                            widget
                                                                                .estPersonAssignedArea))),
                                                              child:
                                                                  const EstPorintPersonAgencyScreen(),
                                                            );
                                                          }));
                                                        }
                                                      })
                                                  : Container(
                                                      color: Colors.black,
                                                    )),
                                    ),
                                  ),
                                );
                              }).toList()
                            : unit2Cards.map((
                                e,
                              ) {
                                int index = tempUnit2Cards.indexOf(e);
                                ////if unit2 cards is Less than 3
                                return AnimationConfiguration.staggeredGrid(
                                  position: index,
                                  columnCount: 3,
                                  child: ScaleAnimation(
                                    child: FlipAnimation(

                                      child: Container(
                                          child: (e.roleName == 'superadmin' ||
                                                      e.roleName ==
                                                          'qr code scanner' ||
                                                      e.roleName ==
                                                          'security guard' ||
                                                      e.roleName ==
                                                          'establishment point-person' ||
                                                      e.roleName ==
                                                          'registration in-charge') &&
                                                  e.moduleName == 'unit2'
                                              ? CardLabel(
                                                  icon: iconGenerator(
                                                      name: e.object.name!),
                                                  title: e.object.name!
                                                              .toLowerCase() ==
                                                          'role based access control'
                                                      ? "RBAC"
                                                      : e.object.name!
                                                                  .toLowerCase() ==
                                                              "person basic information"
                                                          ? "Basic Info"
                                                          : e.object.name!,
                                                  ontap: () {
                                                    if (e.object.name ==
                                                        "Roles Extend") {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                        return BlocProvider(
                                                          create: (context) =>
                                                              Unit2RolesExtendBloc()
                                                                ..add((GetUnit2RolesExtend(
                                                                    webUserId:
                                                                        widget
                                                                            .userId))),
                                                          child:
                                                              Unit2RolesExtendScreen(
                                                            userId:
                                                                widget.userId,
                                                          ),
                                                        );
                                                      }));
                                                    }
                                                    if (e.object.name!
                                                            .toLowerCase() ==
                                                        'pass check') {
                                                      PassCheckArguments
                                                          passCheckArguments =
                                                          PassCheckArguments(
                                                              roleIdRoleName:
                                                                  RoleIdRoleName(
                                                                      roleId: e
                                                                          .roleId,
                                                                      roleName: e
                                                                          .roleName),
                                                              userId: widget
                                                                  .userId);
                                                      Navigator.pushNamed(
                                                          context,
                                                          '/pass-check',
                                                          arguments:
                                                              passCheckArguments);
                                                    }
                                                    if (e.object.name!
                                                            .toLowerCase() ==
                                                        'role based access control') {
                                                      Navigator.pushNamed(
                                                          context, '/rbac');
                                                    }

                                                    if (e.object.name!
                                                            .toLowerCase() ==
                                                        'agency') {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                        return BlocProvider(
                                                          create: (context) =>
                                                              AssignAreaAgencyBloc()
                                                                ..add((EstPointPersonGetAgencies(
                                                                    assignedAreas:
                                                                        widget
                                                                            .estPersonAssignedArea))),
                                                          child:
                                                              const EstPorintPersonAgencyScreen(),
                                                        );
                                                      }));
                                                    }
                                                    if (e.object.name!
                                                            .toLowerCase() ==
                                                        'assignable role') {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                        return BlocProvider<
                                                            Unit2AssinableRoleBloc>(
                                                          create: (context) =>
                                                              Unit2AssinableRoleBloc()
                                                                ..add(GetUnit2AssignableRoles(
                                                                    userId: widget
                                                                        .userId)),
                                                          child:
                                                              EstPointPersonRoleUnderScreen(
                                                            id: widget.userId,
                                                          ),
                                                        );
                                                      }));
                                                    }
                                                  })
                                              : Container(
                                                  color: Colors.black,
                                                )),
                                    ),
                                  ),
                                );
                              }).toList(),
                      ),
              ),
              SizedBox(
                height: superadminCards.isEmpty ? 0 : 24,
              ),
              Container(
                child: superadminCards.isEmpty
                    ? const SizedBox.shrink()
                    : Text(
                        "Superadmin module operations",
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(
                                fontSize: 16,
                                color: primary,
                                fontWeight: FontWeight.w300),
                      ),
              ),
              SizedBox(
                height: superadminCards.isEmpty ? 0 : 8,
              ),
              Container(
                  child: superadminCards.isEmpty
                      ? const SizedBox.shrink()
                      : GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 4,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 10,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          children: superadminCards.length > 3
                              //// in superadmincards lenght is greaterthan 3
                              ? tempSuperAdminCards.map((e) {
                                  int index = tempSuperAdminCards.indexOf(e);
                                  return Container(
                                      child: index == 3
                                          ? CardLabel(
                                              icon: FontAwesome5
                                                  .chevron_circle_right,
                                              title: "See More",
                                              ontap: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                          "Super Admin Module Operations",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        content: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            SizedBox(
                                                              height: 480,
                                                              width: double
                                                                  .maxFinite,
                                                              child: GridView
                                                                  .count(
                                                                shrinkWrap:
                                                                    true,
                                                                crossAxisCount:
                                                                    3,
                                                                crossAxisSpacing:
                                                                    8,
                                                                mainAxisSpacing:
                                                                    10,
                                                                physics:
                                                                    const BouncingScrollPhysics(),
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    vertical: 5,
                                                                    horizontal:
                                                                        5),
                                                                children:
                                                                    superadminCards
                                                                        .map(
                                                                            (e) {
                                                                  int index =
                                                                      superadminCards
                                                                          .indexOf(
                                                                              e);
                                                                  return SuperAdminMenu(
                                                                    id: widget
                                                                        .userId,
                                                                    columnCount:
                                                                        3,
                                                                    index:
                                                                        index,
                                                                    object: e,
                                                                  );
                                                                }).toList(),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    });
                                              })
                                          : SuperAdminMenu(
                                              id: widget.userId,
                                              object: e,
                                              index: index,
                                              columnCount: 3,
                                            ));
                                }).toList()
                              //// in superadmincards lenght is lessthan 3
                              : superadminCards.map((e) {
                                  int index = tempSuperAdminCards.indexOf(e);
                                  return Container(
                                      child: index == 3
                                          ? CardLabel(
                                              icon: FontAwesome5
                                                  .chevron_circle_right,
                                              title: "See More",
                                              ontap: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                          "Super Admin Module Operations",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        content: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            SizedBox(
                                                              height: 480,
                                                              width: double
                                                                  .maxFinite,
                                                              child: GridView
                                                                  .count(
                                                                shrinkWrap:
                                                                    true,
                                                                crossAxisCount:
                                                                    3,
                                                                crossAxisSpacing:
                                                                    8,
                                                                mainAxisSpacing:
                                                                    10,
                                                                physics:
                                                                    const BouncingScrollPhysics(),
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    vertical: 5,
                                                                    horizontal:
                                                                        5),
                                                                children:
                                                                    superadminCards
                                                                        .map(
                                                                            (e) {
                                                                  return SuperAdminMenu(
                                                                    id: widget
                                                                        .userId,
                                                                    columnCount:
                                                                        4,
                                                                    index:
                                                                        index,
                                                                    object: e,
                                                                  );
                                                                }).toList(),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    });
                                              })
                                          : SuperAdminMenu(
                                              id: widget.userId,
                                              object: e,
                                              index: index,
                                              columnCount: 4,
                                            ));
                                }).toList())),
              SizedBox(
                height: rpassCards.isEmpty ? 0 : 24,
              ),
              Container(
                child: rpassCards.isEmpty
                    ? const SizedBox.shrink()
                    : Text(
                        "RPAss module operations",
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(
                                fontSize: 16,
                                color: primary,
                                fontWeight: FontWeight.w300),
                      ),
              ),
              SizedBox(
                height: rpassCards.isEmpty ? 0 : 8,
              ),
              Container(
                child: rpassCards.isEmpty
                    ? const SizedBox.shrink()
                    : GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 4,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 10,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        children: rpassCards.map((e) {
                          return Container(
                              child: (e.roleName == 'field surveyor') &&
                                      e.moduleName == 'rpass'
                                  ? CardLabel(
                                      icon: iconGenerator(name: e.object.name!),
                                      title: e.object.name == 'Real Property'
                                          ? "Field Surveyor"
                                          : e.object.name!,
                                      ontap: () {
                                        Navigator.pushNamed(
                                            context, '/passo-home');
                                      })
                                  : Container(
                                      color: Colors.black,
                                    ));
                        }).toList(),
                      ),
              ),
              SizedBox(
                height: docSmsCards.isEmpty ? 0 : 24,
              ),
              Container(
                child: docSmsCards.isEmpty
                    ? const SizedBox.shrink()
                    : Text(
                        "DocSMS module operations",
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(
                                fontSize: 16,
                                color: primary,
                                fontWeight: FontWeight.w300),
                      ),
              ),
              const SizedBox(
                height: 8,
              ),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 10,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                children: docSmsCards.map((e) {
                  return Container(
                      child: (e.roleName == 'process server') &&
                              e.moduleName == 'document management'
                          ? CardLabel(
                              icon: iconGenerator(name: e.object.name!),
                              title: e.object.name == "Document"
                                  ? "Process Server"
                                  : e.object.name!,
                              ontap: () {})
                          : Container(
                              color: Colors.black,
                            ));
                }).toList(),
              )
            ],
          )
        ],
      ),
    );
  }
}

class PassCheckArguments {
  final RoleIdRoleName roleIdRoleName;
  final int userId;
  const PassCheckArguments(
      {required this.roleIdRoleName, required this.userId});
}

class RoleIdRoleName {
  final int roleId;
  final String roleName;
  const RoleIdRoleName({required this.roleId, required this.roleName});
}
