import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unit2/model/rbac/permission.dart';
import 'package:unit2/model/rbac/rbac.dart';
import 'package:unit2/sevices/roles/rbac_operations/permission_service.dart';

import '../../../../sevices/roles/rbac_operations/object_services.dart';
import '../../../../sevices/roles/rbac_operations/operation_services.dart';

part 'permission_event.dart';
part 'permission_state.dart';

class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  PermissionBloc() : super(PermissionInitial()) {
    List<RBACPermission> permissions = [];
    List<RBAC> objects = [];
    List<RBAC> operations = [];
    on<GetPermissions>((event, emit) async {
      try {
        emit(PermissonLoadingState());
        if (permissions.isEmpty) {
          permissions =
              await RbacPermissionServices.instance.getRbacPermission();
        }
        if (objects.isEmpty) {
          objects = await RbacObjectServices.instance.getRbacObjects();
        }
        if (operations.isEmpty) {
          operations = await RbacOperationServices.instance.getRbacOperations();
        }
        emit(PermissionLoaded(
            permissions: permissions,
            objects: objects,
            operations: operations));
      } catch (e) {
        emit(PermissionErrorState(message: e.toString()));
      }
    });
    ////Add
    on<AddRbacPermission>((event, emit) async {
      try {
        emit(PermissonLoadingState());
        Map<dynamic, dynamic> statusResponse =
            await RbacPermissionServices.instance.add(
                assignerId: event.assignerId,
                objectId: event.objectId,
                operationsId: event.operationIds);
        if (statusResponse['success']) {
          statusResponse['data'].forEach((var permission) {
            RBACPermission newPermission = RBACPermission.fromJson(permission);
            permissions.add(newPermission);
          });

          emit(PermissionAddedState(response: statusResponse));
        } else {
          emit(PermissionAddedState(response: statusResponse));
        }
      } catch (e) {
        emit(PermissionErrorAddingState(assignerId: event.assignerId,objectId: event.objectId,operationIds: event.operationIds));
      }
    });
    ////Delete
    on<DeleteRbacPermission>((event, emit) async {
      emit(PermissonLoadingState());
      try {
        bool success = await RbacPermissionServices.instance
            .deletePermission(permissionId: event.permissionId);
        if (success) {
          permissions
              .removeWhere((element) => element.id == event.permissionId);
          emit(PermissionDeletedState(success: success));
        } else {
          emit(PermissionDeletedState(success: success));
        }
      } catch (e) {
        emit(PermissionErrorDeletingState(permissionId: event.permissionId));
      }
    });
  }
}
