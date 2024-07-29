part of 'operation_bloc.dart';

abstract class OperationEvent extends Equatable {
  const OperationEvent();

  @override
  List<Object> get props => [];
}
class GetOperations extends OperationEvent{
  
}
class AddRbacOperation extends OperationEvent {
  final String? name;
  final String? slug;
  final String? shorthand;
  final int id;
  const AddRbacOperation(
      {required this.id,
      required this.name,
      required this.shorthand,
      required this.slug});
}


class UpdateRbacOperation extends OperationEvent {
  final int operationId;
  final String name;
  final String? slug;
  final String? short;
  final int? createdBy;
  final int updatedBy;
  const UpdateRbacOperation({
    required this.operationId,
    required this.createdBy,
    required this.name,
    required this.short,
    required this.slug,
    required this.updatedBy,
  });
}

class DeleteRbacOperation extends OperationEvent {
  final int operationId;
  const DeleteRbacOperation({required this.operationId});
}
