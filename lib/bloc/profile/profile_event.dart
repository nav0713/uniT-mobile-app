part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfile extends ProfileEvent {
  final String token;
  final int userID;
  const LoadProfile({required this.token, required this.userID});
  @override
  List<Object> get props => [token, userID];
}

class LoadProfileInformation extends ProfileEvent {
  @override
  List<Object> get props => [];
}
class GetPrimaryBasicInfo extends ProfileEvent{
  final Profile primaryBasicInformation;
  const GetPrimaryBasicInfo({required this.primaryBasicInformation});
}
class LoadBasicPrimaryInfo extends ProfileEvent{
  
}

class ShowPrimaryInfoEditForm extends ProfileEvent{
  final String token;
  const ShowPrimaryInfoEditForm({required this.token});
}
class EditBasicProfileInformation extends ProfileEvent{
final Profile profileInformation;
final int profileId;
final String token;
final int? genderId;
final int? indigencyId;
final int? disabilityId;
final int? religionId;
final int? ethnicityId;
const EditBasicProfileInformation({required this.disabilityId,required this.ethnicityId, required this.genderId, required this.indigencyId, required this.profileId,required this.profileInformation,required this.religionId,required this.token});
}



