import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unit2/model/rbac/permission.dart';
import 'package:unit2/sevices/roles/rbac_services.dart';

import '../../model/rbac/new_permission.dart';
import '../../model/rbac/rbac.dart';

part 'rbac_event.dart';
part 'rbac_state.dart';

class RbacBloc extends Bloc<RbacEvent, RbacState> {
  
  RbacBloc() : super(RbacInitial()) {
    List<RBAC>? modules;
    List<RBAC>? objects;
    List<RBAC>? roles;
    List<RBACPermission>? permissions;
    List<RBAC>? operations;
    on<SetRbacScreen>((event, emit) async {
      emit(RbacLoadingState());
      try {
        modules = await RbacServices.instance.getModules();
        objects = await RbacServices.instance.getObjects();
        roles = await RbacServices.instance.getRole();
        permissions = await RbacServices.instance.getPermission();
        operations = await RbacServices.instance.getOperations();
        emit(RbacScreenSetted(modules: modules!, objects: objects!, operations: operations!, permission: permissions!, role: roles!));
      } catch (e) {
        emit(RbacErrorState(message: e.toString()));
      }
    });on<AssignedRbac>((event, emit)async{
      try{
        emit(RbacLoadingState());
        Map responseStatus = await RbacServices.instance.assignRBAC(assigneeId: event.assigneeId, assignerId: event.assignerId, selectedRole: event.selectedRole, selectedModule: event.selectedModule, permissionId: event.permissionId, newPermissions: event.newPermissions);
        emit(RbacAssignedState(responseStatus: responseStatus));
      }catch(e){
        emit(RbacErrorState(message: e.toString()));
      }
    });
    on<LoadRbac>((event,emit){
 emit(RbacScreenSetted(modules: modules!, objects: objects!, operations: operations!, permission: permissions!, role: roles!));
    });
  }
}
