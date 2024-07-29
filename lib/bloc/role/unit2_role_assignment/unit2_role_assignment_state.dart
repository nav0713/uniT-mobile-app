part of 'unit2_role_assignment_bloc.dart';

abstract class Unit2RoleAssignmentState extends Equatable {
  const Unit2RoleAssignmentState();
  
  @override
  List<Object> get props => [];
}

class EstPointPersonRolesUnderLoadedState extends Unit2RoleAssignmentState{
  final List<RolesUnder> rolesUnders;
  final List<AssignedRole> assignedRoles;
  final List<RBAC> assignableRole;
  const EstPointPersonRolesUnderLoadedState({required this.assignedRoles, required this.rolesUnders, required this.assignableRole});
}

class EstPointPersonRolesUnderErrorState extends Unit2RoleAssignmentState{
  final String message;
  const EstPointPersonRolesUnderErrorState({required this.message});
}

class EstPointPersonRoleLoadingState extends Unit2RoleAssignmentState{

}
class EstPointPersonRoleUnderAddedState extends Unit2RoleAssignmentState{
  final Map<dynamic,dynamic> response;
  const EstPointPersonRoleUnderAddedState({required this.response});
}

class EstPointPersonDeletedState extends Unit2RoleAssignmentState {
  final bool success;
  const EstPointPersonDeletedState({required this.success});
}


class EstRoleAssignmentInitial extends Unit2RoleAssignmentState {}

class EstPointPersonAssignError extends Unit2RoleAssignmentState{
    final int userId;
  final List<int> rolesId;
  final int assingerId;
  const EstPointPersonAssignError({required this.assingerId, required this.rolesId, required this.userId});
}

class EstPointPersonDeletingRoleError extends Unit2RoleAssignmentState{
  final int roleId;
  const EstPointPersonDeletingRoleError({required this.roleId});
}
