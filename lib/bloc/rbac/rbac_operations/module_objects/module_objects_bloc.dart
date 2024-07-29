import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unit2/model/rbac/rbac_rbac.dart';
import 'package:unit2/sevices/roles/rbac_operations/module_objects_services.dart';
import 'package:unit2/sevices/roles/rbac_operations/object_services.dart';

import '../../../../model/rbac/rbac.dart';
import '../../../../sevices/roles/rbac_operations/module_services.dart';
part 'module_objects_event.dart';
part 'module_objects_state.dart';

class ModuleObjectsBloc extends Bloc<ModuleObjectsEvent, ModuleObjectsState> {
  ModuleObjectsBloc() : super(ModuleObjectsInitial()) {
    List<ModuleObjects> moduleObjects = [];
    List<RBAC> objects = [];
    List<RBAC> modules = [];
    List<int> ids = [];
    on<GetModuleObjects>((event, emit) async {
      emit(ModuleObjectLoadingState());
      try {
        if (moduleObjects.isEmpty) {
          moduleObjects =
              await RbacModuleObjectsServices.instance.getModuleObjects();
        }
        if (objects.isEmpty) {
          objects = await RbacObjectServices.instance.getRbacObjects();
        }
        if (modules.isEmpty) {
          modules = await RbacModuleServices.instance.getRbacModule();
        }
        ids =[];
        for(var mo in moduleObjects){
          ids.add(mo.id);
        }
        emit(ModuleObjectLoadedState(
            moduleObjects: moduleObjects, objecs: objects, modules: modules,ids: ids));
      } catch (e) {
        emit(ModuleObjectsErrorState(message: e.toString()));
      }
    });
    on<AddRbacModuleObjects>((event, emit) async {
      try {
        emit(ModuleObjectLoadingState());
        Map<dynamic, dynamic> statusResponse =
            await RbacModuleObjectsServices.instance.add(
                assignerId: event.assignerId,
                moduleId: event.moduleId,
                objectsId: event.objectsId);

        if (statusResponse['success']) {
          statusResponse['data'].forEach((var permission) {
            ModuleObjects newModuleObject = ModuleObjects.fromJson(permission);
            if(!ids.contains(newModuleObject.id)){
              moduleObjects.add(newModuleObject);
            }
            emit(ModuleObjectAddedState(response: statusResponse));
          });
        } else {
          emit(ModuleObjectAddedState(response: statusResponse));
        }
      } catch (e) {
        emit(ModuleObjectErrorAddingState(assignerId: event.assignerId,moduleId: event.moduleId,objectsId: event.objectsId));
      }
    });
    on<DeleteRbacModuleObject>((event, emit) async {
      emit(ModuleObjectLoadingState());
      try {
        bool success = await RbacModuleObjectsServices.instance
            .delete(moduleObjectId: event.moduleObjectId);
        if (success) {
          moduleObjects
              .removeWhere((element) => element.id == event.moduleObjectId);
          emit(ModuleObjectDeletedState(success: success));
        } else {
          emit(ModuleObjectDeletedState(success: success));
        }
      } catch (e) {
        emit(ModuleObjectErrorDeletingState(moduleObjectId: event.moduleObjectId));
      }
    });
  }
}
