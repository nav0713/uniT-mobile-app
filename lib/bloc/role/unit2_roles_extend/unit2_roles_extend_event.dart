part of 'unit2_roles_extend_bloc.dart';

class Unit2RolesExtendEvent extends Equatable {
  const Unit2RolesExtendEvent();

  @override
  List<Object> get props => [];
}

class GetUnit2RolesExtend extends Unit2RolesExtendEvent {
  final int webUserId;
  const GetUnit2RolesExtend({required this.webUserId});
}
