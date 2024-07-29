part of 'est_point_person_station_bloc.dart';

abstract class EstPointPersonStationState extends Equatable {
  const EstPointPersonStationState();
  
  @override
  List<Object> get props => [];
}

class EstPointPersonStationInitial extends EstPointPersonStationState {}

class EstPersonStationLoadedState extends EstPointPersonStationState {
  final List<RbacStation> stations;
  final List<StationType> stationTypes;
  final List<PositionTitle> positions;
  const EstPersonStationLoadedState({required this.stations, required this.stationTypes, required this.positions});
    @override
  List<Object> get props => [stations];
}

class EstPersonStationLoadingState extends EstPointPersonStationState {}

class EstPersonStationErrorState extends EstPointPersonStationState {
  final String message;
  const EstPersonStationErrorState({required this.message});
    @override
  List<Object> get props => [message];
}

class EstPointPersonAddedState extends EstPointPersonStationState{
 final Map<dynamic,dynamic> response;
 const EstPointPersonAddedState({required this.response});
}