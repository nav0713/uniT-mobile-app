import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unit2/sevices/roles/rbac_operations/module_services.dart';
import '../../../../model/rbac/rbac.dart';
part 'module_event.dart';
part 'module_state.dart';

class ModuleBloc extends Bloc<ModuleEvent, ModuleState> {
  ModuleBloc() : super(ModuleInitial()) {
    List<RBAC> modules = [];
    on<GetModule>((event, emit) async {
      emit(ModuleLoadingState());
      try {
        if (modules.isEmpty) {
          modules = await RbacModuleServices.instance.getRbacModule();
        }

        emit(ModuleLoaded(module: modules));
      } catch (e) {
        emit(ModuleErrorState(message: e.toString()));
      }
    }); ////Add
    on<AddRbacModule>((event, emit) async {
      try {
        emit(ModuleLoadingState());
        Map<dynamic, dynamic> statusResponse = await RbacModuleServices.instance
            .add(
                name: event.name!,
                slug: event.slug,
                short: event.shorthand,
                id: event.id);
        if (statusResponse['success']) {
          RBAC newRole = RBAC.fromJson(statusResponse['data']);
          modules.add(newRole);
          emit(ModuleAddedState(response: statusResponse));
        } else {
          emit(ModuleAddedState(response: statusResponse));
        }
      } catch (e) {
        emit(ModuleErrorAddingState(id: event.id,name: event.name,shorthand: event.shorthand,slug: event.slug));
      }
    });
    ////update
    on<UpdateRbacModule>((event, emit) async {
      emit(ModuleLoadingState());
      try {
        Map<dynamic, dynamic> statusResponse = await RbacModuleServices.instance
            .update(
                name: event.name,
                slug: event.slug,
                short: event.short,
                moduleId: event.moduleId,
                createdBy: event.createdBy,
                updatedBy: event.updatedBy);

        if (statusResponse['success']) {
          modules.removeWhere((element) => element.id == event.moduleId);
          RBAC newRole = RBAC.fromJson(statusResponse['data']);
          modules.add(newRole);
          emit(ModuleUpdatedState(response: statusResponse));
        } else {
          emit(ModuleUpdatedState(response: statusResponse));
        }
      } catch (e) {
        emit(ModuleErrorUpdatingState(createdBy: event.createdBy,moduleId: event.moduleId,name: event.name,short: event.short,slug: event.slug,updatedBy: event.updatedBy));
      }
    });
    on<DeleteRbacModule>((event, emit) async {
      emit(ModuleLoadingState());
      try {
        bool success = await RbacModuleServices.instance
            .deleteRbacModule(moduleId: event.moduleId);
        if (success) {
          modules.removeWhere((element) => element.id == event.moduleId);
          emit(ModuleDeletedState(success: success));
        } else {
          emit(ModuleDeletedState(success: success));
        }
      } catch (e) {
        emit(ModuleErrorDeletingState(moduleId: event.moduleId));
      }
    });
  }
}
