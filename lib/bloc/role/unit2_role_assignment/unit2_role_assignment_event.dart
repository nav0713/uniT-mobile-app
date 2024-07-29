part of 'unit2_role_assignment_bloc.dart';

abstract class Unit2RoleAssignmentEvent extends Equatable {
  const Unit2RoleAssignmentEvent();

  @override
  List<Object> get props => [];
}

class GetEstPointPersonRolesUnder extends Unit2RoleAssignmentEvent{
  final int userId;
  const GetEstPointPersonRolesUnder({required this.userId});
}

class EstPointPersonAssignRole extends Unit2RoleAssignmentEvent{
  final int userId;
  final List<int> rolesId;
  final int assingerId;
  const EstPointPersonAssignRole({required this.assingerId, required this.rolesId, required this.userId});
}
class EstPointPersonDeleteAssignRole extends Unit2RoleAssignmentEvent {
  final int roleId;
  const EstPointPersonDeleteAssignRole({required this.roleId});
}

