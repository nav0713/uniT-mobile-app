part of 'station_bloc.dart';

abstract class StationEvent extends Equatable {
  const StationEvent();

  @override
  List<Object> get props => [];
}

class GetStations extends StationEvent {
  final int agencyId;
  const GetStations({required this.agencyId});
        @override
  List<Object> get props => [agencyId];
}

class FilterStation extends StationEvent {
  final int agencyId;
  const FilterStation({required this.agencyId});
      @override
  List<Object> get props => [agencyId];
}
class AddRbacStation extends StationEvent {
  final RbacStation station;
  const AddRbacStation({required this.station});
}
