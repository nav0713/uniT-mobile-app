part of 'unit2_assign_area_bloc.dart';

class Unit2AssignAreaEvent extends Equatable {
  const Unit2AssignAreaEvent();

  @override
  List<Object> get props => [];
}

class Unit2GetAssignArea extends Unit2AssignAreaEvent {
  final String firstname;
  final String lastname;
  final int id;
  const Unit2GetAssignArea(
      {required this.firstname, required this.lastname, required this.id});
  @override
  List<Object> get props => [firstname, lastname];
}

class Unit2AssignAreaCallErrorState extends Unit2AssignAreaEvent {
  final String message;
  const Unit2AssignAreaCallErrorState({required this.message});
}

class Unit2AddAssignArea extends Unit2AssignAreaEvent {
  final int userId;
  final int roleId;
  final int areaTypeId;
  final String areaId;

  const Unit2AddAssignArea(
      {required this.areaId,
      required this.areaTypeId,
      required this.roleId,
      required this.userId});
  @override
  List<Object> get props => [userId, roleId, areaTypeId, areaId];
}

class LoadUnit2AssignedAreas extends Unit2AssignAreaEvent {
  final int userId;
  const LoadUnit2AssignedAreas({required this.userId});
  @override
  List<Object> get props => [userId];
}

class DeleteUnit2AssignedArea extends Unit2AssignAreaEvent {
  final int areaId;
  const DeleteUnit2AssignedArea({required this.areaId});
  @override
  List<Object> get props => [areaId];
}
