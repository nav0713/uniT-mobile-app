part of 'object_bloc.dart';

abstract class ObjectEvent extends Equatable {
  const ObjectEvent();

  @override
  List<Object> get props => [];
}

class GetObjects extends ObjectEvent{
  
}
class AddRbacObject extends ObjectEvent {
  final String? name;
  final String? slug;
  final String? shorthand;
  final int id;
  const AddRbacObject(
      {required this.id,
      required this.name,
      required this.shorthand,
      required this.slug});
}


class UpdateRbacObject extends ObjectEvent {
  final int objectId;
  final String name;
  final String? slug;
  final String? short;
  final int? createdBy;
  final int updatedBy;
  const UpdateRbacObject({
    required this.objectId,
    required this.createdBy,
    required this.name,
    required this.short,
    required this.slug,
    required this.updatedBy,
  });
}

class DeleteRbacObject extends ObjectEvent {
  final int objectId;
  const DeleteRbacObject({required this.objectId});
}
