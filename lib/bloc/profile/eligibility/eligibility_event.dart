part of 'eligibility_bloc.dart';

abstract class EligibilityEvent extends Equatable {
  const EligibilityEvent();

  @override
  List<Object> get props => [];
}

class ShowAddEligibilityForm extends EligibilityEvent {}

class GetEligibilities extends EligibilityEvent {
  final int profileId;
  final String token;
  const GetEligibilities({required this.profileId, required this.token});
  @override
  List<Object> get props => [profileId, token];
}

class AddEligibility extends EligibilityEvent {
  final EligibityCert eligibityCert;
  final String profileId;
  final String token;
  const AddEligibility(
      {required this.eligibityCert,
      required this.profileId,
      required this.token});
  @override
  List<Object> get props => [eligibityCert, profileId, token];
}

class UpdateEligibility extends EligibilityEvent {
  final EligibityCert eligibityCert;
  final String profileId;
  final String token;
  final int oldEligibility;
  const UpdateEligibility(
      {required this.eligibityCert,
      required this.oldEligibility,
      required this.profileId,
      required this.token});

  @override
  List<Object> get props => [eligibityCert, profileId, token, oldEligibility];
}

class LoadEligibility extends EligibilityEvent {
  const LoadEligibility();
  @override
  List<Object> get props => [];
}

class ShowEditEligibilityForm extends EligibilityEvent {
  final EligibityCert eligibityCert;
  const ShowEditEligibilityForm({required this.eligibityCert});
  @override
  List<Object> get props => [];
}

class DeleteEligibility extends EligibilityEvent {
  final String profileId;
  final int eligibilityId;
  final String token;

  const DeleteEligibility(
      {required this.eligibilityId,
      required this.profileId,
      required this.token});
  @override
  List<Object> get props => [profileId, eligibilityId, token];
}

class CallErrorState extends EligibilityEvent {}

////Add Attachment
class AddEligibiltyAttachment extends EligibilityEvent {
  final String categoryId;
  final String attachmentModule;
  final List<String> filePaths;
  final String token;
  final String profileId;
  const AddEligibiltyAttachment(
      {required this.attachmentModule,
      required this.filePaths,
      required this.categoryId,
      required this.profileId,
      required this.token});
  @override
  List<Object> get props =>
      [categoryId, attachmentModule, filePaths, token, profileId];
}

////Delete Attachment
class DeleteEligibyAttachment extends EligibilityEvent {
  final String profileId;
  final String token;
  final Attachment attachment;
  final String moduleId;
  const DeleteEligibyAttachment(
      {required this.attachment,
      required this.moduleId,
      required this.profileId,
      required this.token});
}


class EligibiltyViewAttachmentEvent extends EligibilityEvent{
  final String source;
  final String filename;
  const EligibiltyViewAttachmentEvent({required this.source, required this.filename});
}
class ShareAttachment extends EligibilityEvent{
  final String fileName;
  final String source;
  const ShareAttachment({required this.fileName, required this.source});
}

