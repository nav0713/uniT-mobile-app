import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unit2/model/rbac/rbac.dart';
import 'package:unit2/sevices/roles/rbac_operations/operation_services.dart';

part 'operation_event.dart';
part 'operation_state.dart';

class OperationBloc extends Bloc<OperationEvent, OperationState> {
  OperationBloc() : super(OperationInitial()) {
    List<RBAC> operations = [];
    on<OperationEvent>((event, emit) async {
      emit(OperationLoadingState());
      try {
        if (operations.isEmpty) {
          operations = await RbacOperationServices.instance.getRbacOperations();
        }

        emit(OperationsLoaded(operations: operations));
      } catch (e) {
        emit(OperationErrorState(message: e.toString()));
      }
    });
    on<AddRbacOperation>((event, emit) async {
      try {
        emit(OperationLoadingState());
        Map<dynamic, dynamic> statusResponse =
            await RbacOperationServices.instance.add(
                name: event.name!,
                slug: event.slug,
                short: event.shorthand,
                id: event.id);
        if (statusResponse['success']) {
          RBAC newOperation = RBAC.fromJson(statusResponse['data']);
          operations.add(newOperation);
          emit(OperationAddedState(response: statusResponse));
        } else {
          emit(OperationAddedState(response: statusResponse));
        }
      } catch (e) {
        emit(OperationErrorAddingState(
            id: event.id,
            name: event.name,
            shorthand: event.shorthand,
            slug: event.slug));
      }
    });
    on<UpdateRbacOperation>((event, emit) async {
      emit(OperationLoadingState());
      try {
        Map<dynamic, dynamic> statusResponse =
            await RbacOperationServices.instance.update(
                name: event.name,
                slug: event.slug,
                short: event.short,
                operationId: event.operationId,
                createdBy: event.createdBy,
                updatedBy: event.updatedBy);

        if (statusResponse['success']) {
          operations.removeWhere((element) => element.id == event.operationId);
          RBAC newRole = RBAC.fromJson(statusResponse['data']);
          operations.add(newRole);
          emit(OperationUpdatedState(response: statusResponse));
        } else {
          emit(OperationUpdatedState(response: statusResponse));
        }
      } catch (e) {
        emit(OperationErrorUpdatingState(
            createdBy: event.createdBy,
            name: event.name,
            operationId: event.operationId,
            short: event.short,
            slug: event.slug,
            updatedBy: event.updatedBy));
      }
    });
    on<DeleteRbacOperation>((event, emit) async {
      emit(OperationLoadingState());
      try {
        bool success = await RbacOperationServices.instance
            .delete(operation: event.operationId);
        if (success) {
          operations.removeWhere((element) => element.id == event.operationId);
          emit(OperationDeletedState(success: success));
        } else {
          emit(OperationDeletedState(success: success));
        }
      } catch (e) {
        emit(OperationErrorDeletingState(operationId: event.operationId));
      }
    });
  }
}
