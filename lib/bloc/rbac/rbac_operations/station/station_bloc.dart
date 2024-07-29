import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unit2/model/rbac/rbac_station.dart';
import 'package:unit2/sevices/roles/rbac_operations/station_services.dart';
import '../../../../model/rbac/station_type.dart';
import '../../../../model/utils/agency.dart';
import '../../../../model/utils/position.dart';
import '../../../../utils/profile_utilities.dart';
part 'station_event.dart';
part 'station_state.dart';

class StationBloc extends Bloc<StationEvent, StationState> {
  StationBloc() : super(StationInitial()) {
    List<RbacStation> stations = [];
    List<Agency> agencies = [];
    List<StationType> stationTypes = [];
    List<PositionTitle> positions = [];
    on<GetStations>((event, emit) async {
      emit(StationLoadingState());
      try {
        stations = await RbacStationServices.instance
            .getStations(agencyId: event.agencyId.toString());

        if (agencies.isEmpty) {
          List<Agency> newAgencies =
              await ProfileUtilities.instance.getAgecies();
          agencies = newAgencies;
        }
        if (stationTypes.isEmpty) {
          stationTypes = await RbacStationServices.instance.getStationTypes();
        }
        if (positions.isEmpty) {
          positions = await RbacStationServices.instance.getPositionTitle();
        }
        emit(StationLoadedState(
            stations: stations,
            agencies: agencies,
            stationTypes: stationTypes,
            positions: positions));
      } catch (e) {
        emit(StationErrorState(message: e.toString()));
      }
    });
    on<AddRbacStation>((event, emit) async {
      emit(StationLoadingState());
      try {
        Map<dynamic, dynamic> statusResponse = await RbacStationServices
            .instance
            .addStation(station: event.station);
        if (statusResponse['success']) {
          RbacStation newStation = RbacStation.fromJson(statusResponse['data']);
          stations.add(newStation);
          emit(RbacStationAddedState(response: statusResponse));
        } else {
          emit(RbacStationAddedState(response: statusResponse));
        }
      } catch (e) {
        emit(StationErrorState(message: e.toString()));
      }
    });
    on<FilterStation>((event, emit) async {
      emit(StationLoadingState());
  
      try {
        stations = await RbacStationServices.instance
            .getStations(agencyId: event.agencyId.toString());

        if (agencies.isEmpty) {
          List<Agency> newAgencies =
              await ProfileUtilities.instance.getAgecies();
          agencies = newAgencies;
        }
        emit(StationLoadedState(
            stations: stations,
            agencies: agencies,
            positions: positions,
            stationTypes: stationTypes));
      } catch (e) {
        emit(StationErrorState(message: e.toString()));
      }
    });

     
  }
}
