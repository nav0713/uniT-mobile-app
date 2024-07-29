part of 'unit2_roles_extend_bloc.dart';

class Unit2RolesExtendState extends Equatable {
  const Unit2RolesExtendState();

  @override
  List<Object> get props => [];
}

class Unit2RolesExtendInitial extends Unit2RolesExtendState {}

class Unit2RolesExtendLoadedState extends Unit2RolesExtendState {
  final List<RolesExtend> rolesExtend;
  const Unit2RolesExtendLoadedState({required this.rolesExtend});
}

class Unit2RolesExtendLoadingState extends Unit2RolesExtendState {}

class Unit2RolesExtendErrorState extends Unit2RolesExtendState {
  final String message;
  const Unit2RolesExtendErrorState({required this.message});
}
