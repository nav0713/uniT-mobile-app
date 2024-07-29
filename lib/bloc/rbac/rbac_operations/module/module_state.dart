part of 'module_bloc.dart';

abstract class ModuleState extends Equatable {
  const ModuleState();
  
  @override
  List<Object> get props => [];
}

class ModuleInitial extends ModuleState {}

class ModuleLoaded extends ModuleState{
 final List<RBAC> module;
 const ModuleLoaded({required this.module});
}

class ModuleLoadingState extends ModuleState{

}
class ModuleErrorState extends ModuleState{
  final String message;
  const ModuleErrorState({required this.message});
}

class ModuleAddedState extends ModuleState {
  final Map<dynamic, dynamic> response;
  const ModuleAddedState({required this.response});
}
class ModuleUpdatedState extends ModuleState {
  final Map<dynamic, dynamic> response;
  const ModuleUpdatedState({required this.response});
}
class ModuleDeletedState extends ModuleState{
  final bool success;
  const ModuleDeletedState({required this.success});
}

class ModuleErrorAddingState extends ModuleState{
    final String? name;
  final String? slug;
  final String? shorthand;
  final int id;
  const ModuleErrorAddingState({required this.id, required this.name, required this.shorthand, required this.slug});

}

class ModuleErrorUpdatingState extends ModuleState{
    final int moduleId;
  final String name;
  final String? slug;
  final String? short;
  final int? createdBy;
  final int updatedBy;
  const ModuleErrorUpdatingState({required this.createdBy, required this.moduleId, required this.name, required this.short, required this.slug, required this.updatedBy});

}
class ModuleErrorDeletingState extends ModuleState{
    final int moduleId;
    const ModuleErrorDeletingState({required this.moduleId});
}
