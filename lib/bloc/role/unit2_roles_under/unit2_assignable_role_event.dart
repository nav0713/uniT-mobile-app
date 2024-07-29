part of 'unit2_assignable_role_bloc.dart';

abstract class Unit2AssinableRoleEvent extends Equatable {
  const Unit2AssinableRoleEvent();

  @override
  List<Object> get props => [];
}

class GetUnit2AssignableRoles
    extends Unit2AssinableRoleEvent {
  final int userId;
  const GetUnit2AssignableRoles({required this.userId});
}

