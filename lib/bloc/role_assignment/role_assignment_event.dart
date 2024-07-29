part of 'role_assignment_bloc.dart';

abstract class RoleAssignmentEvent extends Equatable {
  const RoleAssignmentEvent();

  @override
  List<Object> get props => [];
}

class GetAssignedRoles extends RoleAssignmentEvent {
  final String firstname;
  final String lastname;
  const GetAssignedRoles({required this.firstname, required this.lastname});
}

class DeleteAssignRole extends RoleAssignmentEvent {
  final int roleId;
  const DeleteAssignRole({required this.roleId});
}

class LoadAssignedRole extends RoleAssignmentEvent {}

class AssignRole extends RoleAssignmentEvent {
  final List<int> roles;
  final int assignerId;
  const AssignRole(
      {required this.assignerId, required this.roles});
}
