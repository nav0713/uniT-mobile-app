import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unit2/sevices/roles/rbac_operations/object_services.dart';

import '../../../../model/rbac/rbac.dart';

part 'object_event.dart';
part 'object_state.dart';

class ObjectBloc extends Bloc<ObjectEvent, ObjectState> {
  ObjectBloc() : super(ObjectInitial()) {
    List<RBAC> objects = [];
    on<GetObjects>((event, emit) async {
      emit(ObjectLoadingState());
      try {
        if (objects.isEmpty) {
          objects = await RbacObjectServices.instance.getRbacObjects();
        }
        emit(ObjectLoaded(objects: objects));
      } catch (e) {
        emit(ObjectErrorState(message: e.toString()));
      }
    });
      ////Add
    on<AddRbacObject>((event, emit) async {
      try {
        emit(ObjectLoadingState());
        Map<dynamic, dynamic> statusResponse = await RbacObjectServices.instance
            .add(
                name: event.name!,
                slug: event.slug,
                short: event.shorthand,
                id: event.id);
        if (statusResponse['success']) {
          RBAC newObject = RBAC.fromJson(statusResponse['data']);
          objects.add(newObject);
          emit(ObjectAddedState(response: statusResponse));
        } else {
          emit(ObjectAddedState(response: statusResponse));
        }
      } catch (e) {
        emit(ObjectAddingErrorState(id: event.id,name: event.name,shorthand: event.shorthand, slug: event.slug));
      }
    });
    on<UpdateRbacObject>((event, emit) async {
      emit(ObjectLoadingState());
      try {
        Map<dynamic, dynamic> statusResponse = await RbacObjectServices.instance
            .update(
                name: event.name,
                slug: event.slug,
                short: event.short,
                objectId: event.objectId,
                createdBy: event.createdBy,
                updatedBy: event.updatedBy);

        if (statusResponse['success']) {
          objects.removeWhere((element) => element.id == event.objectId);
          RBAC newObject = RBAC.fromJson(statusResponse['data']);
          objects.add(newObject);
          emit(ObjectUpdatedState(response: statusResponse));
        } else {
          emit(ObjectUpdatedState(response: statusResponse));
        }
      } catch (e) {
        emit(ObjectUpdatingErrorState(objectId: event.objectId,createdBy: event.createdBy,name: event.name,short: event.short,slug: event.slug,updatedBy: event.updatedBy));
      }
    });
    on<DeleteRbacObject>((event, emit) async {
      emit(ObjectLoadingState());
      try {
        bool success = await RbacObjectServices.instance
            .deleteRbacRole(objectId: event.objectId);
        if (success) {
          objects.removeWhere((element) => element.id == event.objectId);
          emit(ObjectDeletedState(success: success));
        } else {
          emit(ObjectDeletedState(success: success));
        }
      } catch (e) {
        emit(ObjectDeletingErrorState(objectId: event.objectId));
      }
    });
  }
  }
  

