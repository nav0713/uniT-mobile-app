part of 'education_bloc.dart';

abstract class EducationState extends Equatable {
  const EducationState();

  @override
  List<Object> get props => [];
}

class EducationInitial extends EducationState {}

class EducationalBackgroundLoadedState extends EducationState {
  final List<AttachmentCategory> attachmentCategory;
  final List<EducationalBackground> educationalBackground;
  const EducationalBackgroundLoadedState(
      {required this.educationalBackground, required this.attachmentCategory});
  @override
  List<Object> get props => [educationalBackground];
}

class EducationalBackgroundErrorState extends EducationState {
  final String message;
  const EducationalBackgroundErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class EducationalBackgroundLoadingState extends EducationState {}

////Add
class AddEducationState extends EducationState {
  final List<School> schools;
  final List<Course> programs;
  final List<Honor> honors;
  const AddEducationState(
      {required this.honors, required this.programs, required this.schools});
  @override
  List<Object> get props => [schools, programs, honors];
}

////Edit
class EditEducationState extends EducationState {
  final EducationalBackground educationalBackground;
  final List<School> schools;
  final List<Course> programs;
  final List<Honor> honors;
  const EditEducationState({
    required this.educationalBackground,
    required this.honors,
    required this.programs,
    required this.schools,
  });
}

//// Added State
class EducationAddedState extends EducationState {
  final Map<dynamic, dynamic> response;
  const EducationAddedState({required this.response});
  @override
  List<Object> get props => [response];
}

//// Edited State
class EditedEducationState extends EducationState {
  final Map<dynamic, dynamic> response;
  const EditedEducationState({required this.response});
  @override
  List<Object> get props => [response];
}

////deleted State
class EducationDeletedState extends EducationState {
  final bool success;
  const EducationDeletedState({required this.success});
  @override
  List<Object> get props => [success];
}

////Attachment AddedState
class EducationAttachmentAddedState extends EducationState {
  final Map<dynamic, dynamic> response;
  const EducationAttachmentAddedState({required this.response});
}

////Attachment Deleted State State
class EducationAttachmentDeletedState extends EducationState {
  final bool success;
  const EducationAttachmentDeletedState({required this.success});
  @override
  List<Object> get props => [success];
}

class EducationAttachmentViewState extends EducationState {
  final String fileUrl;
  final String fileName;
  const EducationAttachmentViewState(
      {required this.fileUrl, required this.fileName});
}

class EducationAttachmentShareState extends EducationState {
  final bool success;
  const EducationAttachmentShareState({
    required this.success,
  });
}
//// Error states
////adding error state
class EducationAddingErrorState extends EducationState {
  final EducationalBackground educationalBackground;
  final List<Honor> honors;
  const EducationAddingErrorState({required this.educationalBackground , required this.honors});
}
//// updating error state
class EducationUpdatingErrorState extends EducationState {
  final EducationalBackground educationalBackground;
  final List<Honor> honors;
  const EducationUpdatingErrorState({required this.educationalBackground, required this.honors});
}
//// deleting error state
class EducationDeletingErrorState extends EducationState {
  final EducationalBackground educationalBackground;
  const EducationDeletingErrorState({required this.educationalBackground});
}
////show add form error state
class ShowAddFormErrorState extends EducationState{
  
}
class ShowEditFormErrorState extends EducationState{
    final EducationalBackground educationalBackground;
    const ShowEditFormErrorState({required this.educationalBackground});
      @override
  List<Object> get props => [educationalBackground];
}

class AddAttachmentError extends EducationState{
    final String categoryId;
  final String attachmentModule;
  final List<String> filePaths;
  const AddAttachmentError({required this.attachmentModule, required this.filePaths, required this.categoryId,});
}
class ErrorDeleteEducationAttachmentState extends EducationState {
  final String profileId;
  final String token;
  final Attachment attachment;
  final String moduleId;
  const ErrorDeleteEducationAttachmentState(
      {required this.attachment,
      required this.moduleId,
      required this.profileId,
      required this.token});
}

