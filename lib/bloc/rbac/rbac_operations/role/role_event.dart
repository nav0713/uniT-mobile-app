part of 'role_bloc.dart';

abstract class RoleEvent extends Equatable {
  const RoleEvent();

  @override
  List<Object> get props => [];
}

class GetRoles extends RoleEvent {}

class AddRbacRole extends RoleEvent {
  final String? name;
  final String? slug;
  final String? shorthand;
  final int id;
  const AddRbacRole(
      {required this.id,
      required this.name,
      required this.shorthand,
      required this.slug});
}


class UpdateRbacRole extends RoleEvent {
  final int roleId;
  final String name;
  final String? slug;
  final String? short;
  final int? createdBy;
  final int updatedBy;
  const UpdateRbacRole({
    required this.roleId,
    required this.createdBy,
    required this.name,
    required this.short,
    required this.slug,
    required this.updatedBy,
  });
}

class DeleteRbacRole extends RoleEvent {
  final int roleId;
  const DeleteRbacRole({required this.roleId});
}
