import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unit2/sevices/skillshobbies_services.dart';

import '../../../../model/profile/other_information/skills_and_hobbies.dart';

part 'hoobies_event.dart';
part 'hoobies_state.dart';

class HoobiesBloc extends Bloc<HobbiesEvent, HobbiesState> {
  HoobiesBloc() : super(HoobiesInitial()) {
    List<SkillsHobbies> skillsAndHobbies = [];
    List<SkillsHobbies> allSkillsAndHobbies = [];
    List<String> mySkillsAndHobbies = [];
    on<GetSkillsHobbies>((event, emit) async {
      emit(HobbiesLoadingState());
      try {
        if (skillsAndHobbies.isEmpty) {
          List<SkillsHobbies> hobbies = await SkillsHobbiesServices.instance
              .getSkillsHobbies(event.profileId, event.token);
          skillsAndHobbies = hobbies;
        }
        emit(HobbiesLoadedState(skillsAndHobbies: skillsAndHobbies));
      } catch (e) {
        emit(HobbiesErrorState(message: e.toString()));
      }
    });
    on<LoadHobbiesSkills>((event, emit) {
      skillsAndHobbies = event.skillsHobbies;
      emit(HobbiesLoadedState(skillsAndHobbies: skillsAndHobbies));
    });
    ////SHOW ADD FORM
    on<ShowHobbySkillAddForm>((event, emit) async {
      emit(HobbiesLoadingState());
      try {
        ////get all skills and hobbies
        if (allSkillsAndHobbies.isEmpty) {
          allSkillsAndHobbies =
              await SkillsHobbiesServices.instance.getAllSkillsHobbies();
        }
        for (var element in skillsAndHobbies) {
          mySkillsAndHobbies.add(element.name!);
        }
        allSkillsAndHobbies.sort((a, b) => a.name!.compareTo(b.name!));
        emit(AddHobbySkillState(
            mySkillsAndHobbiesString: mySkillsAndHobbies,
            allSkillsAndHobbies: allSkillsAndHobbies,
            mySkillsAndHobbiesObject: skillsAndHobbies));
      } catch (e) {
        emit(HobbiesErrorState(message: e.toString()));
      }
    });
    ////GET ADDED SKILLS HOBBIES
    on<GetAddedHobbiesSkills>((event, emit) {
      emit(HobbiesLoadingState());
      List<String> added = event.addedHobbiesSkills.split(",");

      for (var element in added) {
        if (element.isNotEmpty) {
          SkillsHobbies newSkillsHobbies =
              SkillsHobbies(id: null, name: element.toUpperCase());
          skillsAndHobbies.add(newSkillsHobbies);
          allSkillsAndHobbies.add(newSkillsHobbies);
        }
      }
      for (var element in skillsAndHobbies) {
        mySkillsAndHobbies.add(element.name!);
      }
      allSkillsAndHobbies.sort((a, b) => a.name!.compareTo(b.name!));
      emit(AddHobbySkillState(
          mySkillsAndHobbiesString: mySkillsAndHobbies,
          allSkillsAndHobbies: allSkillsAndHobbies,
          mySkillsAndHobbiesObject: skillsAndHobbies));
    });
    ////SHOW ADD MODAL
    on<ShowAddModal>((event, emit) {
      emit(ShowAddModalState());
    });

    //// ADD
    on<AddHobbyAndSkills>((event, emit) async {
      emit(HobbiesLoadingState());
      try {
        Map<dynamic, dynamic> response = await SkillsHobbiesServices.instance
            .add(
                skillsHobbies: event.skillsHobbies,
                profileId: event.profileId,
                token: event.token);
        List<SkillsHobbies> newSkillsHobbies = [];
        if (response['success']) {
          if (response['data']['skill_hobby'] != null) {
            for (var element in response['data']['skill_hobby']) {
              newSkillsHobbies.add(SkillsHobbies.fromJson(element));
            }
          }
          skillsAndHobbies = newSkillsHobbies;
          emit(HobbiesAndSkillsAddedState(
              mySkillsAndHobbies: skillsAndHobbies, status: response));
        } else {
          emit(HobbiesAndSkillsAddedState(
              mySkillsAndHobbies: skillsAndHobbies, status: response));
        }
      } catch (e) {
        print("print this");
        emit(AddHobbiesErrorState(skillsHobbies: event.skillsHobbies));
      }
    });
    ////DELETE
    on<DeleteSkillHobbies>((event, emit) async {
      emit(HobbiesLoadingState());
      try {
        bool success = await SkillsHobbiesServices.instance.delete(
            profileId: event.profileId,
            token: event.token,
            skillsHobbies: event.skillsHobbies);
        if (success) {
          skillsAndHobbies.removeWhere(
              (element) => element.id == event.skillsHobbies[0].id);
          emit(HobbiesAndSkillsDeletedState(
              skillsHobbies: skillsAndHobbies, success: success));
        } else {
          emit(HobbiesAndSkillsDeletedState(
              skillsHobbies: skillsAndHobbies, success: success));
        }
      } catch (e) {
        emit(DeleteHobbiesErrorState(skillsHobbies: event.skillsHobbies));
      }
    });
  }
}
