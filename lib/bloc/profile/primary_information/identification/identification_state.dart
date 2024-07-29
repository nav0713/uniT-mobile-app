part of 'identification_bloc.dart';

abstract class IdentificationState extends Equatable {
  const IdentificationState();

  @override
  List<Object> get props => [];
}

class IdentificationInitial extends IdentificationState {}

class IdentificationLoadedState extends IdentificationState {
  final List<Identification> identificationInformation;
  const IdentificationLoadedState({required this.identificationInformation});
  @override
  List<Object> get props => [identificationInformation];
}

class IdenficationErrorState extends IdentificationState {
  final String message;
  const IdenficationErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class IdentificationAddingErrorState extends IdentificationState {
  final Identification identification;
  const IdentificationAddingErrorState(
      {required this.identification,});
}
class IdentificationEditErrorState extends IdentificationState {
  final Identification identification;
  const IdentificationEditErrorState(
      {required this.identification,});
}

class IdentificationDeleteErrorState extends IdentificationState{
  final int identificationId;
  const IdentificationDeleteErrorState({required this.identificationId});
}

class IdentificationLoadingState extends IdentificationState {}

class IdentificationDeletedState extends IdentificationState {
  final bool success;
  const IdentificationDeletedState({required this.success});
  @override
  List<Object> get props => [success];
}

class IdentificationAddedState extends IdentificationState {
  final Map<dynamic, dynamic> response;
  const IdentificationAddedState({required this.response});
  @override
  List<Object> get props => [response];
}

class IdentificationEditedState extends IdentificationState {
  final Map<dynamic, dynamic> response;
  const IdentificationEditedState({required this.response});
  @override
  List<Object> get props => [response];
}

class IdentificationAddingState extends IdentificationState {
  final List<Agency> agencies;
  final List<Agency> addedAgencies;
  final List<Country> countries;
  final List<Region> regions;
  final List<Category> agencyCategory;
  const IdentificationAddingState(
      {required this.agencies,
      required this.countries,
      required this.regions,
      required this.agencyCategory,
      required this.addedAgencies});
  @override
  List<Object> get props => [agencies, countries, regions, agencyCategory];
}

class IdentificationEditingState extends IdentificationState {
  final Identification identification;
  final List<Country> countries;
  final List<Region> regions;
  final List<Province> provinces;
  final List<CityMunicipality> cities;
  final Region? currentRegion;
  final Country currentCountry;
  final Province? currentProvince;
  final CityMunicipality? currentCity;
  final bool overseas;
  const IdentificationEditingState(
      {required this.cities,
      required this.countries,
      required this.currentCity,
      required this.currentCountry,
      required this.currentProvince,
      required this.currentRegion,
      required this.identification,
      required this.overseas,
      required this.provinces,
      required this.regions});
}
class ShowAddFormErrorState extends IdentificationState{
  
}

class ShowEditFormErrorState extends IdentificationState{
  final Identification identification;
  final bool isOverseas;
  const ShowEditFormErrorState({required this.identification, required this.isOverseas});
    @override
    List<Object> get props => [identification,isOverseas];
}