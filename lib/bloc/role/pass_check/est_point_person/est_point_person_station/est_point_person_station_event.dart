part of 'est_point_person_station_bloc.dart';

abstract class EstPointPersonStationEvent extends Equatable {
  const EstPointPersonStationEvent();

  @override
  List<Object> get props => [];
}

class EstPointPersonGetStations extends EstPointPersonStationEvent {
  final String agencyId;
  const EstPointPersonGetStations(
      {required this.agencyId});
}

class AddEstPointPersonStation extends EstPointPersonStationEvent {
  final RbacStation station;
  const AddEstPointPersonStation({required this.station});
}
