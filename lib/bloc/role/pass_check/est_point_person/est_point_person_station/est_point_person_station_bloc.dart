import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unit2/model/login_data/user_info/assigned_area.dart';
import 'package:unit2/model/utils/position.dart';
import '../../../../../model/rbac/rbac_station.dart';
import '../../../../../model/rbac/station_type.dart';
import '../../../../../sevices/roles/rbac_operations/station_services.dart';
part 'est_point_person_station_event.dart';
part 'est_point_person_station_state.dart';

class EstPointPersonStationBloc
    extends Bloc<EstPointPersonStationEvent, EstPointPersonStationState> {
  EstPointPersonStationBloc() : super(EstPointPersonStationInitial()) {
    List<RbacStation> stations = [];
    List<AssignedArea> assignAreas = [];
    List<StationType> stationTypes = [];
    List<PositionTitle> positions = [];
    on<EstPointPersonGetStations>((event, emit) async {
      emit(EstPersonStationLoadingState());
      try {
        if (stations.isEmpty) {
          stations = await RbacStationServices.instance
              .getStations(agencyId: event.agencyId);
        }
        if (stationTypes.isEmpty) {
          stationTypes = await RbacStationServices.instance.getStationTypes();
        }
        if (positions.isEmpty) {
          positions = await RbacStationServices.instance.getPositionTitle();
        }

        emit(EstPersonStationLoadedState(
            stations: stations,
            stationTypes: stationTypes,
            positions: positions));
      } catch (e) {
        emit(EstPersonStationErrorState(message: e.toString()));
      }
    });
    on<AddEstPointPersonStation>((event, emit) async {
      emit(EstPersonStationLoadingState());
      try {
        Map<dynamic, dynamic> statusResponse = await RbacStationServices
            .instance
            .addStation(station: event.station);
        if (statusResponse['success']) {
          RbacStation newStation = RbacStation.fromJson(statusResponse['data']);
          stations.add(newStation);
          emit(EstPointPersonAddedState(response: statusResponse));
        } else {
          emit(EstPointPersonAddedState(response: statusResponse));
        }
      } catch (e) {
        emit(EstPersonStationErrorState(message: e.toString()));
      }
    });
  }
}
