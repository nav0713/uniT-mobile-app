part of 'operation_bloc.dart';

abstract class OperationState extends Equatable {
  const OperationState();

  @override
  List<Object> get props => [];
}

class OperationInitial extends OperationState {}

class OperationsLoaded extends OperationState {
  final List<RBAC> operations;
  const OperationsLoaded({required this.operations});
}

class OperationLoadingState extends OperationState {}

class OperationErrorState extends OperationState {
  final String message;
  const OperationErrorState({required this.message});
}

class OperationAddedState extends OperationState {
  final Map<dynamic, dynamic> response;
  const OperationAddedState({required this.response});
}

class OperationUpdatedState extends OperationState {
  final Map<dynamic, dynamic> response;
  const OperationUpdatedState({required this.response});
}

class OperationDeletedState extends OperationState {
  final bool success;
  const OperationDeletedState({required this.success});
}

class OperationErrorAddingState extends OperationState {
  final String? name;
  final String? slug;
  final String? shorthand;
  final int id;
  const OperationErrorAddingState(
      {required this.id,
      required this.name,
      required this.shorthand,
      required this.slug});
}

class OperationErrorUpdatingState extends OperationState {
  final int operationId;
  final String name;
  final String? slug;
  final String? short;
  final int? createdBy;
  final int updatedBy;
  const OperationErrorUpdatingState(
      {required this.createdBy,
      required this.name,
      required this.operationId,
      required this.short,
      required this.slug,
      required this.updatedBy});
}

class OperationErrorDeletingState extends OperationState {
  final int operationId;
  const OperationErrorDeletingState({required this.operationId});
}
