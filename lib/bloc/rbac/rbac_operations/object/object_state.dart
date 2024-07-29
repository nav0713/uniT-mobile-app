part of 'object_bloc.dart';

abstract class ObjectState extends Equatable {
  const ObjectState();
  
  @override
  List<Object> get props => [];
}

class ObjectInitial extends ObjectState {}

class ObjectLoaded extends ObjectState{
  final List<RBAC> objects;
  const ObjectLoaded({required this.objects});
}

class ObjectLoadingState extends ObjectState{

}

class ObjectErrorState extends ObjectState{
  final String message;
  const ObjectErrorState({required this.message});
}
class ObjectAddedState extends ObjectState {
  final Map<dynamic, dynamic> response;
  const ObjectAddedState({required this.response});
}
class ObjectUpdatedState extends ObjectState {
  final Map<dynamic, dynamic> response;
  const ObjectUpdatedState({required this.response});
}
class ObjectDeletedState extends ObjectState{
  final bool success;
  const ObjectDeletedState({required this.success});
}
class ObjectAddingErrorState extends ObjectState{
    final String? name;
  final String? slug;
  final String? shorthand;
  final int id;
  const ObjectAddingErrorState(
      {required this.id,
      required this.name,
      required this.shorthand,
      required this.slug});
}

class ObjectUpdatingErrorState extends ObjectState{
    final int objectId;
  final String name;
  final String? slug;
  final String? short;
  final int? createdBy;
  final int updatedBy;
    const ObjectUpdatingErrorState({
    required this.objectId,
    required this.createdBy,
    required this.name,
    required this.short,
    required this.slug,
    required this.updatedBy,
  });
}
class ObjectDeletingErrorState extends ObjectState{
    final int objectId;
    const ObjectDeletingErrorState({required this.objectId});
}