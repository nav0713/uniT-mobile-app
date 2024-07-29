import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unit2/model/rbac/role_extend.dart';
import 'package:unit2/sevices/roles/rbac_operations/role_extend_services.dart';

part 'unit2_roles_extend_event.dart';
part 'unit2_roles_extend_state.dart';

class Unit2RolesExtendBloc extends Bloc<Unit2RolesExtendEvent, Unit2RolesExtendState> {
  Unit2RolesExtendBloc() : super(Unit2RolesExtendInitial()) {
    List<RolesExtend> rolesExtend = [];
     on<GetUnit2RolesExtend>((event, emit) async {
      emit(Unit2RolesExtendLoadingState());
      try {
        if (rolesExtend.isEmpty) {
          rolesExtend = await RbacRoleExtendServices.instance.getUnit2RolesExtend(webUserId: event.webUserId);
        }

        emit(Unit2RolesExtendLoadedState(rolesExtend: rolesExtend));
      } catch (e) {
        emit(Unit2RolesExtendErrorState(message: e.toString()));
      }
    });
  }
}
