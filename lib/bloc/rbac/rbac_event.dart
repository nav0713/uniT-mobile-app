part of 'rbac_bloc.dart';

abstract class RbacEvent extends Equatable {
  const RbacEvent();

  @override
  List<Object> get props => [];
}

class SetRbacScreen extends RbacEvent {}

class AssignedRbac extends RbacEvent {
  final int assigneeId;
  final int assignerId;
  final RBAC? selectedRole;
  final RBAC? selectedModule;
  final List<int> permissionId;
  final List<NewPermission> newPermissions;
  const AssignedRbac(
      {required this.assigneeId,
      required this.assignerId,
      required this.newPermissions,
      required this.permissionId,
      required this.selectedModule,
      required this.selectedRole});
}
class LoadRbac extends RbacEvent{
  
}
