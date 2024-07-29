part of 'permission_assignment_bloc.dart';

class PermissionAssignmentEvent extends Equatable {
  const PermissionAssignmentEvent();

  @override
  List<Object> get props => [];
}

class GetPermissionAssignments extends PermissionAssignmentEvent{

}
class DeletePermissionAssignment extends PermissionAssignmentEvent{
  final int id;
  const DeletePermissionAssignment({required this.id});
    @override
  List<Object> get props => [id];
}

class AddPersmissionAssignment extends PermissionAssignmentEvent{
  final int assignerId;
  final List<int> opsId;
  final int roleId;
  const AddPersmissionAssignment({required this.assignerId, required this.opsId, required this.roleId});
    @override
  List<Object> get props => [assignerId,opsId,roleId];

}
