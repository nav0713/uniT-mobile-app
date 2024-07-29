
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unit2/bloc/profile/other_information/hobbies/hoobies_bloc.dart';
import 'package:unit2/model/profile/other_information/skills_and_hobbies.dart';
import 'package:unit2/theme-data.dart/colors.dart';

class AddHobbiesAndSkillsScreen extends StatefulWidget {
final int profileId;
final String token;
  const AddHobbiesAndSkillsScreen({super.key,required this.profileId, required this.token});

  @override
  State<AddHobbiesAndSkillsScreen> createState() =>
      _AddHobbiesAndSkillsScreenState();
}

class _AddHobbiesAndSkillsScreenState extends State<AddHobbiesAndSkillsScreen> {

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<HoobiesBloc, HobbiesState>(
      builder: (context, state) {
        if(state is AddHobbySkillState){
             final List<SkillsHobbies> selectedList= state.mySkillsAndHobbiesString.map((var element){
              return state.allSkillsAndHobbies.firstWhere((var data) => data.name == element );
             }).toList();
          return  FilterListWidget<SkillsHobbies>(
          themeData: FilterListThemeData(context,choiceChipTheme: const ChoiceChipThemeData(selectedBackgroundColor: primary)),
          hideSelectedTextCount: true,
          listData: state.allSkillsAndHobbies,
          selectedListData: selectedList,
          onApplyButtonClick: (list) {
            // Navigator.pop(context, list);
          context.read<HoobiesBloc>().add(AddHobbyAndSkills(profileId: widget.profileId, token: widget.token, skillsHobbies: list!));
          },
          choiceChipLabel: (item) {

            return item!.name;
          },
          // choiceChipBuilder: (context, item, isSelected) {
          //   return Container(
          //     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          //     margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          //     decoration: BoxDecoration(
          //         border: Border.all(
          //       color: isSelected! ? Colors.blue[300]! : Colors.grey[300]!,
          //     )),
          //     child: Text(item.name),
          //   );
          // },
          validateSelectedItem: (list, val) {
            ///  identify if item is selected or not
            return list!.contains(val);
          },
          onItemSearch: (user, query) {
            /// When search query change in search bar then this method will be called
            ///
            /// Check if items contains query
            return user.name!.toLowerCase().contains(query.toLowerCase());
          },
          
        );
        }
        return Container();
      },
    );
  }
}
