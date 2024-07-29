part of 'station_bloc.dart';

abstract class StationState extends Equatable {
  const StationState();

  @override
  List<Object> get props => [];
}

class StationInitial extends StationState {}

class StationLoadedState extends StationState {
  final List<Agency> agencies;
  final List<RbacStation> stations;
  final List<StationType> stationTypes;
  final List<PositionTitle> positions;
  const StationLoadedState({required this.stations, required this.agencies,required this.positions, required this.stationTypes});
    @override
  List<Object> get props => [agencies,stations,stationTypes,positions];
}

class StationLoadingState extends StationState {}

class StationErrorState extends StationState {
  final String message;
  const StationErrorState({required this.message});
    @override
  List<Object> get props => [message];
}

class FilterStationState extends StationState {
  final List<Agency> agencies;
  final List<RbacStation> stations;
  final List<StationType> stationTypes;
  final List<PositionTitle> positions;
  const FilterStationState({required this.stations, required this.agencies,required this.positions, required this.stationTypes});
    @override
  List<Object> get props => [agencies,stations,stationTypes,positions];
}

class RbacStationAddedState extends StationState{
 final Map<dynamic,dynamic> response;
 const RbacStationAddedState({required this.response});
}

