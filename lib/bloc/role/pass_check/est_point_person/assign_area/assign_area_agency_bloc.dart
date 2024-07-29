import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unit2/model/login_data/user_info/assigned_area.dart';
import 'package:unit2/model/utils/agency.dart';
import 'package:unit2/model/utils/category.dart';

import '../../../../../utils/profile_utilities.dart';

part 'assign_area_agency_event.dart';
part 'assign_area_agency_state.dart';

class AssignAreaAgencyBloc
    extends Bloc<AssignAreaAgencyEvent, AssignAreaAgencyState> {
  AssignAreaAgencyBloc() : super(AssignAreaAgencyInitial()) {
    List<AssignedArea>? agencies = [];
    List<Category> agencyCategory = [];
    on<EstPointPersonGetAgencies>((event, emit) async {
      emit(EstPointPersonAgencyLoadingState());
      try {
        if (agencyCategory.isEmpty) {
          agencyCategory = await ProfileUtilities.instance.agencyCategory();
        }
        agencies = event.assignedAreas;
        emit(EstPointPersonAgenciesLoaded(
            agencies: agencies, agencyCategory: agencyCategory));
      } catch (e) {
        emit(EstPointAgencyErrorState(message: e.toString()));
      }
    });
  }
}
