import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unit2/model/profile/profileInfomation.dart';
import 'package:unit2/sevices/profile/profile_other_info.dart';
import 'package:unit2/sevices/profile/profile_service.dart';

import '../../model/profile/basic_information/primary-information.dart';
import '../../screens/profile/components/basic_information/profile_other_info.dart';
import '../../utils/global.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
      ProfileInformation? globalProfileInformation;
  ProfileBloc() : super(ProfileInitial()) {
    Profile? currentProfileInformation;
    List<ProfileOtherInfo> religions = [];
    List<ProfileOtherInfo> ethnicities = [];
    List<ProfileOtherInfo> indigencies = [];
    List<ProfileOtherInfo> disabilities = [];
    List<ProfileOtherInfo> genders = [];
    List<String> bloodType = ["A+", "B+", "A-", "B-", "AB+", "AB-", "O+", "O-"];
    List<String> nameExtensions = [
      "NONE",
      "N/A",
      "SR.",
      "JR.",
      "I",
      "II",
      "III",
      "IV",
      "V",
      "VI",
      "VII",
      "VIII",
      "IX",
      "X"
    ];
    List<String> sexes = ["MALE", "FEMALE"];
    List<String> civilStatus = [
      "NONE",
      "SINGLE",
      "MARRIED",
      "SEPARATED",
      "WIDOWED"
    ];



    
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        if (globalProfileInformation == null) {
          ProfileInformation? profileInformation = await ProfileService.instance
              .getProfile(event.token, event.userID);
          globalProfileInformation = profileInformation;
        }else if(globalProfileInformation!=null &&  globalProfileInformation!.profileId != event.userID){
                 ProfileInformation? profileInformation = await ProfileService.instance
              .getProfile(event.token, event.userID);
          globalProfileInformation = profileInformation;
        }
        emit(ProfileLoaded(profileInformation: globalProfileInformation!));
      } catch (e) {
        emit(ProfileErrorState(mesage: e.toString()));
      }
    });
    on<GetPrimaryBasicInfo>((event, emit) {
      if (globalCurrentProfile != null) {
        emit(BasicInformationProfileLoaded(
            primaryBasicInformation: globalCurrentProfile!));
      } else {
        currentProfileInformation = event.primaryBasicInformation;
        globalCurrentProfile = currentProfileInformation;
        emit(BasicInformationProfileLoaded(
            primaryBasicInformation: currentProfileInformation!));
      }
    });
    on<LoadBasicPrimaryInfo>((event, emit) {
      emit(BasicInformationProfileLoaded(
          primaryBasicInformation: globalCurrentProfile!));
    });
    on<ShowPrimaryInfoEditForm>((event, emit) async {
      try {
        emit(BasicPrimaryInformationLoadingState());
        if (religions.isEmpty) {
          religions = await ProfileOtherInfoServices.instace
              .getReligions(token: event.token);
          religions.insert(
              0, ProfileOtherInfo(id: null, name: "NONE", description: null));
        }
        if (genders.isEmpty) {
          genders = await ProfileOtherInfoServices.instace
              .getGenders(token: event.token);

          genders.insert(
              0, ProfileOtherInfo(id: null, name: "NONE", description: null));
        }
        if (ethnicities.isEmpty) {
          ethnicities = await ProfileOtherInfoServices.instace
              .getEthnicity(token: event.token);

          ethnicities.insert(
              0, ProfileOtherInfo(id: null, name: "NONE", description: null));
        }
        if (disabilities.isEmpty) {
          disabilities = await ProfileOtherInfoServices.instace
              .getDisability(token: event.token);
          disabilities.insert(
              0, ProfileOtherInfo(id: null, name: "NONE", description: null));
        }
        if (indigencies.isEmpty) {
          indigencies = await ProfileOtherInfoServices.instace
              .getIndigency(token: event.token);
          indigencies.insert(
              0, ProfileOtherInfo(id: null, name: "NONE", description: null));
        }
        emit(BasicInformationEditingState(
            primaryInformation: globalCurrentProfile!,
            extensions: nameExtensions,
            sexes: sexes,
            bloodTypes: bloodType,
            genders: genders,
            civilStatus: civilStatus,
            disability: disabilities,
            ethnicity: ethnicities,
            indigenous: indigencies,
            religion: religions));
      } catch (e) {
        emit(ShowEditBasicInfoErrorState());
      }
    });
    on<EditBasicProfileInformation>((event, emit) async {
      try {
              emit(BasicPrimaryInformationLoadingState());
        Map<dynamic, dynamic> status = await ProfileService.instance
            .updateBasicProfileInfo(
                token: event.token,
                profileId: event.profileId,
                profileInfo: event.profileInformation,
                genderId: event.genderId,
                indigencyId: event.indigencyId,
                disabilityId: event.disabilityId,
                ethnicityId: event.ethnicityId,
                reqligionId: event.religionId);
        if (status['success']) {
          Profile profile = Profile.fromJson(status['data']);
    
          globalCurrentProfile = profile;
  
  
          emit(BasicProfileInfoEditedState(response: status));
        }
        emit(BasicProfileInfoEditedState(response: status));
      } catch (e) {
        emit(BasicInformationUpdatingErrorState(disabilityId: event.disabilityId, ethnicityId: event.ethnicityId, genderId: event.genderId, indigencyId: event.indigencyId, profileId: event.profileId,profileInformation: event.profileInformation,religionId: event.profileId,token: event.token));
      }
    });
  }
}
