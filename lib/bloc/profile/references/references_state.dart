part of 'references_bloc.dart';

abstract class ReferencesState extends Equatable {
  const ReferencesState();

  @override
  List<Object> get props => [];
}

class ReferencesInitial extends ReferencesState {}

class ReferencesLoadedState extends ReferencesState {
  final List<PersonalReference> references;
  const ReferencesLoadedState({required this.references});

  @override
  List<Object> get props => [references];
}

class ReferencesErrorState extends ReferencesState {
  final String message;
  const ReferencesErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class ReferencesLoadingState extends ReferencesState {}

class ReferencesAddedState extends ReferencesState {
  final Map<dynamic, dynamic> response;
  const ReferencesAddedState({required this.response});
  @override
  List<Object> get props => [response];
}

class ReferenceEditedState extends ReferencesState {
  final Map<dynamic, dynamic> response;
  const ReferenceEditedState({required this.response});
  @override
  List<Object> get props => [response];
}

class EditReferenceState extends ReferencesState {
  final List<Region> regions;
  final List<Country> countries;
  final List<AddressCategory> categories;
  final List<Province>? provinces;
  final List<CityMunicipality>? cities;
  final List<Barangay>? barangays;
  final PersonalReference ref;
  final bool isOverseas;
  final Region? selectedRegion;
  final Province? selectedProvince;
  final CityMunicipality? selectedCity;
  final AddressCategory selectedCategory;
  final Barangay? selectedBarangay;
  final Country? selectedCountry;
  const EditReferenceState(
      {this.barangays,
      this.selectedBarangay,
      required this.selectedCategory,
      this.cities,
      this.selectedCity,
      this.provinces,
      this.selectedProvince,
      this.selectedRegion,
      this.selectedCountry,
      required this.isOverseas,
      required this.ref,
      required this.categories,
      required this.countries,
      required this.regions});
  @override
  List<Object> get props => [regions, countries, categories, isOverseas];
}

class AddReferenceState extends ReferencesState {
  final List<Region> regions;
  final List<Country> countries;
  final List<AddressCategory> categories;
  const AddReferenceState(
      {required this.categories,
      required this.countries,
      required this.regions});
}

class DeleteReferenceState extends ReferencesState {
  final bool success;
  const DeleteReferenceState({required this.success});
}

class ReferencesAddingErrorState extends ReferencesState {
  final PersonalReference reference;
  const ReferencesAddingErrorState({required this.reference});
}

class ReferenceUpdatingErrorState extends ReferencesState {
  final PersonalReference reference;
  const ReferenceUpdatingErrorState({required this.reference});
}

class ReferenceDeletingErrorState extends ReferencesState {
  final List<PersonalReference> references;
  final int refId;
  const ReferenceDeletingErrorState(
      {required this.refId, required this.references});
}
class ShowAddFormErrorState extends ReferencesState{
  
}

class ShowEditFormErrorState extends ReferencesState{
  final PersonalReference personalReference;
const ShowEditFormErrorState({required this.personalReference});
}

