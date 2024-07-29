part of 'role_extend_bloc.dart';

abstract class RoleExtendState extends Equatable {
  const RoleExtendState();

  @override
  List<Object> get props => [];
}

class RoleExtendInitial extends RoleExtendState {}

class RoleExtendLoadedState extends RoleExtendState {
  final List<RolesExtend> rolesExtend;
  final List<RBAC> roles;

  const RoleExtendLoadedState({required this.rolesExtend, required this.roles});
    @override
  List<Object> get props => [rolesExtend,roles];
}

class RoleExtendLoadingState extends RoleExtendState {}

class RoleExtendErrorState extends RoleExtendState {
  final String message;
  const RoleExtendErrorState({required this.message});
    @override
  List<Object> get props => [message];
}

class RoleExtendAddedState extends RoleExtendState {
  final Map<dynamic, dynamic> response;
  const RoleExtendAddedState({required this.response});
    @override
  List<Object> get props => [response];
}

class RoleExtendDeletedState extends RoleExtendState {
  final bool success;
  const RoleExtendDeletedState({required this.success});
    @override
  List<Object> get props => [success];
}

class RoleExtendErrorAddingState extends RoleExtendState{
   final int roleId;
  final List<int> roleExtendsId;
  const RoleExtendErrorAddingState({required this.roleExtendsId, required this.roleId});
    @override
  List<Object> get props => [roleExtendsId,roleId];
}

class RoleExtendErrorDeletingState extends RoleExtendState{
  final int roleExtendId;
  const RoleExtendErrorDeletingState({required this.roleExtendId});
}
