part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileInformation profileInformation;
  const ProfileLoaded({required this.profileInformation});
  @override
  List<Object> get props => [profileInformation];
}

class ProfileErrorState extends ProfileState {
  final String mesage;
  const ProfileErrorState({required this.mesage});
  @override
  List<Object> get props => [mesage];
}
class BasicInformationEditingState extends ProfileState{
  final Profile primaryInformation;
  final List<ProfileOtherInfo> religion;
final List<ProfileOtherInfo> ethnicity;
final List<ProfileOtherInfo> disability;
final List<ProfileOtherInfo> indigenous;
final List<ProfileOtherInfo> genders;
final List<String>sexes;
final List<String> bloodTypes;
final List<String> civilStatus;
final List<String> extensions;
const BasicInformationEditingState( {required this.genders, required this.extensions, required this.primaryInformation, required this.sexes, required this.bloodTypes, required this.civilStatus, required this.disability,required this.ethnicity,required this.indigenous,required this.religion});
}
////Edited State
class BasicProfileInfoEditedState extends ProfileState{
    final Map<dynamic,dynamic> response;
    const BasicProfileInfoEditedState({required this.response});
            @override
  List<Object> get props => [response];
}

class BasicInformationProfileLoaded extends ProfileState{
  final Profile primaryBasicInformation;
  const BasicInformationProfileLoaded({required this.primaryBasicInformation});

}
class BasicPrimaryInformationLoadingState extends ProfileState{

}
class BasicPrimaryInformationErrorState extends ProfileState{
  final String message;
  const BasicPrimaryInformationErrorState({required this.message});
}

class BasicInformationUpdatingErrorState extends ProfileState{
final Profile profileInformation;
final int profileId;
final String token;
final int? genderId;
final int? indigencyId;
final int? disabilityId;
final int? religionId;
final int? ethnicityId;
const BasicInformationUpdatingErrorState({required this.disabilityId,required this.ethnicityId, required this.genderId, required this.indigencyId, required this.profileId,required this.profileInformation,required this.religionId,required this.token});
}
class ShowEditBasicInfoErrorState extends ProfileState{
  
}
class ProfileLoading extends ProfileState {}



