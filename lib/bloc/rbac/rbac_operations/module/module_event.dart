part of 'module_bloc.dart';

abstract class ModuleEvent extends Equatable {
  const ModuleEvent();

  @override
  List<Object> get props => [];
}


class GetModule extends ModuleEvent{
  
}

class AddRbacModule extends ModuleEvent {
  final String? name;
  final String? slug;
  final String? shorthand;
  final int id;
  const AddRbacModule(
      {required this.id,
      required this.name,
      required this.shorthand,
      required this.slug});
}


class UpdateRbacModule extends ModuleEvent {
  final int moduleId;
  final String name;
  final String? slug;
  final String? short;
  final int? createdBy;
  final int updatedBy;
  const UpdateRbacModule({
    required this.moduleId,
    required this.createdBy,
    required this.name,
    required this.short,
    required this.slug,
    required this.updatedBy,
  });
}

class DeleteRbacModule extends ModuleEvent {
  final int moduleId;
  const DeleteRbacModule({required this.moduleId});
}