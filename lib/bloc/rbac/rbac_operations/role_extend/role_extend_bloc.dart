import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unit2/model/rbac/role_extend.dart';
import 'package:unit2/sevices/roles/rbac_operations/role_extend_services.dart';
import '../../../../model/rbac/rbac.dart';
import '../../../../sevices/roles/rbac_operations/role_services.dart';

part 'role_extend_event.dart';
part 'role_extend_state.dart';

class RoleExtendBloc extends Bloc<RoleExtendEvent, RoleExtendState> {
  RoleExtendBloc() : super(RoleExtendInitial()) {
    List<RolesExtend> rolesExtend = [];
    List<int> roleExtendIds = [];
    List<RBAC> roles = [];
    on<GetRoleExtend>((event, emit) async {
      emit(RoleExtendLoadingState());
      try {
        if (rolesExtend.isEmpty) {
          rolesExtend = await RbacRoleExtendServices.instance.getRolesExtend();
        }

        if (roles.isEmpty) {
          roles = await RbacRoleServices.instance.getRbacRoles();
        }
        for (var roleExt in rolesExtend) {
          roleExtendIds.add(roleExt.id);
        }
        emit(RoleExtendLoadedState(rolesExtend: rolesExtend, roles: roles));
      } catch (e) {
        emit(RoleExtendErrorState(message: e.toString()));
      }
    });
    on<AddRoleExtend>((event, emit) async {
      try {
        emit(RoleExtendLoadingState());
        Map<dynamic, dynamic> statusResponse = await RbacRoleExtendServices
            .instance
            .add(roleId: event.roleId, rolesExtendsId: event.roleExtendsId);

        if (statusResponse['success']) {
          statusResponse['data'].forEach((var roleExt) {
            RolesExtend newRoleExtend = RolesExtend.fromJson(roleExt);
            if(!roleExtendIds.contains(newRoleExtend.id)){
                rolesExtend.add(newRoleExtend);
            }
          });
          emit(RoleExtendAddedState(response: statusResponse));
        } else {
          emit(RoleExtendAddedState(response: statusResponse));
        }
      } catch (e) {
        emit(RoleExtendErrorAddingState(roleExtendsId: event.roleExtendsId,roleId: event.roleId));
      }
    });
    on<DeleteRoleExtend>((event, emit) async {
      emit(RoleExtendLoadingState());
      try {
        bool success = await RbacRoleExtendServices.instance
            .delete(roleExtendId: event.roleExtendId);
        if (success) {
          rolesExtend
              .removeWhere((element) => element.id == event.roleExtendId);
          emit(RoleExtendDeletedState(success: success));
        } else {
          emit(RoleExtendDeletedState(success: success));
        }
      } catch (e) {
        emit(RoleExtendErrorDeletingState(roleExtendId: event.roleExtendId));
      }
    });
  }
}
