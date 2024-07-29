import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unit2/model/rbac/rbac.dart';
import 'package:unit2/sevices/roles/rbac_operations/role_module_services.dart';
import 'package:unit2/sevices/roles/rbac_operations/role_services.dart';
import '../../../../model/rbac/role_module.dart';
import '../../../../sevices/roles/rbac_operations/module_services.dart';
part 'role_module_event.dart';
part 'role_module_state.dart';

class RoleModuleBloc extends Bloc<RoleModuleEvent, RoleModuleState> {
  RoleModuleBloc() : super(RoleModuleInitial()) {
    List<RoleModules> roleModules = [];
    List<RBAC> roles = [];
    List<RBAC> modules = [];
    on<GetRoleModules>((event, emit) async {
      emit(RoleModuleLoadingState());
      try {
        if (roleModules.isEmpty) {
          roleModules = await RbacRoleModuleServices.instance.getRoleModules();
        }
        if (modules.isEmpty) {
          modules = await RbacModuleServices.instance.getRbacModule();
        }
        if (roles.isEmpty) {
          roles = await RbacRoleServices.instance.getRbacRoles();
        }
        emit(RoleModuleLoadedState(
            roleModules: roleModules, modules: modules, roles: roles));
      } catch (e) {
        emit(RoleModuleErrorState(message: e.toString()));
      }
    });
    on<AddRoleModule>((event, emit) async {
      try {
        emit(RoleModuleLoadingState());
        Map<dynamic, dynamic> statusResponse =
            await RbacRoleModuleServices.instance.add(
                assignerId: event.assignerId,
                roleId: event.roleId,
                moduleIds: event.moduleIds);

        if (statusResponse['success']) {
          List<int?> ids = roleModules.map((e) => e.id).toList();
          statusResponse['data'].forEach((var roleMod) {
            RoleModules newRoleModule = RoleModules.fromJson(roleMod);
            if (!ids.contains(newRoleModule.id)) {
              roleModules.add(newRoleModule);
            }
            emit(RoleModuleAddedState(response: statusResponse));
          });
        } else {
          emit(RoleModuleAddedState(response: statusResponse));
        }
      } catch (e) {
        emit(RoleModuleErrorAddingState(assignerId: event.assignerId,roleId: event.roleId,moduleIds: event.moduleIds));
      }
    });
    on<DeleteRoleModule>((event, emit) async {
      emit(RoleModuleLoadingState());
      try {
        bool success = await RbacRoleModuleServices.instance
            .deleteRbacRoleModule(moduleObjectId: event.roleModuleId);
        if (success) {
          roleModules
              .removeWhere((element) => element.id == event.roleModuleId);
          emit(RoleModuleDeletedState(success: success));
        } else {
          RoleModuleDeletedState(success: success);
        }
      } catch (e) {
        emit(RoleModuleErrorDeletingState(roleModuleId: event.roleModuleId));
      }
    });
  }
}
