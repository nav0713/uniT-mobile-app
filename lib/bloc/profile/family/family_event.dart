part of 'family_bloc.dart';

abstract class FamilyEvent extends Equatable {
  const FamilyEvent();

  @override
  List<Object> get props => [];
}

class GetFamilies extends FamilyEvent{
  final int profileId;
  final String token;
  const GetFamilies({required this.profileId, required this.token});

  @override
  List<Object> get props => [profileId,token];
}

class LoadFamily extends FamilyEvent{

}

class ShowEditFamilyForm extends FamilyEvent{
  final FamilyBackground familyBackground;
  const ShowEditFamilyForm({required this.familyBackground});
   @override
  List<Object> get props => [familyBackground];

}
class AddFamily extends FamilyEvent{
  final int profileId;
  final String token;
  final int relationshipId;
  final FamilyBackground familyBackground;
  const AddFamily({required this.familyBackground, required this.profileId, required this.token, required this.relationshipId});
   @override
  List<Object> get props => [profileId,token,familyBackground];
}
class Updatefamily extends FamilyEvent{
  final int profileId;
  final String token;
  final int relationshipId;

  final FamilyBackground familyBackground;
  const Updatefamily({required this.familyBackground, required this.profileId, required this.token, required this.relationshipId,});
   @override
  List<Object> get props => [profileId,token,familyBackground];
}

class DeleteFamily extends FamilyEvent{
  final int id;
  final int profileId;
  final String token;
  const DeleteFamily({required this.id, required this.profileId, required this.token});
}
class AddEmergencyEvent extends FamilyEvent{
  final int profileId;
  final int relatedPersonId;
  final int? contactInfoId;
  final String token;
  final String? numberMail;
    final String requestType;
  const AddEmergencyEvent({required this.contactInfoId, required this.numberMail, required this.profileId, required this.relatedPersonId, required this.token, required this.requestType});
     @override
  List<Object> get props => [profileId,token,relatedPersonId];
}

class CallErrorState extends FamilyEvent{
  final String message;
  const CallErrorState({required this.message});
}
