part of 'roles_under_bloc.dart';

abstract class RolesUnderEvent extends Equatable {
  const RolesUnderEvent();

  @override
  List<Object> get props => [];
}

class GetRolesUnder extends RolesUnderEvent {}

class DeleteRoleUnder extends RolesUnderEvent {
  final int roleUnderId;
  const DeleteRoleUnder({required this.roleUnderId});
}

class AddRoleUnder extends RolesUnderEvent{
  final int roleId;
  final List<int> roleUnderIds;
  const AddRoleUnder({required this.roleId, required this.roleUnderIds});
}
