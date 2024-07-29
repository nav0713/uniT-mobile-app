part of 'contact_bloc.dart';

abstract class ContactEvent extends Equatable {
  const ContactEvent();

  @override
  List<Object> get props => [];
}

////get contacts
class GetContacts extends ContactEvent {
  final List<ContactInfo> contactInformations;
  const GetContacts({required this.contactInformations});
  @override
  List<Object> get props => [];
}

//// load contacts
class LoadContacts extends ContactEvent {
  @override
  List<Object> get props => [];
}

//// show add form
class ShowAddForm extends ContactEvent {}

class CallErrorEvent extends ContactEvent {
  final String message;
  const CallErrorEvent({required this.message});
}

//// show edit form
class ShowEditForm extends ContactEvent {
  final ContactInfo contactInfo;
  const ShowEditForm({required this.contactInfo});
  @override
  List<Object> get props => [contactInfo];
}

////add event
class AddContactInformation extends ContactEvent {
  final int profileId;
  final String token;
  final ContactInfo contactInfo;
  const AddContactInformation(
      {required this.contactInfo,
      required this.profileId,
      required this.token});
  @override
  List<Object> get props => [profileId, token, contactInfo];
}

////edit event
class EditContactInformation extends ContactEvent {
  final int profileId;
  final String token;
  final ContactInfo contactInfo;
  const EditContactInformation(
      {required this.contactInfo,
      required this.profileId,
      required this.token});
  @override
  List<Object> get props => [profileId, token, contactInfo];
}

//// delete event

class DeleteContactInformation extends ContactEvent {
  final int profileId;
  final String token;
  final ContactInfo contactInfo;
  const DeleteContactInformation(
      {required this.contactInfo,
      required this.profileId,
      required this.token});
  @override
  List<Object> get props => [profileId, token, contactInfo];
}
