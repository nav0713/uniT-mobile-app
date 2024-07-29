part of 'role_module_bloc.dart';

abstract class RoleModuleState extends Equatable {
  const RoleModuleState();

  @override
  List<Object> get props => [];
}

class RoleModuleInitial extends RoleModuleState {}

class RoleModuleLoadedState extends RoleModuleState {
  final List<RoleModules> roleModules;
  final List<RBAC> roles;
  final List<RBAC> modules;

  const RoleModuleLoadedState(
      {required this.roleModules, required this.modules, required this.roles});
}

class RoleModuleLoadingState extends RoleModuleState {}

class RoleModuleErrorState extends RoleModuleState {
  final String message;
  const RoleModuleErrorState({required this.message});
}

class RoleModuleAddedState extends RoleModuleState {
  final Map<dynamic, dynamic> response;
  const RoleModuleAddedState({required this.response});
}

class RoleModuleDeletedState extends RoleModuleState {
  final bool success;
  const RoleModuleDeletedState({required this.success});
}

class RoleModuleErrorAddingState extends RoleModuleState {
  final int roleId;
  final List<int> moduleIds;
  final int assignerId;
  const RoleModuleErrorAddingState(
      {required this.assignerId,
      required this.roleId,
      required this.moduleIds});
}

class RoleModuleErrorDeletingState extends RoleModuleState {
  final int roleModuleId;
  const RoleModuleErrorDeletingState({required this.roleModuleId});
}
