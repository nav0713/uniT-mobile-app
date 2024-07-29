part of 'permission_bloc.dart';

abstract class PermissionEvent extends Equatable {
  const PermissionEvent();

  @override
  List<Object> get props => [];
}

class GetPermissions extends PermissionEvent {}

class AddRbacPermission extends PermissionEvent {
  final int objectId;
  final List<int> operationIds;
  final int assignerId;
  const AddRbacPermission(
      {required this.assignerId,
      required this.objectId,
      required this.operationIds});
}

class DeleteRbacPermission extends PermissionEvent {
  final int permissionId;
  const DeleteRbacPermission({required this.permissionId});
}
