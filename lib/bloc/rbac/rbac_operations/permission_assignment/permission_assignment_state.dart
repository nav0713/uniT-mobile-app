part of 'permission_assignment_bloc.dart';

class PermissionAssignmentState extends Equatable {
  const PermissionAssignmentState();

  @override
  List<Object> get props => [];
}

class PermissionAssignmentInitial extends PermissionAssignmentState {}

class PermissionAssignmentLoadingScreen extends PermissionAssignmentState {}

class PermissionAssignmentLoadedState extends PermissionAssignmentState {
  final List<PermissionAssignment> permissionAssignments;
  final List<RBACPermission> permissions;
  final List<RBAC> roles;
  const PermissionAssignmentLoadedState(
      {required this.permissionAssignments,
      required this.permissions,
      required this.roles});
  @override
  List<Object> get props => [permissionAssignments, permissions, roles];
}

class PermissionAssignmentErrorState extends PermissionAssignmentState {
  final String message;
  const PermissionAssignmentErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class PermissionAssignmentDeletedState extends PermissionAssignmentState {
  final bool success;
  const PermissionAssignmentDeletedState({required this.success});
  @override
  List<Object> get props => [success];
}

class PermissionAssignmentAddedState extends PermissionAssignmentState {
  final Map<dynamic, dynamic> status;
  const PermissionAssignmentAddedState({required this.status});
  @override
  List<Object> get props => [status];
}

class PermissionAssignmentErrorAddingState extends PermissionAssignmentState{
   final int assignerId;
  final List<int> opsId;
  final int roleId;
  const PermissionAssignmentErrorAddingState({required this.assignerId, required this.opsId, required this.roleId});
    @override
  List<Object> get props => [assignerId,opsId,roleId];
}
class PermissionAssignmentErrorDeletingState extends PermissionAssignmentState{
    final int id;
    const PermissionAssignmentErrorDeletingState({required this.id});
    @override
  List<Object> get props => [id];
}
