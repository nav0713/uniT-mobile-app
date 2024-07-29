part of 'role_module_bloc.dart';

abstract class RoleModuleEvent extends Equatable {
  const RoleModuleEvent();

  @override
  List<Object> get props => [];
}

class GetRoleModules extends RoleModuleEvent {}

class DeleteRoleModule extends RoleModuleEvent {
  final int roleModuleId;
  const DeleteRoleModule({required this.roleModuleId});
}

class AddRoleModule extends RoleModuleEvent {
  final int roleId;
  final List<int> moduleIds;
  final int assignerId;
  const AddRoleModule(
      {required this.assignerId,
      required this.roleId,
      required this.moduleIds});
}
