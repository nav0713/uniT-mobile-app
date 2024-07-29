part of 'unit2_assign_area_bloc.dart';

class Unit2AssignAreaState extends Equatable {
  const Unit2AssignAreaState();

  @override
  List<Object> get props => [];
}

class Unit2AssignAreaInitial extends Unit2AssignAreaState {}

class UserNotExistError extends Unit2AssignAreaState {}

class Uni2AssignAreaLoadingState extends Unit2AssignAreaState {}

class Unit2AssignAreaLoaded extends Unit2AssignAreaState {
  final List<UserAssignedArea> userAssignedAreas;
  final List<RBAC> roles;
  final String fullname;
  final int userId;
  const Unit2AssignAreaLoaded(
      {required this.fullname,
      required this.userAssignedAreas,
      required this.userId,
      required this.roles});
  @override
  List<Object> get props => [userAssignedAreas, fullname, userId];
}

class Unit2AssignAreaErorState extends Unit2AssignAreaState {
  final String message;
  const Unit2AssignAreaErorState({required this.message});
  @override
  List<Object> get props => [message];
}

class Unit2AssignAreaAddedState extends Unit2AssignAreaState {
  final Map<dynamic, dynamic> response;
  const Unit2AssignAreaAddedState({required this.response});
  @override
  List<Object> get props => [response];
}

class Unit2AssignedAreaDeletedState extends Unit2AssignAreaState {
  final bool success;
  const Unit2AssignedAreaDeletedState({required this.success});
  @override
  List<Object> get props => [success];
}
