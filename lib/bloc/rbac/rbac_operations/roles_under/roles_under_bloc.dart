import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unit2/model/rbac/role_under.dart';
import 'package:unit2/sevices/roles/rbac_operations/roles_under_services.dart';

import '../../../../model/rbac/rbac.dart';
import '../../../../sevices/roles/rbac_operations/role_services.dart';

part 'roles_under_event.dart';
part 'roles_under_state.dart';

class RolesUnderBloc extends Bloc<RolesUnderEvent, RolesUnderState> {
  RolesUnderBloc() : super(RolesUnderInitial()) {
    List<RolesUnder> rolesUnder = [];
    List<RBAC> roles = [];
    on<GetRolesUnder>((event, emit) async {
      emit(RoleUnderLoadingState());
      try {
        if (rolesUnder.isEmpty) {
          rolesUnder = await RbacRoleUnderServices.instance.getRolesUnder();
        }

        if (roles.isEmpty) {
          roles = await RbacRoleServices.instance.getRbacRoles();
        }
        emit(RoleUnderLoadedState(rolesUnder: rolesUnder, roles: roles));
      } catch (e) {
        emit(RoleUnderErrorState(message: e.toString()));
      }
    });
    on<AddRoleUnder>((event, emit) async {
      try {
        emit(RoleUnderLoadingState());
        Map<dynamic, dynamic> statusResponse = await RbacRoleUnderServices
            .instance
            .add(roleId: event.roleId, rolesId: event.roleUnderIds);

        if (statusResponse['success']) {
          List<int> ids = rolesUnder.map((e) => e.id).toList();
          statusResponse['data'].forEach((var roleMod) {
            RolesUnder newRoleUnder = RolesUnder.fromJson(roleMod);
            if (!ids.contains(newRoleUnder.id)) {
              rolesUnder.add(newRoleUnder);
            }
          });
          emit(RoleUnderAddedState(response: statusResponse));
        } else {
          emit(RoleUnderAddedState(response: statusResponse));
        }
      } catch (e) {
        emit(RoleUnderAddingErrorState(roleId: event.roleId,roleUnderIds: event.roleUnderIds));
      }
    });
    on<DeleteRoleUnder>((event, emit) async {
      emit(RoleUnderLoadingState());
      try {
        bool success = await RbacRoleUnderServices.instance
            .deleteRbacRoleUnder(roleUnderId: event.roleUnderId);
        if (success) {
          rolesUnder.removeWhere((element) => element.id == event.roleUnderId);
          emit(RoleUnderDeletedState(success: success));
        } else {
          emit(RoleUnderDeletedState(success: success));
        }
      } catch (e) {
        emit(RoleUnderDeletingErrorState(roleUnderId: event.roleUnderId));
      }
    });
  }
}
