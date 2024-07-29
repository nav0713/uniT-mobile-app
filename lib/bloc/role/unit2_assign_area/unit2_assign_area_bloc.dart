import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unit2/model/location/barangay2.dart';
import 'package:unit2/model/location/purok2.dart';
import 'package:unit2/model/profile/assigned_area.dart';
import 'package:unit2/model/profile/basic_information/primary-information.dart';
import 'package:unit2/model/rbac/assigned_role.dart';
import 'package:unit2/model/rbac/rbac.dart';
import 'package:unit2/model/rbac/rbac_station.dart';
import 'package:unit2/model/rbac/role_under.dart';
import 'package:unit2/model/roles/pass_check/assign_role_area_type.dart';
import 'package:unit2/model/utils/agency.dart';
import 'package:unit2/sevices/roles/rbac_operations/assigned_area_services.dart';
import 'package:unit2/sevices/roles/unit2_assign_area_services.dart';

part 'unit2_assign_area_event.dart';
part 'unit2_assign_area_state.dart';

class Unit2AssignAreaBloc
    extends Bloc<Unit2AssignAreaEvent, Unit2AssignAreaState> {
  Unit2AssignAreaBloc() : super(Unit2AssignAreaInitial()) {
    String? fname;
    String? lname;
    String? fullname;
    Profile? profile;
    int id;
    List<RolesUnder> rolesUnder = [];
    List<UserAssignedArea> userAssignedAreas = [];
    List<RBAC> roles = [];
    on<Unit2GetAssignArea>((event, emit) async {
      emit(Uni2AssignAreaLoadingState());
      try {
        profile = await Uni2AssignAreaServices.instance.searchUser(
            firstname: event.firstname,
            lastname: event.lastname,
            userId: event.id);
        if (profile != null && profile!.id != null) {
          fname = profile!.firstName;
          lname = profile!.lastName;
          fullname = "${fname!} ${lname!}";
          id = profile!.webuserId!;
          userAssignedAreas = await RbacAssignedAreaServices.instance
              .getAssignedArea(id: profile!.webuserId!);

          if (rolesUnder.isEmpty) {
            rolesUnder = await Uni2AssignAreaServices.instance
                .getRolesUnder(websuerId: event.id);
          }

          for (var role in rolesUnder) {
            roles.add(role.roleUnderChild);
          }
          emit(Unit2AssignAreaLoaded(
              roles: roles,
              userAssignedAreas: userAssignedAreas,
              fullname: fullname!,
              userId: id));
        } else {
          id = 0;
          emit(UserNotExistError());
        }
      } catch (e) {
        emit(Unit2AssignAreaErorState(message: e.toString()));
      }
    });
    on<DeleteUnit2AssignedArea>((event, emit) async {
      emit(Uni2AssignAreaLoadingState());
      try {
        bool success = await RbacAssignedAreaServices.instance
            .deleteAssignedArea(areaId: event.areaId);
        if (success) {
          for (var area in userAssignedAreas) {
            area.assignedArea.removeWhere((var a) {
              return a['id'] == event.areaId;
            });
          }
          emit(Unit2AssignedAreaDeletedState(success: success));
        } else {
          emit(Unit2AssignedAreaDeletedState(success: success));
        }
      } catch (e) {
        emit(Unit2AssignAreaErorState(message: e.toString()));
      }
    });
    on<LoadUnit2AssignedAreas>((event, emit) async {
      emit(Unit2AssignAreaLoaded(
          roles: roles,
          userAssignedAreas: userAssignedAreas,
          fullname: fullname!,
          userId: event.userId));
    });
    on<Unit2AddAssignArea>((event, emit) async {
      try {
        emit(Uni2AssignAreaLoadingState());
        Map<dynamic, dynamic> response = await RbacAssignedAreaServices.instance
            .add(
                userId: event.userId,
                roleId: event.roleId,
                areaTypeId: event.areaTypeId,
                areaId: event.areaId);
        if (response["success"]) {
          UserAssignedArea? newAssignArea;
          for (var userArea in userAssignedAreas) {
            if (userArea.assignedRole?.role?.id == event.roleId &&
                userArea.assignedRole?.user?.id == event.userId) {
              newAssignArea = userArea;
              break;
            }
          }
          if (newAssignArea?.assignedArea != null) {
            userAssignedAreas.removeWhere((element) =>
                element.assignedRole!.role!.id == event.roleId &&
                element.assignedRole!.user!.id == event.userId);
          }

          AssignedRole newAssignedRole =
              AssignedRole.fromJson(response['data'][0]['assigned_role']);
          AssignRoleAreaType newAssignRoleType = AssignRoleAreaType.fromJson(
              response['data'][0]['assigned_role_area_type']);
          UserAssignedArea temp = UserAssignedArea(
              assignedRole: newAssignedRole,
              assignedRoleAreaType: newAssignRoleType,
              assignedArea: []);
          newAssignArea = temp;

          ////barangay
          if (event.areaTypeId == 1) {
            List<dynamic> newAreas = [];
            for (var area in response['data']) {
              for (var assignedArea in area['assigned_area']) {
                var newArea = {};
                newArea.addAll({"id": assignedArea['id']});
                newArea.addAll({'isactive': assignedArea['isactive']});

                Barangay2 newBarangay =
                    Barangay2.fromJson(assignedArea['area']);

                newArea.addAll({
                  'area': {
                    "brgycode": newBarangay.brgycode,
                    "brgydesc": newBarangay.brgydesc,
                    "citymuncode": newBarangay.citymuncode
                  }
                });

                newAreas.add(newArea);
              }
            }
            newAssignArea.assignedArea = newAreas;
            userAssignedAreas.add(newAssignArea);
            //// purok
          }
          if (event.areaTypeId == 2) {
            List<dynamic> newAreas = [];
            for (var area in response['data']) {
              for (var assignedArea in area['assigned_area']) {
                var newArea = {};
                newArea.addAll({"id": assignedArea['id']});
                newArea.addAll({'isactive': assignedArea['isactive']});
                Purok2 newPurok = Purok2.fromJson(assignedArea['area']);
                newArea.addAll({
                  'area': {
                    "purokid": newPurok.purokid,
                    "purokdesc": newPurok.purokdesc,
                    "brgy": {
                      "brgycode": newPurok.brgy?.brgycode,
                      "brgydesc": newPurok.brgy?.brgydesc,
                      "citymuncode": newPurok.brgy?.citymuncode,
                    },
                    "purok_leader": newPurok.purokLeader,
                    "writelock": newPurok.writelock,
                    "recordsignature": newPurok.recordsignature
                  }
                });
                newAreas.add(newArea);
              }
            }
            newAssignArea.assignedArea = newAreas;
            userAssignedAreas.add(newAssignArea);
          }
          ////statiom
          if (event.areaTypeId == 4) {
            List<dynamic> newAreas = [];
            for (var area in response['data']) {
              for (var assignedArea in area['assigned_area']) {
                var newArea = {};
                newArea.addAll({"id": assignedArea['id']});
                newArea.addAll({'isactive': assignedArea['isactive']});
                RbacStation newStation =
                    RbacStation.fromJson(assignedArea['area']);
                newArea.addAll({
                  "area": {
                    "id": newStation.id,
                    "station_name": newStation.stationName,
                    "station_type": {
                      "id": newStation.stationType?.id,
                      "type_name": newStation.stationType?.typeName,
                      "color": newStation.stationType?.color,
                      "order": newStation.stationType?.order,
                      "is_active": newStation.stationType?.isActive,
                      "group": null
                    },
                    "hierarchy_order_no": newStation.hierarchyOrderNo,
                    "head_position": newStation.headPosition,
                    "government_agency": {
                      "agencyid": newStation.governmentAgency?.agencycatid,
                      "agencyname": newStation.governmentAgency?.agencyname,
                      "agencycatid": newStation.governmentAgency?.agencycatid,
                      "private_entity":
                          newStation.governmentAgency?.privateEntity,
                      "contactinfoid":
                          newStation.governmentAgency?.contactinfoid
                    },
                    "acronym": newStation.acronym,
                    "parent_station": newStation.parentStation,
                    "code": newStation.code,
                    "fullcode": newStation.fullcode,
                    "child_station_info": newStation.childStationInfo,
                    "islocation_under_parent": newStation.islocationUnderParent,
                    "main_parent_station": newStation.mainParentStation,
                    "description": newStation.description,
                    "ishospital": newStation.ishospital,
                    "isactive": newStation.isactive,
                    "selling_station": newStation.sellingStation
                  }
                });
                newAreas.add(newArea);
              }
            }
            newAssignArea.assignedArea = newAreas;
            userAssignedAreas.add(newAssignArea);
          }
          ////agency
          if (event.areaTypeId == 3) {
            List<dynamic> newAreas = [];
            for (var area in response['data']) {
              for (var assignedArea in area['assigned_area']) {
                var newArea = {};
                newArea.addAll({"id": assignedArea['id']});
                newArea.addAll({'isactive': assignedArea['isactive']});
                Agency newAgency = Agency.fromJson(assignedArea['area']);
                newArea.addAll({
                  "area": {
                    "id": newAgency.id,
                    "name": newAgency.name,
                    "category": {
                      "id": newAgency.category?.id,
                      "industry_class": {
                        "id": newAgency.category?.industryClass?.id,
                        "name": newAgency.category?.industryClass?.name,
                        "description":
                            newAgency.category?.industryClass?.description
                      }
                    },
                    "private_entity": newAgency.privateEntity,
                  }
                });
                newAreas.add(newArea);
              }
            }
            newAssignArea.assignedArea = newAreas;
            userAssignedAreas.add(newAssignArea);
          }
          emit(Unit2AssignAreaAddedState(response: response));
        } else {
          emit(Unit2AssignAreaAddedState(response: response));
        }
      } catch (e) {
        emit(Unit2AssignAreaErorState(message: e.toString()));
      }
    });
    on<Unit2AssignAreaCallErrorState>((event, emit) {
      emit(Unit2AssignAreaErorState(message: event.message));
    });
  }
}
