part of 'voluntary_work_bloc.dart';

abstract class VoluntaryWorkState extends Equatable {
  const VoluntaryWorkState();

  @override
  List<Object> get props => [];
}

class VoluntaryWorkInitial extends VoluntaryWorkState {}

////Loaded State
class VoluntaryWorkLoadedState extends VoluntaryWorkState {
  final List<VoluntaryWork> voluntaryWorks;
  const VoluntaryWorkLoadedState({required this.voluntaryWorks});
  @override
  List<Object> get props => [voluntaryWorks];
}

////Error State
class VoluntaryWorkErrorState extends VoluntaryWorkState {
  final String message;
  const VoluntaryWorkErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

////Loading State
class VoluntaryWorkLoadingState extends VoluntaryWorkState {}

////Added State
class VoluntaryWorkAddedState extends VoluntaryWorkState {
  final Map<dynamic, dynamic> response;
  const VoluntaryWorkAddedState({required this.response});
  @override
  List<Object> get props => [response];
}

////Edited State
class VoluntaryWorkEditedState extends VoluntaryWorkState {
  final Map<dynamic, dynamic> response;
  const VoluntaryWorkEditedState({required this.response});
  @override
  List<Object> get props => [response];
}

class EditVoluntaryWorks extends VoluntaryWorkState {
  final VoluntaryWork work;
  final List<PositionTitle> positions;
  final List<Agency> agencies;
  final List<Category> agencyCategory;
  final List<Country> countries;
  final List<Region> regions;
  final List<Province> provinces;
  final List<CityMunicipality> cities;
  final PositionTitle currentPosition;
  final Agency currentAgency;
  final Region? currentRegion;
  final Country currentCountry;
  final Province? currentProvince;
  final CityMunicipality? currentCity;
  final bool overseas;
  const EditVoluntaryWorks(
      {required this.agencies,
      required this.agencyCategory,
      required this.cities,
      required this.countries,
      required this.positions,
      required this.provinces,
      required this.regions,
      required this.work,
      required this.currentAgency,
      required this.currentCity,
      required this.currentCountry,
      required this.currentPosition,
      required this.currentProvince,
      required this.currentRegion,
      required this.overseas});
}

////Adding State
class AddVoluntaryWorkState extends VoluntaryWorkState {
  final List<PositionTitle> positions;
  final List<Agency> agencies;
  final List<Category> agencyCategory;
  final List<Country> countries;
  final List<Region> regions;
  const AddVoluntaryWorkState(
      {required this.agencies,
      required this.countries,
      required this.positions,
      required this.regions,
      required this.agencyCategory});
  @override
  List<Object> get props => [positions, agencies, countries, regions];
}

////Add Attachment
class AttachmentAddedState extends VoluntaryWorkState {
  final Map<dynamic, dynamic> response;
  const AttachmentAddedState({required this.response});
}

//// Deleted State
class VoluntaryWorkDeletedState extends VoluntaryWorkState {
  final bool success;
  const VoluntaryWorkDeletedState({required this.success});
  @override
  List<Object> get props => [success];
}

class VolunataryWorkHistoryAddingErrorState extends VoluntaryWorkState {
  final VoluntaryWork work;
  const VolunataryWorkHistoryAddingErrorState({required this.work});
}

class VoluntaryWorkHistoryEditingErrorState extends VoluntaryWorkState {
  final int oldPosId;
  final int oldAgencyId;
  final String oldFromDate;
  final VoluntaryWork work;
  const VoluntaryWorkHistoryEditingErrorState(
      {required this.oldAgencyId,
      required this.oldFromDate,
      required this.oldPosId,
      required this.work});
}

class VoluntaryWorkHistoryDeletingErrorState extends VoluntaryWorkState {
  final VoluntaryWork work;
  const VoluntaryWorkHistoryDeletingErrorState({required this.work});
}

class ShowAddFormErrorState extends VoluntaryWorkState{
  
}

class ShowEditFormErrorState extends VoluntaryWorkState{
    final VoluntaryWork work;

  final bool isOverseas;
  const ShowEditFormErrorState({required this.isOverseas, required this.work});
}

class VolunataryWorkHistoryUpdatingErrorState extends VoluntaryWorkState{
       final int oldPosId;
      final int oldAgencyId;
      final String oldFromDate;
      final VoluntaryWork work;

  const VolunataryWorkHistoryUpdatingErrorState({required this.oldPosId, required this.oldAgencyId, required this.oldFromDate, required this.work});
}

