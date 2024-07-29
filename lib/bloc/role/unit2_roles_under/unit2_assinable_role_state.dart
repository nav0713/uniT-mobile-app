part of 'unit2_assignable_role_bloc.dart';

abstract class Unit2AssinableRoleState extends Equatable {
  const Unit2AssinableRoleState();

  @override
  List<Object> get props => [];
}

class Unit2AssignableRoleLoadingState
    extends Unit2AssinableRoleState {}

class Unit2AssignableErrorState
    extends Unit2AssinableRoleState {
  final String message;
  const Unit2AssignableErrorState({required this.message});
}


class Unit2AssinableRoleInitial
    extends Unit2AssinableRoleState {}

class Unit2AssignableRoleLoaded
    extends Unit2AssinableRoleState {
  final List<RolesUnder> rolesUnder;
  const Unit2AssignableRoleLoaded({ required this.rolesUnder, });
}