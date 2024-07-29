import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unit2/model/rbac/role_under.dart';
import '../../../../sevices/roles/unit2_role_assignment/unit2_role_assignment_services.dart';
part 'unit2_assignable_role_event.dart';
part 'unit2_assinable_role_state.dart';

class Unit2AssinableRoleBloc extends Bloc<
    Unit2AssinableRoleEvent, Unit2AssinableRoleState> {
  Unit2AssinableRoleBloc()
      : super(Unit2AssinableRoleInitial()) {
    List<RolesUnder> rolesUnder = [];
    on<GetUnit2AssignableRoles>((event, emit) async {
      emit(Unit2AssignableRoleLoadingState());
      try {
        if (rolesUnder.isEmpty) {
          List<RolesUnder> rolesUnders = await EstPointPersonRoleAssignment
              .instance
              .getRoleUnderFilterByUser(userId: event.userId);
        rolesUnder  = rolesUnders;
        }

        emit(Unit2AssignableRoleLoaded(
             rolesUnder: rolesUnder));
      } catch (e) {
        emit(Unit2AssignableErrorState(message: e.toString()));
      }
    });
      }
}
