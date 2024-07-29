part of 'hoobies_bloc.dart';

abstract class HobbiesState extends Equatable {
  const HobbiesState();
  
  @override
  List<Object> get props => [];
}

class HoobiesInitial extends HobbiesState {}

class HobbiesLoadedState extends HobbiesState{
  final List<SkillsHobbies> skillsAndHobbies;
  const HobbiesLoadedState({required this.skillsAndHobbies});
    @override
  List<Object> get props => [skillsAndHobbies];
}
class HobbiesErrorState extends HobbiesState{
  final String message;
  const HobbiesErrorState({required this.message});
    
  @override
  List<Object> get props => [message];

}
class AddHobbySkillState extends HobbiesState{
      final List<String> mySkillsAndHobbiesString;
    final List<SkillsHobbies> allSkillsAndHobbies;
    final List<SkillsHobbies> mySkillsAndHobbiesObject;

  const AddHobbySkillState({required this.mySkillsAndHobbiesString,required this.allSkillsAndHobbies,required this.mySkillsAndHobbiesObject});
  @override
  List<Object> get props => [mySkillsAndHobbiesString,allSkillsAndHobbies,mySkillsAndHobbiesObject];
}

class HobbiesLoadingState extends HobbiesState{
  
}

//// show add modal for adding new skills and hobbies
class ShowAddModalState extends HobbiesState{

}
//// hobbies and skills already added
class HobbiesAndSkillsAddedState extends HobbiesState{
  final List<SkillsHobbies> mySkillsAndHobbies;
  final Map<dynamic,dynamic> status;
  const HobbiesAndSkillsAddedState({required this.mySkillsAndHobbies, required this.status});
    @override
  List<Object> get props => [mySkillsAndHobbies,status];
}
class HobbiesAndSkillsDeletedState extends HobbiesState{
  final bool success;
  final List<SkillsHobbies> skillsHobbies;
  const HobbiesAndSkillsDeletedState({required this.skillsHobbies,required this.success});
}
class AddHobbiesErrorState extends HobbiesState{
    final List<SkillsHobbies> skillsHobbies;

  const AddHobbiesErrorState({required this.skillsHobbies});

}

class DeleteHobbiesErrorState extends HobbiesState{
    final List<SkillsHobbies> skillsHobbies;

  const DeleteHobbiesErrorState({required this.skillsHobbies});
}


