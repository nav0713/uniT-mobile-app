part of 'module_objects_bloc.dart';

abstract class ModuleObjectsEvent extends Equatable {
  const ModuleObjectsEvent();

  @override
  List<Object> get props => [];
}

class GetModuleObjects extends ModuleObjectsEvent {}

class DeleteRbacModuleObject extends ModuleObjectsEvent {
  final int moduleObjectId;
  const DeleteRbacModuleObject({required this.moduleObjectId});
}

class AddRbacModuleObjects extends ModuleObjectsEvent {
  final int moduleId;
  final List<int> objectsId;
  final int assignerId;
  const AddRbacModuleObjects(
      {required this.assignerId,
      required this.moduleId,
      required this.objectsId});
}

