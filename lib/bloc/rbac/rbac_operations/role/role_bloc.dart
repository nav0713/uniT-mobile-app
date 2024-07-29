import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unit2/model/rbac/rbac.dart';
import 'package:unit2/sevices/roles/rbac_operations/role_services.dart';
part 'role_event.dart';
part 'role_state.dart';

class RoleBloc extends Bloc<RoleEvent, RoleState> {
  RoleBloc() : super(RoleInitial()) {
    List<RBAC> roles = [];
    on<GetRoles>((event, emit) async {
      try {
        emit(RoleLoadingState());
        if (roles.isEmpty) {
          roles = await RbacRoleServices.instance.getRbacRoles();
        }
        emit(RoleLoadedState(roles: roles));
      } catch (e) {
        emit(RoleErrorState(message: e.toString()));
      }
      ////Add
    });
    on<AddRbacRole>((event, emit) async {
      try {
        emit(RoleLoadingState());
        Map<dynamic, dynamic> statusResponse = await RbacRoleServices.instance
            .add(
                name: event.name!,
                slug: event.slug,
                short: event.shorthand,
                id: event.id);
        if (statusResponse['success']) {
          RBAC newRole = RBAC.fromJson(statusResponse['data']);
          roles.add(newRole);
          emit(RoleAddedState(response: statusResponse));
        } else {
          emit(RoleAddedState(response: statusResponse));
        }
      } catch (e) {
        emit(RoleAddingErrorState(id: event.id,name: event.name,shorthand: event.shorthand,slug: event.slug));
      }
    });
    on<UpdateRbacRole>((event, emit) async {
      emit(RoleLoadingState());
      try {
        Map<dynamic, dynamic> statusResponse = await RbacRoleServices.instance
            .update(
                name: event.name,
                slug: event.slug,
                short: event.short,
                roleId: event.roleId,
                createdBy: event.createdBy,
                updatedBy: event.updatedBy);

        if (statusResponse['success']) {
          roles.removeWhere((element) => element.id == event.roleId);
          RBAC newRole = RBAC.fromJson(statusResponse['data']);
          roles.add(newRole);
          emit(RoleUpdatedState(response: statusResponse));
        } else {
          emit(RoleUpdatedState(response: statusResponse));
        }
      } catch (e) {
        emit(RoleUpdatingErrorState(createdBy: event.createdBy,name: event.name,roleId: event.roleId,short: event.short,slug: event.slug,updatedBy: event.updatedBy));
      }
    });
    on<DeleteRbacRole>((event, emit) async {
      emit(RoleLoadingState());
      try {
        bool success = await RbacRoleServices.instance
            .deleteRbacRole(roleId: event.roleId);
        if (success) {
          roles.removeWhere((element) => element.id == event.roleId);
          emit(RoleDeletedState(success: success));
        } else {
          emit(RoleDeletedState(success: success));
        }
      } catch (e) {
        emit(RoleDeletingErrorState(roleId: event.roleId));
      }
    });
  }
}
