import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../model/profile/basic_information/primary-information.dart';
import '../../model/rbac/assigned_role.dart';
import '../../model/rbac/rbac.dart';
import '../../sevices/roles/rbac_operations/role_assignment_services.dart';
import '../../sevices/roles/rbac_operations/role_services.dart';
part 'role_assignment_event.dart';
part 'role_assignment_state.dart';

class RoleAssignmentBloc
    extends Bloc<RoleAssignmentEvent, RoleAssignmentState> {
  RoleAssignmentBloc() : super(RoleAssignmentInitial()) {
    List<AssignedRole> assignedRoles = [];
    String? fname;
    String? lname;
    String? fullname;
    Profile? profile;
    List<RBAC> roles = [];
    on<GetAssignedRoles>((event, emit) async {
      emit(RoleAssignmentLoadingState());
      try {
        profile = await RbacRoleAssignmentServices.instance.searchUser(
            page: 1, name: event.firstname, lastname: event.lastname);
        if (profile != null && profile?.id != null) {
          fname = profile!.firstName;
          lname = profile!.lastName;
          fullname = "${fname!} ${lname!}";
          assignedRoles = await RbacRoleAssignmentServices.instance
              .getAssignedRoles(firstname: event.firstname, lastname: event.lastname);

          if (roles.isEmpty) {
            roles = await RbacRoleServices.instance.getRbacRoles();
          }
          emit(AssignedRoleLoaded(
              assignedRoles: assignedRoles, fullname: fullname!, roles: roles));
        } else {
          emit(UserNotExistError());
        }
      } catch (e) {
        emit(RoleAssignmentErrorState(message: e.toString()));
      }
    });
    on<LoadAssignedRole>((event, emit) {
      emit(AssignedRoleLoaded(
          assignedRoles: assignedRoles, fullname: fullname!, roles: roles));
    });
    on<DeleteAssignRole>((event, emit) async {
      emit(RoleAssignmentLoadingState());
      try {
        bool success = await RbacRoleAssignmentServices.instance
            .deleteAssignedRole(roleId: event.roleId);
        if (success) {
          assignedRoles.removeWhere((element) => element.id == event.roleId);
          emit(AssignedRoleDeletedState(success: success));
        } else {
          emit(AssignedRoleDeletedState(success: success));
        }
      } catch (e) {
        emit(AssignedRoleErrorDeletingState(roleId: event.roleId));
      }
    });
    on<AssignRole>((event, emit) async {
      emit(RoleAssignmentLoadingState());
      try {
        Map<dynamic, dynamic> statusResponse =
            await RbacRoleAssignmentServices.instance.add(
                userId: profile!.webuserId!,
                assignerId: event.assignerId,
                roles: event.roles);
        if (statusResponse['success']) {
          assignedRoles = [];
          statusResponse['data'].forEach((var roles) {
            AssignedRole newAssignRole = AssignedRole.fromJson(roles);
            if (!event.roles.contains(newAssignRole.id)) {
              assignedRoles.add(newAssignRole);
            }
          });
          emit(AssignedRoleAddedState(response: statusResponse));
        } else {
          emit(AssignedRoleAddedState(response: statusResponse));
        }
      } catch (e) {
        emit(AssignedRoleAddingErrorState(assignerId: event.assignerId,roles: event.roles));
      }
    });
  }
}
