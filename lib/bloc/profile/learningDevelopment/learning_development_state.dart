part of 'learning_development_bloc.dart';

abstract class LearningDevelopmentState extends Equatable {
  const LearningDevelopmentState();

  @override
  List<Object> get props => [];
}

class LearningDevelopmentInitial extends LearningDevelopmentState {}

class LearningDevelopmentLoadedState extends LearningDevelopmentState {
  final List<AttachmentCategory> attachmentCategory;
  final List<LearningDevelopement> learningsAndDevelopment;
  const LearningDevelopmentLoadedState(
      {required this.learningsAndDevelopment,
      required this.attachmentCategory});
  @override
  List<Object> get props => [learningsAndDevelopment];
}
class AddAttachmentError extends LearningDevelopmentState{
    final String categoryId;
  final String attachmentModule;
  final List<String> filePaths;
  const AddAttachmentError({required this.attachmentModule, required this.filePaths, required this.categoryId,});
}

class LearningDevelopmentLoadingState extends LearningDevelopmentState {}

////added State
class LearningDevelopmentAddedState extends LearningDevelopmentState {
  final Map<dynamic, dynamic> response;
  const LearningDevelopmentAddedState({required this.response});
  @override
  List<Object> get props => [response];
}

////Updated State
class LearningDevelopmentUpdatedState extends LearningDevelopmentState {
  final Map<dynamic, dynamic> response;
  const LearningDevelopmentUpdatedState({required this.response});
  @override
  List<Object> get props => [response];
}

//// Deleted State
class DeleteLearningDevelopmentState extends LearningDevelopmentState {
  final bool success;
  const DeleteLearningDevelopmentState({required this.success});
  @override
  List<Object> get props => [success];
}

////Update State
class LearningDevelopmentUpdatingState extends LearningDevelopmentState {
  final List<LearningDevelopmentType> types;
  final List<LearningDevelopmentType> topics;
  final LearningDevelopmentType training;
  final LearningDevelopement learningDevelopement;
  final Agency currentConductedBy;
  final Agency? currentSponsor;
  final List<Agency> conductedBy;
  final List<Agency> sponsorAgencies;
  final List<Category> agencyCategory;
  final List<Country> countries;
  final List<Region> regions;
  final List<Province> provinces;
  final List<Barangay> barangay;
  final List<CityMunicipality> cities;
  final Region? currentRegion;
  final Country currentCountry;
  final Province? currentProvince;
  final CityMunicipality? currentCity;
  final Barangay? currentBarangay;
  final bool overseas;

  const LearningDevelopmentUpdatingState(
      {required this.currentBarangay,
      required this.cities,
      required this.barangay,
      required this.provinces,
      required this.types,
      required this.topics,
      required this.training,
      required this.learningDevelopement,
      required this.currentConductedBy,
      required this.currentSponsor,
      required this.conductedBy,
      required this.sponsorAgencies,
      required this.agencyCategory,
      required this.countries,
      required this.regions,
      required this.currentRegion,
      required this.currentCountry,
      required this.currentProvince,
      required this.currentCity,
      required this.overseas});
}

////Adding State
class LearningDevelopmentAddingState extends LearningDevelopmentState {
  final List<LearningDevelopmentType> types;
  final List<LearningDevelopmentType> topics;
  final List<Agency> conductedBy;
  final List<Agency> sponsorAgencies;
  final List<Country> countries;
  final List<Region> regions;
  final List<Category> agencyCategory;

  const LearningDevelopmentAddingState(
      {required this.types,
      required this.topics,
      required this.countries,
      required this.regions,
      required this.conductedBy,
      required this.sponsorAgencies,
      required this.agencyCategory});
}

class LearningDevelopmentErrorState extends LearningDevelopmentState {
  final String message;
  const LearningDevelopmentErrorState({required this.message});
}

////Attachment AddedState
class LearningDevAttachmentAddedState extends LearningDevelopmentState {
  final Map<dynamic, dynamic> response;
  const LearningDevAttachmentAddedState({required this.response});
  @override
  List<Object> get props => [response];
}

////Attachment Deleted State State
class LearningDevAttachmentDeletedState extends LearningDevelopmentState {
  final bool success;
  const LearningDevAttachmentDeletedState({required this.success});
  @override
  List<Object> get props => [success];
}

class LearningDevelopmentAddingErrorState extends LearningDevelopmentState {
  final LearningDevelopement learningDevelopement;
  const LearningDevelopmentAddingErrorState(
      {required this.learningDevelopement});
}

class LearningDevelopmentUpdatingErrorState extends LearningDevelopmentState {
  final LearningDevelopement learningDevelopement;
  const LearningDevelopmentUpdatingErrorState(
      {required this.learningDevelopement});
}

class LearningDevelopmentDeletingErrorState extends LearningDevelopmentState {
  final int? sponsorId;
  final int trainingId;
  final double hours;
  const LearningDevelopmentDeletingErrorState(
      {required this.hours, required this.sponsorId, required this.trainingId});
}

class LearningAndDevelopmentAttachmentViewState
    extends LearningDevelopmentState {
  final String filename;
  final String fileUrl;
  const LearningAndDevelopmentAttachmentViewState(
      {required this.fileUrl, required this.filename});
}

class LearningDevelopmentAttachmentShareState extends LearningDevelopmentState {
  final bool success;
  const LearningDevelopmentAttachmentShareState({
    required this.success,
  });
}

class ShowAddFormErrorState extends LearningDevelopmentState{
  
}

class ShowEditFormErrorState extends LearningDevelopmentState{
    final  LearningDevelopement learningDevelopment; 

  final bool isOverseas;
  const ShowEditFormErrorState({required this.isOverseas, required this.learningDevelopment});
}
class ErrorDeleteLearningDevAttachment extends LearningDevelopmentState{
  final int moduleId;
  final Attachment attachment;
  final String token;
  final int profileId;
  const ErrorDeleteLearningDevAttachment({required this.attachment, required this.moduleId, required this.profileId, required this.token});
}
