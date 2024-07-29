import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unit2/model/login_data/user_info/assigned_area.dart';
import 'package:unit2/model/utils/agency.dart';
import 'package:unit2/utils/profile_utilities.dart';
import '../../../../model/utils/category.dart';
import '../../../../sevices/roles/rbac_operations/agency_services.dart';

part 'agency_event.dart';
part 'agency_state.dart';

class AgencyBloc extends Bloc<AgencyEvent, AgencyState> {
  AgencyBloc() : super(AgencyInitial()) {
    List<Agency> agencies = [];
    List<Category> agencyCategory = [];
    on<GetAgencies>((event, emit) async {
      emit(AgencyLoadingState());
      try {
        if (agencies.isEmpty) {
          agencies = await AgencyServices.instance.getAgencies();
        }
        if (agencyCategory.isEmpty) {
          agencyCategory = await ProfileUtilities.instance.agencyCategory();
        }
        emit(
            AgenciesLoaded(agencies: agencies, agencyCategory: agencyCategory));
      } catch (e) {
        emit(AgencyErrorState(message: e.toString()));
      }
    });
    on<GetEstPointPersonAgencies>((event,emit)async{
       if (agencyCategory.isEmpty) {
          agencyCategory = await ProfileUtilities.instance.agencyCategory();
        }
    });
    on<AddAgency>((event, emit) async {
      emit(AgencyLoadingState());
      try {
        Map<dynamic, dynamic> statusResponse =
            await AgencyServices.instance.add(agency: event.agency);
        if (statusResponse['success']) {
          Agency newAgency = Agency.fromJson(statusResponse['data']);
          agencies.insert(0,newAgency);
          emit(AgencyAddesState(response: statusResponse));
        } else {
          emit(AgencyAddesState(response: statusResponse));
        }
      } catch (e) {
        emit(AgencyAddingErrorState(agency: event.agency));
      }
    });
  }
}
