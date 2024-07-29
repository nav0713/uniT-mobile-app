part of 'roles_under_bloc.dart';

abstract class RolesUnderState extends Equatable {
  const RolesUnderState();

  @override
  List<Object> get props => [];
}

class RolesUnderInitial extends RolesUnderState {}

class RoleUnderLoadedState extends RolesUnderState {
  final List<RolesUnder> rolesUnder;
  final List<RBAC> roles;

  const RoleUnderLoadedState({required this.rolesUnder, required this.roles});
}

class RoleUnderLoadingState extends RolesUnderState {}

class RoleUnderErrorState extends RolesUnderState {
  final String message;
  const RoleUnderErrorState({required this.message});
}

class RoleUnderAddedState extends RolesUnderState {
  final Map<dynamic, dynamic> response;
  const RoleUnderAddedState({required this.response});
}

class RoleUnderDeletedState extends RolesUnderState {
  final bool success;
  const RoleUnderDeletedState({required this.success});
}

class RoleUnderAddingErrorState extends RolesUnderState {
  final int roleId;
  final List<int> roleUnderIds;
  const RoleUnderAddingErrorState(
      {required this.roleId, required this.roleUnderIds});
}

class RoleUnderDeletingErrorState extends RolesUnderState {
  final int roleUnderId;
  const RoleUnderDeletingErrorState({required this.roleUnderId});
}
