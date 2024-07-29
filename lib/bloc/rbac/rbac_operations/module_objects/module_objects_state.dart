part of 'module_objects_bloc.dart';

abstract class ModuleObjectsState extends Equatable {
  const ModuleObjectsState();

  @override
  List<Object> get props => [];
}

class ModuleObjectsInitial extends ModuleObjectsState {}

class ModuleObjectLoadedState extends ModuleObjectsState {
  final List<ModuleObjects> moduleObjects;
  final List<RBAC> objecs;
  final List<RBAC> modules;
  final List<int> ids;
  const ModuleObjectLoadedState(
      {required this.moduleObjects,
      required this.modules,
      required this.objecs,required this.ids});
}

class ModuleObjectsErrorState extends ModuleObjectsState {
  final String message;
  const ModuleObjectsErrorState({required this.message});
}

class ModuleObjectLoadingState extends ModuleObjectsState {}

class ModuleObjectAddedState extends ModuleObjectsState {
  final Map<dynamic, dynamic> response;
  const ModuleObjectAddedState({required this.response});
}

class ModuleObjectDeletedState extends ModuleObjectsState {
  final bool success;
  const ModuleObjectDeletedState({required this.success});
}
class ModuleObjectErrorAddingState extends ModuleObjectsState{
    final int moduleId;
  final List<int> objectsId;
  final int assignerId;
  const ModuleObjectErrorAddingState(
      {required this.assignerId,
      required this.moduleId,
      required this.objectsId});
}
class ModuleObjectErrorDeletingState extends ModuleObjectsState{
    final int moduleObjectId;
    const ModuleObjectErrorDeletingState({required this.moduleObjectId});
}
