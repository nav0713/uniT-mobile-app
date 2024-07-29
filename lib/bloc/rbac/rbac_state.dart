part of 'rbac_bloc.dart';

abstract class RbacState extends Equatable {
  const RbacState();

  @override
  List<Object> get props => [];
}

class RbacInitial extends RbacState {}

class RbacScreenSetted extends RbacState {
  final List<RBAC> modules;
  final List<RBAC> objects;
  final List<RBAC> role;
  final List<RBACPermission> permission;
  final List<RBAC> operations;
  const RbacScreenSetted(
      {required this.modules,
      required this.objects,
      required this.operations,
      required this.permission,
      required this.role});
}

class RbacLoadingState extends RbacState {}

class RbacErrorState extends RbacState {
  final String message;
  const RbacErrorState({required this.message});
}

class RbacAssignedState extends RbacState{
final Map<dynamic,dynamic> responseStatus;
  const RbacAssignedState({required this.responseStatus});
}
