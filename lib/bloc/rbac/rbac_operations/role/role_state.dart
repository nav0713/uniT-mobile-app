part of 'role_bloc.dart';

abstract class RoleState extends Equatable {
  const RoleState();

  @override
  List<Object> get props => [];
}

class RoleInitial extends RoleState {}

class RoleLoadedState extends RoleState {
  final List<RBAC> roles;
  const RoleLoadedState({required this.roles});
}

class RoleLoadingState extends RoleState {}

class RoleErrorState extends RoleState {
  final String message;
  const RoleErrorState({required this.message});
}

class RoleAddedState extends RoleState {
  final Map<dynamic, dynamic> response;
  const RoleAddedState({required this.response});
}
class RoleUpdatedState extends RoleState {
  final Map<dynamic, dynamic> response;
  const RoleUpdatedState({required this.response});
}
class RoleDeletedState extends RoleState{
  final bool success;
  const RoleDeletedState({required this.success});
}
class RoleAddingErrorState extends RoleState{
    final String? name;
  final String? slug;
  final String? shorthand;
  final int id;
  const RoleAddingErrorState({required this.id, required this.name, required this.shorthand, required this.slug});

}
class RoleUpdatingErrorState extends RoleState{
    final int roleId;
  final String name;
  final String? slug;
  final String? short;
  final int? createdBy;
  final int updatedBy;
  const RoleUpdatingErrorState({required this.createdBy, required this.name, required this.roleId, required this.short, required this.slug, required this.updatedBy});
}

class RoleDeletingErrorState extends RoleState{
    final int roleId;
    const RoleDeletingErrorState({required this.roleId});
}


