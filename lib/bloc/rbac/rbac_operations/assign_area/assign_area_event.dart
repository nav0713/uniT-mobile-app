part of 'assign_area_bloc.dart';

class AssignAreaEvent extends Equatable {
  const AssignAreaEvent();

  @override
  List<Object> get props => [];
}

class GetAssignArea extends AssignAreaEvent {
  final String firstname;
  final String lastname;
  const GetAssignArea({required this.firstname, required this.lastname});
  @override
  List<Object> get props => [firstname, lastname];
}

class DeleteAssignedArea extends AssignAreaEvent {
  final int areaId;
  const DeleteAssignedArea({required this.areaId});
  @override
  List<Object> get props => [areaId];
}

class LoadAssignedAreas extends AssignAreaEvent {
  final int userId;
  const LoadAssignedAreas({required this.userId});
  @override
  List<Object> get props => [userId];
}

class CallErrorState extends AssignAreaEvent {
  final String message;
  const CallErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class AddAssignArea extends AssignAreaEvent {
  final int userId;
  final int roleId;
  final int areaTypeId;
  final String areaId;

  const AddAssignArea(
      {required this.areaId,
      required this.areaTypeId,
      required this.roleId,
      required this.userId});
  @override
  List<Object> get props => [userId, roleId, areaTypeId, areaId];
}
