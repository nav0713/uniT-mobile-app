part of 'learning_development_bloc.dart';

abstract class LearningDevelopmentEvent extends Equatable {
  const LearningDevelopmentEvent();

  @override
  List<Object> get props => [];
}

class GetLearningDevelopments extends LearningDevelopmentEvent {
  final int profileId;
  final String token;
  const GetLearningDevelopments({required this.profileId, required this.token});

  @override
  List<Object> get props => [profileId, token];
}

class ShowAddLearningDevelopmentForm extends LearningDevelopmentEvent{

}
class ShowEditLearningDevelopmentForm extends LearningDevelopmentEvent{
  final  LearningDevelopement learningDevelopment; 
   final int profileId;
  final String token;
  final bool isOverseas;
  const ShowEditLearningDevelopmentForm({required this.isOverseas, required this.learningDevelopment, required this.profileId, required this.token});
}
class LoadLearniningDevelopment extends LearningDevelopmentEvent{

}
////delete
class DeleteLearningDevelopment extends LearningDevelopmentEvent {
  final String token;
  final int profileId;
 final int? sponsorId;
 final int trainingId;
 final double hours;
  const DeleteLearningDevelopment(
      {required this.profileId, required this.token, required this.hours,required this.sponsorId, required this.trainingId});
  @override
  List<Object> get props => [profileId, token, hours,trainingId];
}

////add
class AddLearningAndDevelopment extends LearningDevelopmentEvent{
  final LearningDevelopement learningDevelopement;
  final int profileId;
  final String token;
  const AddLearningAndDevelopment({required this.learningDevelopement, required this.profileId, required this.token});
    @override
  List<Object> get props => [profileId, token,learningDevelopement];
}

////update
class UpdateLearningDevelopment extends LearningDevelopmentEvent{
  final LearningDevelopement learningDevelopement;
  final int profileId;
  final String token;
  const UpdateLearningDevelopment({required this.learningDevelopement, required this.profileId, required this.token});
    @override
  List<Object> get props => [profileId, token,learningDevelopement];
}

class CallErrorState extends LearningDevelopmentEvent{
  final String message;
  const CallErrorState({required this.message});
}

////Add Attachment
class AddALearningDevttachment extends LearningDevelopmentEvent{
  final String categoryId;
  final String attachmentModule;
  final List<String> filePaths;
  final String token;
  final String profileId;
  const AddALearningDevttachment({required this.attachmentModule, required this.filePaths, required this.categoryId, required this.profileId, required this.token});
  @override
  List<Object> get props => [categoryId,attachmentModule,filePaths, token,profileId];
}

//// Delete Attachment
class DeleteLearningDevAttachment extends LearningDevelopmentEvent{
  final int moduleId;
  final Attachment attachment;
  final String token;
  final int profileId;
  const DeleteLearningDevAttachment({required this.attachment, required this.moduleId, required this.profileId, required this.token});
}

class LearningDevelopmentViewAttachmentEvent extends LearningDevelopmentEvent{
  final String filename;
  final String source;
  const LearningDevelopmentViewAttachmentEvent({required this.source, required this.filename});
}

class ShareAttachment extends LearningDevelopmentEvent{
  final String fileName;
  final String source;
  const ShareAttachment({required this.fileName, required this.source});
}


