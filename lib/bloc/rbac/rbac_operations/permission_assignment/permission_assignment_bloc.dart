import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unit2/model/rbac/permission.dart';
import 'package:unit2/model/rbac/permission_assignment.dart';
import 'package:unit2/model/rbac/rbac.dart';
import 'package:unit2/sevices/roles/rbac_operations/permission_assignment_services.dart';
import 'package:unit2/sevices/roles/rbac_operations/permission_service.dart';
import 'package:unit2/sevices/roles/rbac_operations/role_services.dart';

part 'permission_assignment_event.dart';
part 'permission_assignment_state.dart';

class PermissionAssignmentBloc
    extends Bloc<PermissionAssignmentEvent, PermissionAssignmentState> {
  PermissionAssignmentBloc() : super(PermissionAssignmentInitial()) {
    List<PermissionAssignment> permissionAssignments = [];
    List<RBACPermission> permissions = [];
    List<RBAC> roles = [];
    on<GetPermissionAssignments>((event, emit) async {
      try {
        emit(PermissionAssignmentLoadingScreen());
        if (permissionAssignments.isEmpty) {
          permissionAssignments = await RbacPermissionAssignmentServices
              .instance
              .getPermissionAssignment();
        }
        if (permissions.isEmpty) {
          permissions =
              await RbacPermissionServices.instance.getRbacPermission();
        }
        if (roles.isEmpty) {
          roles = await RbacRoleServices.instance.getRbacRoles();
        }
        emit(PermissionAssignmentLoadedState(
            permissionAssignments: permissionAssignments,
            permissions: permissions,
            roles: roles));
      } catch (e) {
        emit(PermissionAssignmentErrorState(message: e.toString()));
      }
    });
    on<AddPersmissionAssignment>((event, emit) async {
      try {
        emit(PermissionAssignmentLoadingScreen());
        Map<dynamic, dynamic> statusResponse =
            await RbacPermissionAssignmentServices.instance
                .addPermissionAssignment(
                    assignerId: event.assignerId,
                    opsId: event.opsId,
                    roleId: event.roleId);
        if (statusResponse['success']) {
          if (statusResponse['data'] != null) {
            for (var rbac in statusResponse['data']) {
              PermissionAssignment permissionAssignment =
                  PermissionAssignment.fromJson(rbac);
              permissionAssignments.add(permissionAssignment);
            }
          }
          emit(PermissionAssignmentAddedState(status: statusResponse));
        } else {
          emit(PermissionAssignmentAddedState(status: statusResponse));
        }
      } catch (e) {
        emit(PermissionAssignmentErrorAddingState(assignerId: event.assignerId,opsId: event.opsId, roleId: event.roleId));
      }
    });
    on<DeletePermissionAssignment>((event, emit) async {
      try {
        emit(PermissionAssignmentLoadingScreen());
        bool success = await RbacPermissionAssignmentServices.instance
            .deletePermissionAssignment(id: event.id);
        if (success) {
          permissionAssignments
              .removeWhere((element) => element.id == event.id);
        }
        emit(PermissionAssignmentDeletedState(success: success));
      } catch (e) {
        emit(PermissionAssignmentErrorDeletingState(id: event.id));
      }
    });
  }
}
