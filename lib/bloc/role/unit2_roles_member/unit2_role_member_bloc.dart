import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'unit2_role_member_event.dart';
part 'unit2_role_member_state.dart';

class Unit2RoleMemberBloc extends Bloc<Unit2RoleMemberEvent, Unit2RoleMemberState> {
  Unit2RoleMemberBloc() : super(Unit2RoleMemberInitial()) {
    on<Unit2RoleMemberEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
