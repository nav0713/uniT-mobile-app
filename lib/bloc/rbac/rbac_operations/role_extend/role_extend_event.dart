part of 'role_extend_bloc.dart';

abstract class RoleExtendEvent extends Equatable {
  const RoleExtendEvent();

  @override
  List<Object> get props => [];
}

class GetRoleExtend extends RoleExtendEvent {}

class DeleteRoleExtend extends RoleExtendEvent {
  final int roleExtendId;
  const DeleteRoleExtend({required this.roleExtendId});
}

class AddRoleExtend extends RoleExtendEvent {
  final int roleId;
  final List<int> roleExtendsId;
  const AddRoleExtend({required this.roleId, required this.roleExtendsId});
}
