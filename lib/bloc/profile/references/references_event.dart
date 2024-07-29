part of 'references_bloc.dart';

abstract class ReferencesEvent extends Equatable {
  const ReferencesEvent();

  @override
  List<Object> get props => [];
}

class GetReferences extends ReferencesEvent {
  final int profileId;
  final String token;
  const GetReferences({required this.profileId, required this.token});
  @override
  List<Object> get props => [profileId, token];
}

class ShowAddReferenceForm extends ReferencesEvent {}

class ShowEditReferenceForm extends ReferencesEvent {
  final PersonalReference personalReference;
  const ShowEditReferenceForm({required this.personalReference});
  @override
  List<Object> get props => [personalReference];
}

class CallErrorState extends ReferencesEvent {}

class AddReference extends ReferencesEvent {
  final PersonalReference reference;
  final String token;
  final int profileId;
  const AddReference(
      {required this.profileId, required this.reference, required this.token});
  @override
  List<Object> get props => [profileId, token, reference];
}

class EditReference extends ReferencesEvent {
  final PersonalReference reference;
  final String token;
  final int profileId;
  const EditReference(
      {required this.profileId, required this.reference, required this.token});
  @override
  List<Object> get props => [profileId, token, reference];
}

class DeleteReference extends ReferencesEvent {
  final List<PersonalReference> references;
  final int profileId;
  final String token;
  final int refId;
  const DeleteReference(
      {required this.profileId,
      required this.refId,
      required this.references,
      required this.token});
  @override
  List<Object> get props => [profileId, token, refId, references];
}

class LoadReferences extends ReferencesEvent {
  @override
  List<Object> get props => [];
}
