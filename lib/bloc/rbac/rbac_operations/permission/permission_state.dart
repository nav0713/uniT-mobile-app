part of 'permission_bloc.dart';

abstract class PermissionState extends Equatable {
  const PermissionState();

  @override
  List<Object> get props => [];
}

class PermissionInitial extends PermissionState {}

class PermissionLoaded extends PermissionState {
  final List<RBACPermission> permissions;
  final List<RBAC> objects;
  final List<RBAC> operations;
  const PermissionLoaded(
      {required this.permissions,
      required this.objects,
      required this.operations});
}

class PermissionAddedState extends PermissionState {
  final Map<dynamic, dynamic> response;
  const PermissionAddedState({required this.response});
}

class PermissonLoadingState extends PermissionState {}

class PermissionErrorState extends PermissionState {
  final String message;
  const PermissionErrorState({required this.message});
}

class PermissionDeletedState extends PermissionState {
  final bool success;
  const PermissionDeletedState({required this.success});
}
class PermissionErrorAddingState extends PermissionState{
    final int objectId;
  final List<int> operationIds;
  final int assignerId;
  const PermissionErrorAddingState(
      {required this.assignerId,
      required this.objectId,
      required this.operationIds});
}

class PermissionErrorDeletingState extends PermissionState{
    final int permissionId;
    const PermissionErrorDeletingState({required this.permissionId});
}
