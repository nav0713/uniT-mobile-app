import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unit2/model/rbac/assigned_role.dart';
import 'package:unit2/model/rbac/role_under.dart';
import '../../../../model/rbac/rbac.dart';
import '../../../../sevices/roles/unit2_role_assignment/unit2_role_assignment_services.dart';
import '../../../../sevices/roles/rbac_operations/role_assignment_services.dart';


part 'unit2_role_assignment_event.dart';
part 'unit2_role_assignment_state.dart';

class Unit2RoleAssignmentBloc
    extends Bloc<Unit2RoleAssignmentEvent, Unit2RoleAssignmentState> {
  Unit2RoleAssignmentBloc() : super(EstRoleAssignmentInitial()) {
    List<RolesUnder> rolesUnders = [];
    List<AssignedRole> assignedRoles = [];
    List<RBAC> assignableRoles = [];
    on<GetEstPointPersonRolesUnder>((event, emit) async {
      emit(EstPointPersonRoleLoadingState());
      try {
        if (assignedRoles.isEmpty) {
          assignedRoles = await EstPointPersonRoleAssignment.instance
              .getAssignedRoles(webuserId: event.userId);
        }
        if (rolesUnders.isEmpty) {
          rolesUnders = await EstPointPersonRoleAssignment.instance
              .getRoleUnderFilterByUser(userId:event.userId);
        }
        for (var roleUnder in rolesUnders) {
          assignableRoles.add(roleUnder.roleUnderChild);
        }
        emit(EstPointPersonRolesUnderLoadedState(
            assignedRoles: assignedRoles,
            rolesUnders: rolesUnders,
            assignableRole: assignableRoles));
      } catch (e) {
        emit(EstPointPersonRolesUnderErrorState(message: e.toString()));
      }
    });
    on<EstPointPersonAssignRole>((event, emit) async {
      emit(EstPointPersonRoleLoadingState());
      try {
        Map<dynamic, dynamic> statusResponse =
            await RbacRoleAssignmentServices.instance.add(
                userId: event.userId,
                assignerId: event.assingerId,
                roles: event.rolesId);
        if (statusResponse['success']) {
          assignedRoles = [];
          statusResponse['data'].forEach((var roles) {
            AssignedRole newAssignRole = AssignedRole.fromJson(roles);
        
          });
          emit(EstPointPersonRoleUnderAddedState(response: statusResponse));
        } else {
          emit(EstPointPersonRoleUnderAddedState(response: statusResponse));
        }
      } catch (e) {
        emit(EstPointPersonAssignError(assingerId: event.assingerId,rolesId: event.rolesId,userId: event.userId));
      }
    });
       on<EstPointPersonDeleteAssignRole>((event, emit) async {
      emit(EstPointPersonRoleLoadingState());
      try {
        bool success = await RbacRoleAssignmentServices.instance
            .deleteAssignedRole(roleId: event.roleId);
        if (success) {
          assignedRoles.removeWhere((element) => element.id == event.roleId);
          emit(EstPointPersonDeletedState(success: success));
        } else {
          emit(EstPointPersonDeletedState(success: success));
        }
      } catch (e) {
        emit(EstPointPersonDeletingRoleError(roleId: event.roleId));
      }
    });
  }
}
