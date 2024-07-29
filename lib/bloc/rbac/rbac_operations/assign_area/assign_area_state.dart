part of 'assign_area_bloc.dart';

class AssignAreaState extends Equatable {
  const AssignAreaState();

  @override
  List<Object> get props => [];
}

class AssignedAreaLoadedState extends AssignAreaState{
  final List<UserAssignedArea> userAssignedAreas;
  final List<RBAC> roles;
  final String fullname;
  final int userId;
  const AssignedAreaLoadedState({required this.userAssignedAreas, required this.fullname, required this.roles, required this.userId});
    @override
  List<Object> get props => [userAssignedAreas,fullname,roles];
}
class AssignAreaErorState extends AssignAreaState {
  final String message;
  const AssignAreaErorState({required this.message});
  @override
  List<Object> get props => [message];
}
class AssignAreaLoadingState extends AssignAreaState{

}

class UserNotExistError extends AssignAreaState{
  
}
class AssignAreaInitial extends AssignAreaState {}
class AssignedAreaDeletedState extends AssignAreaState{
  final bool success;
  const AssignedAreaDeletedState({required this.success});
  @override
  List<Object> get props => [success];
}
class AssignAreaAddedState extends AssignAreaState {
  final Map<dynamic,dynamic> response;
  const AssignAreaAddedState({required this.response});
    @override
  List<Object> get props => [response];
}

class AssignAreaAddingErrorState extends AssignAreaState{
  final int userId;
    final int roleId;
  final int areaTypeId;
  final String areaId;
  const AssignAreaAddingErrorState({required this.areaId, required this.areaTypeId, required this.roleId, required this.userId});
    @override
  List<Object> get props => [roleId,areaTypeId,areaId];
}

class AssignAreaDeletingErrorState extends AssignAreaState{
    final int areaId;
    const AssignAreaDeletingErrorState({required this.areaId});
    @override
  List<Object> get props => [areaId];
}

