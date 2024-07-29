part of 'role_assignment_bloc.dart';

abstract class RoleAssignmentState extends Equatable {
  const RoleAssignmentState();

  @override
  List<Object> get props => [];
}

class RoleAssignmentInitial extends RoleAssignmentState {}

class AssignedRoleLoaded extends RoleAssignmentState {
  final String fullname;
  final List<AssignedRole> assignedRoles;
  final List<RBAC> roles;
  const AssignedRoleLoaded(
      {required this.assignedRoles,
      required this.fullname,
      required this.roles});
}

class RoleAssignmentLoadingState extends RoleAssignmentState {}

class RoleAssignmentErrorState extends RoleAssignmentState {
  final String message;
  const RoleAssignmentErrorState({required this.message});
}

class UserNotExistError extends RoleAssignmentState {}

class AssignedRoleDeletedState extends RoleAssignmentState {
  final bool success;
  const AssignedRoleDeletedState({required this.success});
}

class AssignedRoleAddedState extends RoleAssignmentState {
  final Map<dynamic, dynamic> response;
  const AssignedRoleAddedState({required this.response});
}

class AssignedRoleAddingErrorState extends RoleAssignmentState {
  final List<int> roles;
  final int assignerId;
  const AssignedRoleAddingErrorState(
      {required this.assignerId, required this.roles});
}

class AssignedRoleErrorDeletingState extends RoleAssignmentState {
  final int roleId;
  const AssignedRoleErrorDeletingState({required this.roleId});
}
