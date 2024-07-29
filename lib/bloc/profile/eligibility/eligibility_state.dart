part of 'eligibility_bloc.dart';

abstract class EligibilityState extends Equatable {
  const EligibilityState();

  @override
  List<Object> get props => [];
}

class EligibilityInitial extends EligibilityState {}

class EditEligibilityState extends EligibilityState {
  final EligibityCert eligibityCert;
  final List<Eligibility> eligibilities;
  final List<Country> countries;
  final List<Region> regions;
  final List<Province>? provinces;
  final List<CityMunicipality>? cities;
  final bool isOverseas;
  final Eligibility currentEligibility;
  final Region? currentRegion;
  final Province? currentProvince;
  final CityMunicipality? currentCity;
  final Country selectedCountry;

  const EditEligibilityState({
    required this.provinces,
    required this.cities,
    required this.currentProvince,
    required this.currentCity,
    required this.currentRegion,
    required this.currentEligibility,
    required this.isOverseas,
    required this.eligibityCert,
    required this.eligibilities,
    required this.countries,
    required this.regions,
    required this.selectedCountry,
  });
  @override
  List<Object> get props =>
      [isOverseas, eligibityCert, eligibilities, regions, countries];
}

class EligibilityDeletedState extends EligibilityState {
  final bool success;
  const EligibilityDeletedState({required this.success});
  @override
  List<Object> get props => [success];
}

class AddEligibilityState extends EligibilityState {
  final List<Eligibility> eligibilities;
  final List<Country> countries;
  final List<Region> regions;
  const AddEligibilityState({
    required this.eligibilities,
    required this.countries,
    required this.regions,
  });
  @override
  List<Object> get props => [eligibilities, countries, regions];
}

class EligibilityEditedState extends EligibilityState {
  final Map<dynamic, dynamic> response;
  const EligibilityEditedState({required this.response});
  @override
  List<Object> get props => [response];
}

class EligibilityAddedState extends EligibilityState {
  final Map<dynamic, dynamic> response;

  const EligibilityAddedState({required this.response});
  @override
  List<Object> get props => [response];
}

class EligibilityLoadingState extends EligibilityState {}

class EligibilityErrorState extends EligibilityState {
  final String message;
  const EligibilityErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class EligibilityLoaded extends EligibilityState {
    final List< AttachmentCategory> attachmentCategory;
  final List<EligibityCert> eligibilities;
  const EligibilityLoaded({required this.eligibilities, required this.attachmentCategory});
  @override
  List<Object> get props => [eligibilities];
}

////Attachment AddedState
class EligibilityAttachmentAddedState extends EligibilityState {
  final Map<dynamic, dynamic> response;
  const EligibilityAttachmentAddedState({required this.response});
}

////Attachment Deleted State State
class EligibilitytAttachmentDeletedState extends EligibilityState {
  final bool success;
  const EligibilitytAttachmentDeletedState({required this.success});
  @override
  List<Object> get props => [success];
}

class EligibilityAttachmentViewState extends EligibilityState {
  final String fileName;
  final String fileUrl;
  const EligibilityAttachmentViewState({required this.fileUrl, required this.fileName});
}
class EligibilityAttachmentShareState extends EligibilityState{
  final bool success;
  const EligibilityAttachmentShareState({required this.success,});
}
class EligibilityAttachmentViewFromDir extends EligibilityState{
    final String fileName;
  final String fileUrl;
  const EligibilityAttachmentViewFromDir({required this.fileUrl, required this.fileName});
}

class EligibilityAddingErrorState extends EligibilityState{
    final EligibityCert eligibityCert;
    const EligibilityAddingErrorState({required this.eligibityCert});
}
class EligibilityUpdatingErrorState extends EligibilityState{
    final EligibityCert eligibityCert;
    final int intOldEligibilityId;
    const EligibilityUpdatingErrorState({required this.eligibityCert,required this.intOldEligibilityId});
}
class EligibilityDeletingErrorState extends EligibilityState{
  final int eligibilityId;
    const EligibilityDeletingErrorState({required this.eligibilityId});
}

class ShowAddFormErrorState extends EligibilityState{
  
}

class AddAttachmentError extends EligibilityState{
    final String categoryId;
  final String attachmentModule;
  final List<String> filePaths;
  const AddAttachmentError({required this.attachmentModule, required this.filePaths, required this.categoryId,});
}

class ShowEditFormErrorState extends EligibilityState{
    final EligibityCert eligibityCert;
    const ShowEditFormErrorState({required this.eligibityCert});
      @override
  List<Object> get props => [eligibityCert];
}

class ErrorDeleteEligibyAttachmentState extends EligibilityState {
  final String profileId;
  final String token;
  final Attachment attachment;
  final String moduleId;
  const ErrorDeleteEligibyAttachmentState(
      {required this.attachment,
      required this.moduleId,
      required this.profileId,
      required this.token});
}

