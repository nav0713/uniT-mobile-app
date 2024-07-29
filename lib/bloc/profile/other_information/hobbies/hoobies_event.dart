part of 'hoobies_bloc.dart';

abstract class HobbiesEvent extends Equatable {
  const HobbiesEvent();

  @override
  List<Object> get props => [];
}

class GetSkillsHobbies extends HobbiesEvent{
  final int profileId;
  final String token;
  const GetSkillsHobbies({required this.profileId, required this.token});
    @override
  List<Object> get props => [profileId,token];
}
class ShowHobbySkillAddForm extends HobbiesEvent{

  const ShowHobbySkillAddForm();
    
}
class AddHobbyAndSkills extends HobbiesEvent{
  final int profileId;
  final String token;
  final List<SkillsHobbies> skillsHobbies;
  const AddHobbyAndSkills({required this.profileId,required this.token, required this.skillsHobbies});
      @override
  List<Object> get props => [profileId,token];
}

class GetAddedHobbiesSkills extends HobbiesEvent{
       final String addedHobbiesSkills;


 const GetAddedHobbiesSkills({required this.addedHobbiesSkills});
    @override
  List<Object> get props => [addedHobbiesSkills];
}
class ShowAddModal extends HobbiesEvent{

}

class LoadHobbiesSkills extends HobbiesEvent{
  final List<SkillsHobbies> skillsHobbies;
  const LoadHobbiesSkills({required this.skillsHobbies});
}
class DeleteSkillHobbies extends HobbiesEvent{
    final int profileId;
  final String token;
  final List<SkillsHobbies> skillsHobbies;
  const DeleteSkillHobbies({required this.profileId, required this.skillsHobbies, required this.token});
}