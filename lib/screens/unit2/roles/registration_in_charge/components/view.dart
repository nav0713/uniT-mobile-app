import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:unit2/utils/global.dart';

import '../../../../../test_data.dart';
import '../../../../../theme-data.dart/text-styles.dart';

class _AZItem extends ISuspensionBean {
  final String title;
  final String tag;

  _AZItem({required this.title, required this.tag});

  @override
  String getSuspensionTag() {
    return tag;
  }
}

class ViewList extends StatefulWidget {
  const ViewList({super.key});

  @override
  State<ViewList> createState() => _ViewListState();
}

class _ViewListState extends State<ViewList> {
  List<_AZItem> convertedPersonList = [];
  @override
  void initState() {
    addedPersons.sort(
        (a, b) => a.lastname.toLowerCase().compareTo(b.lastname.toLowerCase()));
    initList(addedPersons);
    super.initState();
  }

  void initList(List<Person> persons) {
    convertedPersonList = persons
        .map((person) => _AZItem(
            title: '${person.lastname} ${person.name}',
            tag: person.lastname[0]))
        .toList();
    SuspensionUtil.sortListBySuspensionTag(persons);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AzListView(
        data: addedPersons,
        itemCount: addedPersons.length,
        itemBuilder: (BuildContext context, int index) {
          final person = convertedPersonList[index];
          return _buildListItem(person, true);
        },
        physics: const BouncingScrollPhysics(),
        indexBarItemHeight: blockSizeVertical * 3,
        indexBarData: SuspensionUtil.getTagIndexList(addedPersons),
        indexBarMargin: const EdgeInsets.all(0),
        indexBarOptions: const IndexBarOptions(
          selectItemDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey,
          ),
          selectTextStyle:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          needRebuild: true,
        ));
  }

  _buildListItem(_AZItem person, bool selected) {
    return Card(
        elevation: 0,
        child: ListTile(
            onTap: (() => setState(() {
                  selected = !selected;
                })),
            dense: true,
            subtitle: Text(
              "December 15 1994",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            leading: Checkbox(
              onChanged: (value) {
                selected = value!;
                setState(() {});
                print(selected);
              },
              value: selected,
            ),
            title: Text(
              person.title,
              style: personInfo(),
            )));
  }
}
