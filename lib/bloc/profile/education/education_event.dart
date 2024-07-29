part of 'education_bloc.dart';

abstract class EducationEvent extends Equatable {
  const EducationEvent();

  @override
  List<Object> get props => [];
}

class GetEducationalBackground extends EducationEvent {
  final int profileId;
  final String token;
  const GetEducationalBackground(
      {required this.profileId, required this.token});
  @override
  List<Object> get props => [profileId, token];
}
////show add form
class ShowAddEducationForm extends EducationEvent {}
////show edit form
class ShowEditEducationForm extends EducationEvent {
  final EducationalBackground educationalBackground;
    final int profileId;
  final String token;
  const ShowEditEducationForm({required this.educationalBackground,required this.profileId, required this.token});
  @override
  List<Object> get props => [educationalBackground];
}
////load
class LoadEducations extends EducationEvent {}
////add
class AddEducation extends EducationEvent {
  final List<Honor> honors;
  final EducationalBackground educationalBackground;
  final int profileId;
  final String token;
  const AddEducation(
      {required this.educationalBackground,
      required this.profileId,
      required this.token, required this.honors});
  @override
  List<Object> get props => [educationalBackground, profileId, token];
}
////update education
class UpdateEducation extends EducationEvent{
     final List<Honor> honors;
  final EducationalBackground educationalBackground;
  final int profileId;
  final String token;
   const UpdateEducation(
      {required this.educationalBackground,
      required this.profileId,
      required this.token,required this.honors});
  @override
  List<Object> get props => [educationalBackground, profileId, token];
}
////delete
class DeleteEducation extends EducationEvent{
  final int profileId;
  final String token;
  final EducationalBackground educationalBackground;
  const DeleteEducation({required this.educationalBackground, required this.profileId, required this.token});
    @override
  List<Object> get props => [educationalBackground, profileId, token];
}
////Add attachment
class AddEducationAttachment extends EducationEvent{
  final String categoryId;
  final String attachmentModule;
  final List<String> filePaths;
  final String token;
  final String profileId;
  const AddEducationAttachment({required this.attachmentModule, required this.filePaths, required this.categoryId, required this.profileId, required this.token});
  @override
  List<Object> get props => [categoryId,attachmentModule,filePaths, token,profileId];
}

////Delete Attachment
class DeleteEducationAttachment extends EducationEvent{
  final int moduleId;
  final Attachment attachment;
  final String token;
  final int profileId;
  const DeleteEducationAttachment({required this.attachment, required this.moduleId, required this.profileId, required this.token});
}

class EducationViewAttachment extends EducationEvent{
  final String fileName;
  final String source;
  const EducationViewAttachment({required this.source,required this.fileName});
}

class ShareAttachment extends EducationEvent{
  final String fileName;
  final String source;
  const ShareAttachment({required this.fileName, required this.source});
}
