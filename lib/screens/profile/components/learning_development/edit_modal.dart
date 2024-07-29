import 'package:animate_do/animate_do.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
import 'package:searchfield/searchfield.dart';
import 'package:unit2/bloc/profile/learningDevelopment/learning_development_bloc.dart';
import 'package:unit2/model/profile/learning_development.dart';
import 'package:unit2/theme-data.dart/btn-style.dart';
import 'package:unit2/utils/global_context.dart';
import 'package:unit2/utils/profile_utilities.dart';
import 'package:unit2/utils/text_container.dart';
import 'package:unit2/utils/validators.dart';
import '../../../../model/location/barangay.dart';
import '../../../../model/location/city.dart';
import '../../../../model/location/country.dart';
import '../../../../model/location/provinces.dart';
import '../../../../model/location/region.dart';
import '../../../../model/utils/agency.dart';
import '../../../../model/utils/category.dart';
import '../../../../theme-data.dart/box_shadow.dart';
import '../../../../theme-data.dart/colors.dart';
import '../../../../theme-data.dart/form-style.dart';
import '../../../../utils/formatters.dart';
import '../../../../utils/global.dart';
import '../../../../utils/location_utilities.dart';
import '../../shared/add_for_empty_search.dart';

class EditLearningAndDevelopmentScreen extends StatefulWidget {
  final int profileId;
  final String token;
  const EditLearningAndDevelopmentScreen(
      {super.key, required this.profileId, required this.token});

  @override
  State<EditLearningAndDevelopmentScreen> createState() =>
      _EditLearningAndDevelopmentScreenState();
}

class _EditLearningAndDevelopmentScreenState
    extends State<EditLearningAndDevelopmentScreen> {
  final formKey = GlobalKey<FormBuilderState>();

  DateFormat dteFormat2 = DateFormat.yMMMMd('en_US');

  bool isPrivate = false;

  bool showSponsorByAgency = false;
  bool showOtherInputs = false;
  bool showTrainingDetails = false;
  bool hasSponsor = false;

  LearningDevelopmentType? selectedLearningDevelopmentType;
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();
////Training
  bool show = true;
  final addTrainingController = TextEditingController();
  ConductedTraining? selectedConductedTraining;
  LearningDevelopmentType? selectedTraining;

////Topic
  final topicFocusNode = FocusNode();
  final addTopicController = TextEditingController();
  LearningDevelopmentType? selectedTopic;
  final currentTopicController = TextEditingController();

////address
  Barangay? selectedBarangay;
  Country? selectedCountry;
  Region? selectedRegion;
  Province? selectedProvince;
  CityMunicipality? selectedMunicipality;
  bool overseas = false;
  bool provinceCall = false;
  bool cityCall = false;
  bool barangayCall = false;
  List<Province>? provinces;
  List<CityMunicipality>? citymuns;
  List<Barangay>? barangays;

  ////Sponsor Agency Searchfield
  Agency? selectedSponsorAgency;
  Category? selectedSponsorAgencyCategory;
  bool showSponsorCategoryAgency = false;
  bool showSponsorAgencyPrivateRadio = false;
  bool sponsorAgencyIsPrivate = false;
  final addSponsorAgencyController = TextEditingController();
  final sponsorByFocusNode = FocusNode();
  final sponsorAgencyCategoryFocusNode = FocusNode();
  final selectedSponsorAgencyController = TextEditingController();
  bool showSponsorByAgencySearchField = false;
////Conducted By
  Agency? selectedConductedByAgency;
  Category? selectedConductedByAgencyCategory;
  bool showConductedByAgencyPrivateRadio = false;
  final conductedByFocusNode = FocusNode();
  final conductedByAgencyCategoryFocusNode = FocusNode();
  final addConductedByController = TextEditingController();
  bool showConductedByAgencyCategory = false;
  bool conductedByCategoryIsPrivate = false;
  final selectedConductedByController = TextEditingController();
  bool showConductedByAgencySearchField = false;
  final selectedTrainingController = TextEditingController();
  DateTime? from;
  DateTime? to;
  @override
  void dispose() {
    fromDateController.dispose();
    toDateController.dispose();
    addTrainingController.dispose();
    topicFocusNode.dispose();
    addTopicController.dispose();
    currentTopicController.dispose();
    addSponsorAgencyController.dispose();
    sponsorByFocusNode.dispose();
    sponsorAgencyCategoryFocusNode.dispose();
    selectedSponsorAgencyController.dispose();
    conductedByFocusNode.dispose();
    conductedByAgencyCategoryFocusNode.dispose();
    addConductedByController.dispose();
    selectedConductedByController.dispose();

    selectedTrainingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LearningDevelopmentBloc, LearningDevelopmentState>(
      builder: (context, state) {
        if (state is LearningDevelopmentUpdatingState) {
          selectedTrainingController.text =
              state.learningDevelopement.conductedTraining!.title!.title!;
          selectedTraining = LearningDevelopmentType(
              id: state.learningDevelopement.conductedTraining!.title!.id,
              title: selectedTrainingController.text);
          selectedConductedByAgency = Agency(
              id: state.learningDevelopement.conductedTraining!.conductedBy!.id,
              name: state
                  .learningDevelopement.conductedTraining!.conductedBy!.name!);
          selectedConductedByController.text =
              state.learningDevelopement.conductedTraining!.conductedBy!.name!;
          selectedLearningDevelopmentType = state.types.firstWhere((element) =>
              element.id ==
              state.learningDevelopement.conductedTraining!
                  .learningDevelopmentType!.id);
          currentTopicController.text =
              state.learningDevelopement.conductedTraining!.topic!.title!;
          selectedTopic = LearningDevelopmentType(
              id: state.learningDevelopement.conductedTraining!.topic!.id,
              title: null);
          fromDateController.text =
              state.learningDevelopement.conductedTraining!.fromDate.toString();
          toDateController.text =
              state.learningDevelopement.conductedTraining!.toDate.toString();
          overseas = state.overseas;
          if (!overseas) {
            selectedRegion = state.currentRegion;
            provinces = state.provinces;
            selectedProvince = state.currentProvince;
            citymuns = state.cities;
            selectedMunicipality = state.currentCity;
            barangays = state.barangay;
            selectedBarangay = state.currentBarangay;
          } else {
            selectedCountry = state.currentCountry;
          }
          hasSponsor = state.learningDevelopement.sponsoredBy != null;
          if (hasSponsor) {
            selectedSponsorAgency = Agency(
                id: state.learningDevelopement.sponsoredBy!.id, name: state.learningDevelopement.sponsoredBy!.name!);
            selectedSponsorAgencyController.text =
                state.learningDevelopement.sponsoredBy!.name!;
          }
          bool enabled;
          if (state.learningDevelopement.conductedTraining?.locked != null &&
              state.learningDevelopement.conductedTraining!.locked == true) {
            enabled = false;
          } else {
            enabled = true;
          }
          from = state.learningDevelopement.conductedTraining?.fromDate;
          to = state.learningDevelopement.conductedTraining?.toDate;
          return FormBuilder(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: ListView(
                  children: [
                    StatefulBuilder(builder: (context, setState) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                              ////Training selected Textfield
                              child: SlideInLeft(
                                child: FormBuilderTextField(
                                                            inputFormatters: [UpperCaseTextFormatter()],
                                                            onChanged: (value) {
                                selectedTraining = LearningDevelopmentType(
                                    id: null,
                                    title: selectedTrainingController.text);
                                                            },
                                                            enabled: enabled,
                                                            maxLines: 5,
                                                            controller: selectedTrainingController,
                                                            name: "",
                                                            decoration: normalTextFieldStyle("", "").copyWith(
                                  labelText: "Training",
                                  filled: !enabled,
                                  fillColor: Colors.grey.shade300),
                                                          ),
                              )),
                          SizedBox(
                              child: SizedBox(
                            child: Column(children: [
                              const SizedBox(
                                height: 12,
                              ),
                              ////learning development type
                              SlideInLeft(
                                                                 delay: const Duration(milliseconds: 150),
                                child: FormBuilderDropdown<LearningDevelopmentType>(
                                  enabled: enabled,
                                  name: "types",
                                  decoration: normalTextFieldStyle(
                                          "Learning Development Type *", "")
                                      .copyWith(
                                          filled: !enabled,
                                          fillColor: Colors.grey.shade300),
                                  validator: FormBuilderValidators.required(
                                      errorText: "This field is required"),
                                  items: state.types
                                      .map((e) => DropdownMenuItem<
                                              LearningDevelopmentType>(
                                          value: e, child: Text(e.title!)))
                                      .toList(),
                                  onChanged: (value) {
                                    selectedLearningDevelopmentType = value;
                                  },
                                  initialValue: selectedLearningDevelopmentType,
                                ),
                              ),

                              //// learning development topics
                              const SizedBox(
                                height: 12,
                              ),
                              StatefulBuilder(builder: (context, setState) {
                                return SlideInLeft(
                                                                delay: const Duration(milliseconds: 170),
                                  child: SearchField(
                                    inputFormatters: [UpperCaseTextFormatter()],
                                  
                                    enabled: enabled,
                                    controller: currentTopicController,
                                    focusNode: topicFocusNode,
                                    itemHeight: 100,
                                    suggestionsDecoration:
                                        searchFieldDecoration(),
                                    suggestions: state.topics
                                        .map((LearningDevelopmentType topic) =>
                                            SearchFieldListItem(topic.title!,
                                                item: topic,
                                                child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10),
                                                    child: ListTile(
                                                      title: Text(
                                                        topic.title!,
                                                        softWrap: true,
                                                      ),
                                                    ))))
                                        .toList(),
                                  
                                    searchInputDecoration:
                                        normalTextFieldStyle("Topic *", "")
                                            .copyWith(
                                                filled: !enabled,
                                                fillColor: Colors.grey.shade300,
                                                suffixIcon: IconButton(
                                                  icon: const Icon(
                                                      Icons.arrow_drop_down),
                                                  onPressed: () {
                                                    topicFocusNode.unfocus();
                                                  },
                                                )),
                                    onSuggestionTap: (topic) {
                                      if (topic.item?.id != null) {
                                        selectedTopic = LearningDevelopmentType(
                                            id: topic.item!.id, title: null);
                                      } else {
                                        selectedTopic = LearningDevelopmentType(
                                            id: null, title: topic.item!.title);
                                      }
                                      setState(() {
                                        topicFocusNode.unfocus();
                                      });
                                    },
                                    ////EMPTY WIDGET
                                    emptyWidget: EmptyWidget(
                                        title: "Add Topic",
                                        controller: addTopicController,
                                        onpressed: () {
                                          setState(() {
                                            LearningDevelopmentType newTopic =
                                                LearningDevelopmentType(
                                                    id: null,
                                                    title: addTopicController.text
                                                        .toUpperCase());
                                            state.topics.insert(0, newTopic);
                                            topicFocusNode.unfocus();
                                            addTopicController.text = "";
                                            Navigator.pop(context);
                                          });
                                        }),
                                    validator: (position) {
                                      if (position!.isEmpty) {
                                        return "This field is required";
                                      }
                                      return null;
                                    },
                                  ),
                                );
                              }),

                              const SizedBox(
                                height: 12,
                              ),
                              //// Conducted By AGENCY
                              StatefulBuilder(builder: (context, setState) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      child: showConductedByAgencySearchField
                                          ? SlideInLeft(
                                                                   delay: const Duration(milliseconds: 190),
                                            child: SearchableDropdown.paginated(
                                                backgroundDecoration: (child) {
                                                  return Card(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16),
                                                      child: child,
                                                    ),
                                                  );
                                                },
                                                hintText:
                                                    const Text("Conducted By"),
                                                changeCompletionDelay:
                                                    const Duration(
                                                        milliseconds: 1200),
                                                ////Empty result
                                                noRecordText: EmptyWidget(
                                                    controller:
                                                        addConductedByController,
                                                    onpressed: () {
                                                      setState(() {
                                                        Agency newAgency = Agency(
                                                            id: null,
                                                            name:
                                                                addConductedByController
                                                                    .text
                                                                    .toUpperCase(),
                                                            category: null,
                                                            privateEntity: null);
                                                        selectedConductedByAgency =
                                                            newAgency;
                                                        addConductedByController
                                                            .text = "";
                                                        showConductedByAgencyCategory =
                                                            true;
                                                        showConductedByAgencyPrivateRadio =
                                                            true;
                                                        showConductedByAgencySearchField =
                                                            !showConductedByAgencySearchField;
                                                        Navigator.pop(context);
                                            
                                                        Navigator.of(context)
                                                            .pop();
                                                      });
                                                    },
                                                    title: "Add Agency"),
                                                paginatedRequest: (int page,
                                                    String? key) async {
                                                  List<Agency> paginatedAgency =
                                                      [];
                                                  try {
                                                    paginatedAgency =
                                                        await ProfileUtilities
                                                            .instance
                                                            .getPaginatedAgencies(
                                                                key: key ??= '');
                                                    return paginatedAgency
                                                        .map((e) {
                                                      return SearchableDropdownMenuItem(
                                                          value: e,
                                                          onTap: () {
                                                            setState(() {
                                                              selectedConductedByAgency =
                                                                  e;
                                            
                                                              showConductedByAgencySearchField =
                                                                  !showConductedByAgencySearchField;
                                                            });
                                                          },
                                                          label: e.name!,
                                                          child: ListTile(
                                                            title: Text(e.name!),
                                                            subtitle:
                                                                e.privateEntity ==
                                                                        true
                                                                    ? const Text(
                                                                        "Private")
                                                                    : const Text(
                                                                        "Government"),
                                                          ));
                                                    }).toList();
                                                  } catch (e) {
                                                    debugPrint(e.toString());
                                                  }
                                                  return null;
                                                }),
                                          )
                                          : const SizedBox(),
                                    ),
                                    const Gap(12),
                                    SizedBox(
                                      child: !showConductedByAgencySearchField
                                          ? Column(
                                            children: [
                                              SlideInLeft(
                                                               delay: const Duration(milliseconds: 190),
                                                child: TextFormField(
                                                    initialValue:
                                                        selectedConductedByAgency!
                                                            .name,
                                                    decoration: normalTextFieldStyle(
                                                            "Conducted By",
                                                            "Conducted By")
                                                        .copyWith(
                                                            labelText: "Conducted by",
                                                            suffixIcon: IconButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    selectedConductedByAgency =
                                                                        null;
                                                                    showConductedByAgencyCategory =
                                                                        false;
                                                
                                                                    conductedByCategoryIsPrivate =
                                                                        false;
                                                                    showConductedByAgencySearchField =
                                                                        !showConductedByAgencySearchField;
                                                                  });
                                                                },
                                                                icon: const Icon(
                                                                    Icons.close))),
                                                  ),
                                              ),
                                                const Gap(12),
                                            ],
                                          )
                                          : const SizedBox(),
                                    ),
                                    SizedBox(
                                      height: showConductedByAgencyCategory
                                          ? 12
                                          : 0,
                                    ),
                                    ////SHOW CATEGORY AGENCY
                                    SizedBox(
                                      child: showConductedByAgencyCategory
                                          ? SearchField(
                                              focusNode:
                                                  conductedByAgencyCategoryFocusNode,
                                              itemHeight: 70,
                                              suggestions: state.agencyCategory
                                                  .map((Category category) =>
                                                      SearchFieldListItem(
                                                          category.name!,
                                                          item: category,
                                                          child: ListTile(
                                                            title: Text(
                                                                category.name!),
                                                            subtitle: Text(category
                                                                .industryClass!
                                                                .name!),
                                                          )))
                                                  .toList(),
                                              emptyWidget: Container(
                                                height: 100,
                                                decoration: box1(),
                                                child: const Center(
                                                    child: Text(
                                                        "No result found ...")),
                                              ),
                                              onSuggestionTap:
                                                  (agencyCategory) {
                                                setState(() {
                                                  selectedConductedByAgencyCategory =
                                                      agencyCategory.item;
                                                  conductedByAgencyCategoryFocusNode
                                                      .unfocus();
                                                  selectedConductedByAgency = Agency(
                                                      id: null,
                                                      name:
                                                          selectedConductedByAgency!
                                                              .name,
                                                      category:
                                                          selectedConductedByAgencyCategory,
                                                      privateEntity: null);
                                                });
                                              },
                                              searchInputDecoration:
                                                  normalTextFieldStyle(
                                                          "Category *", "")
                                                      .copyWith(
                                                          suffixIcon:
                                                              IconButton(
                                                icon: const Icon(
                                                    Icons.arrow_drop_down),
                                                onPressed: () {
                                                  conductedByAgencyCategoryFocusNode
                                                      .unfocus();
                                                },
                                              )),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "This field is required";
                                                }
                                                return null;
                                              },
                                            )
                                          : const SizedBox(),
                                    ),

                                    ////PRVIATE SECTOR
                                    SizedBox(
                                        child: showConductedByAgencyPrivateRadio
                                            ? FormBuilderRadioGroup(
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  label: Row(
                                                    children: [
                                                      Text(
                                                        "Is this private sector? ",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headlineSmall!
                                                            .copyWith(
                                                                fontSize: 24),
                                                      ),
                                                      const Icon(FontAwesome
                                                          .help_circled)
                                                    ],
                                                  ),
                                                ),

                                                ////onvhange private sector
                                                onChanged: (value) {
                                                  setState(() {
                                                    if (value.toString() ==
                                                        "YES") {
                                                      conductedByCategoryIsPrivate =
                                                          true;
                                                    } else {
                                                      conductedByCategoryIsPrivate =
                                                          false;
                                                    }
                                                    selectedConductedByAgency = Agency(
                                                        id: null,
                                                        name:
                                                            selectedConductedByAgency!
                                                                .name,
                                                        category:
                                                            selectedConductedByAgencyCategory,
                                                        privateEntity:
                                                            conductedByCategoryIsPrivate);
                                                    conductedByFocusNode
                                                        .unfocus();
                                                    conductedByAgencyCategoryFocusNode
                                                        .unfocus();
                                                  });
                                                },

                                                name: 'conductedByisPrivate',
                                                validator: FormBuilderValidators
                                                    .required(),
                                                options: ["YES", "NO"]
                                                    .map((lang) =>
                                                        FormBuilderFieldOption(
                                                            value: lang))
                                                    .toList(growable: false),
                                              )
                                            : const SizedBox()),
                                  ],
                                );
                              }),
                              SlideInLeft(
                                             delay: const Duration(milliseconds: 210),
                                child: SizedBox(
                                  width: screenWidth,
                                  child: Row(
                                    children: [
                                      //// FROM DATE
                                      Flexible(
                                          flex: 1,
                                          child: DateTimePicker(
                                            validator:
                                                FormBuilderValidators.required(
                                                    errorText:
                                                        "This field is required"),
                                            use24HourFormat: false,
                                            icon: const Icon(Icons.date_range),
                                            controller: fromDateController,
                                            firstDate: DateTime(1990),
                                            lastDate: DateTime(2100),
                                            selectableDayPredicate: (date) {
                                              if (to != null &&
                                                  to!.microsecondsSinceEpoch <
                                                      date.microsecondsSinceEpoch) {
                                                return false;
                                              }
                                              return true;
                                            },
                                            onChanged: (value) {
                                              setState(() {
                                                from = DateTime.tryParse(value);
                                              });
                                            },
                                            initialDate: to ??= DateTime.now(),
                                            timeHintText:
                                                "Date of Examination/Conferment",
                                            decoration: normalTextFieldStyle(
                                                    "From *", "From *")
                                                .copyWith(
                                                    filled: !enabled,
                                                    fillColor:
                                                        Colors.grey.shade300,
                                                    prefixIcon: const Icon(
                                                      Icons.date_range,
                                                      color: Colors.black87,
                                                    )),
                                          )),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      //// TO DATE
                                      Flexible(
                                        flex: 1,
                                        child: DateTimePicker(
                                            validator:
                                                FormBuilderValidators.required(
                                                    errorText:
                                                        "This field is required"),
                                            controller: toDateController,
                                            firstDate: DateTime(1990),
                                            lastDate: DateTime(2100),
                                            decoration: normalTextFieldStyle(
                                                    "To *", "To *")
                                                .copyWith(
                                              filled: !enabled,
                                              fillColor: Colors.grey.shade300,
                                              prefixIcon: const Icon(
                                                Icons.date_range,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            selectableDayPredicate: (date) {
                                              if (from != null &&
                                                  from!.microsecondsSinceEpoch >
                                                      date.microsecondsSinceEpoch) {
                                                return false;
                                              }
                                              return true;
                                            },
                                            onChanged: (value) {
                                              setState(() {
                                                to = DateTime.tryParse(value);
                                              });
                                            },
                                            initialDate: from ??= DateTime.now()),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              //// total hours conducted
                              SlideInLeft(
                                       delay: const Duration(milliseconds: 230),
                                child: FormBuilderTextField(
                                  initialValue: state.learningDevelopement
                                      .conductedTraining!.totalHours
                                      .toString(),
                                  validator: numericRequired,
                                  name: "total_hours",
                                  decoration: normalTextFieldStyle(
                                    "Total Hours Conducted *",
                                    "0",
                                  ).copyWith(
                                      filled: !enabled,
                                      fillColor: Colors.grey.shade300),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              ////Address

                              const SizedBox(
                                height: 12,
                              ),
                              StatefulBuilder(builder: (context, setState) {
                                return Column(
                                  children: [
                                    SlideInLeft(
                                                                  delay: const Duration(milliseconds: 250),
                                      child: FormBuilderSwitch(
                                        initialValue: overseas,
                                        activeColor: second,
                                        onChanged: (value) {
                                          setState(() {
                                            overseas = value!;
                                          });
                                        },
                                        decoration: normalTextFieldStyle(
                                            "Overseas Address?", ''),
                                        name: 'overseas',
                                        title: Text(overseas ? "YES" : "NO"),
                                      ),
                                    ),
                                    SizedBox(
                                      height: overseas == true ? 8 : 0,
                                    ),
                                    SizedBox(
                                      child: overseas == false
                                          ? Column(
                                              children: [
                                                const SizedBox(
                                                  height: 12,
                                                ),
                                                ////REGION DROPDOWN
                                                SlideInLeft(
                                                                            delay: const Duration(milliseconds: 270),
                                                  child: FormBuilderDropdown<Region?>(
                                                    enabled: !enabled
                                                        ? overseas
                                                        : true,
                                                    name: "region",
                                                    isExpanded: true,
                                                    initialValue: selectedRegion,
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    validator: FormBuilderValidators
                                                        .required(
                                                            errorText:
                                                                "This field is required"),
                                                    onChanged:
                                                        (Region? region) async {
                                                      if (selectedRegion !=
                                                          region) {
                                                        setState(() {
                                                          selectedRegion = region;
                                                        });
                                                  
                                                        //// GET PROVINCES
                                                        try {
                                                          provinces = await LocationUtils
                                                              .instance
                                                              .getProvinces(
                                                                  selectedRegion:
                                                                      selectedRegion!);
                                                        } catch (e) {
                                                          context
                                                              .read<
                                                                  LearningDevelopmentBloc>()
                                                              .add(CallErrorState(
                                                                  message: e
                                                                      .toString()));
                                                        }
                                                  
                                                        setState(() {
                                                          selectedProvince =
                                                              provinces![0];
                                                        });
                                                        //// GET CITIES
                                                        try {
                                                          citymuns = await LocationUtils
                                                              .instance
                                                              .getCities(
                                                                  selectedProvince:
                                                                      selectedProvince!);
                                                        } catch (e) {
                                                          NavigationService
                                                              .navigatorKey
                                                              .currentContext
                                                              ?.read<
                                                                  LearningDevelopmentBloc>()
                                                              .add(CallErrorState(
                                                                  message: e
                                                                      .toString()));
                                                        }
                                                  
                                                        setState(() {
                                                          selectedMunicipality =
                                                              citymuns![0];
                                                        });
                                                        //// GET BARANGAY
                                                        try {
                                                          barangays = await LocationUtils
                                                              .instance
                                                              .getBarangay(
                                                                  cityMunicipality:
                                                                      selectedMunicipality!);
                                                        } catch (e) {
                                                          NavigationService
                                                              .navigatorKey
                                                              .currentContext
                                                              ?.read<
                                                                  LearningDevelopmentBloc>()
                                                              .add(CallErrorState(
                                                                  message: e
                                                                      .toString()));
                                                        }
                                                  
                                                        setState(() {
                                                          selectedBarangay =
                                                              barangays![0];
                                                        });
                                                        ////GET CITY MUNICIPALITY
                                                        try {
                                                          citymuns = await LocationUtils
                                                              .instance
                                                              .getCities(
                                                                  selectedProvince:
                                                                      selectedProvince!);
                                                        } catch (e) {
                                                          NavigationService
                                                              .navigatorKey
                                                              .currentContext
                                                              ?.read<
                                                                  LearningDevelopmentBloc>()
                                                              .add(CallErrorState(
                                                                  message: e
                                                                      .toString()));
                                                        }
                                                  
                                                        setState(() {
                                                          selectedMunicipality =
                                                              citymuns![0];
                                                        });
                                                        //// GET BARANGAYS
                                                        try {
                                                          barangays = await LocationUtils
                                                              .instance
                                                              .getBarangay(
                                                                  cityMunicipality:
                                                                      selectedMunicipality!);
                                                        } catch (e) {
                                                          NavigationService
                                                              .navigatorKey
                                                              .currentContext
                                                              ?.read<
                                                                  LearningDevelopmentBloc>()
                                                              .add(CallErrorState(
                                                                  message: e
                                                                      .toString()));
                                                        }
                                                  
                                                        setState(() {
                                                          selectedBarangay =
                                                              barangays![0];
                                                        });
                                                      }
                                                    },
                                                    decoration:
                                                        normalTextFieldStyle(
                                                                "Region*",
                                                                "Region")
                                                            .copyWith(
                                                                filled: !enabled
                                                                    ? !overseas
                                                                    : false,
                                                                fillColor: Colors
                                                                    .grey
                                                                    .shade300),
                                                    items: state.regions.map<
                                                            DropdownMenuItem<
                                                                Region>>(
                                                        (Region region) {
                                                      return DropdownMenuItem<
                                                              Region>(
                                                          value: region,
                                                          child: Text(region
                                                              .description!));
                                                    }).toList(),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                //// PROVINCE DROPDOWN
                                                SizedBox(
                                                  height: 60,
                                                  child: SlideInLeft(
                                                                                         delay: const Duration(milliseconds: 290),
                                                    child: DropdownButtonFormField<
                                                            Province?>(
                                                        autovalidateMode:
                                                            AutovalidateMode
                                                                .onUserInteraction,
                                                        validator: (value) =>
                                                            value == null
                                                                ? 'required'
                                                                : null,
                                                        isExpanded: true,
                                                        value: selectedProvince,
                                                        onChanged: (Province?
                                                            province) async {
                                                          if (selectedProvince !=
                                                              province) {
                                                            setState(() {
                                                              selectedProvince =
                                                                  province;
                                                            });
                                                    
                                                            //// GET CITIES
                                                            try {
                                                              citymuns = await LocationUtils
                                                                  .instance
                                                                  .getCities(
                                                                      selectedProvince:
                                                                          selectedProvince!);
                                                            } catch (e) {
                                                              NavigationService
                                                                  .navigatorKey
                                                                  .currentContext
                                                                  ?.read<
                                                                      LearningDevelopmentBloc>()
                                                                  .add(CallErrorState(
                                                                      message: e
                                                                          .toString()));
                                                            }
                                                    
                                                            setState(() {
                                                              selectedMunicipality =
                                                                  citymuns![0];
                                                            });
                                                            //// GET BARANGAY
                                                            try {
                                                              barangays = await LocationUtils
                                                                  .instance
                                                                  .getBarangay(
                                                                      cityMunicipality:
                                                                          selectedMunicipality!);
                                                            } catch (e) {
                                                              NavigationService
                                                                  .navigatorKey
                                                                  .currentContext
                                                                  ?.read<
                                                                      LearningDevelopmentBloc>()
                                                                  .add(CallErrorState(
                                                                      message: e
                                                                          .toString()));
                                                            }
                                                    
                                                            setState(() {
                                                              selectedBarangay =
                                                                  barangays![0];
                                                            });
                                                          }
                                                        },
                                                        items: provinces == null
                                                            ? []
                                                            : provinces!
                                                                .map<DropdownMenuItem<Province>>(
                                                                    (Province
                                                                        province) {
                                                                return DropdownMenuItem(
                                                                    enabled: !enabled
                                                                        ? overseas
                                                                        : true,
                                                                    value:
                                                                        province,
                                                                    child:
                                                                        FittedBox(
                                                                      child: Text(
                                                                          province
                                                                              .description!),
                                                                    ));
                                                              }).toList(),
                                                        decoration: normalTextFieldStyle(
                                                                "Province*", "Province")
                                                            .copyWith(
                                                                filled: !enabled
                                                                    ? !overseas
                                                                    : false,
                                                                fillColor: Colors
                                                                    .grey
                                                                    .shade300)),
                                                  ),
                                                ),
                                                ////CITY MUNICIPALITY
                                                SizedBox(
                                                  height: 60,
                                                  child:
                                                      SlideInLeft(
                                                                                                           delay: const Duration(milliseconds: 310),
                                                        child: DropdownButtonFormField<
                                                            CityMunicipality>(
                                                                                                            validator: FormBuilderValidators
                                                          .required(
                                                              errorText:
                                                                  "This field is required"),
                                                                                                            isExpanded: true,
                                                                                                            onChanged:
                                                          (CityMunicipality?
                                                              city) async {
                                                        if (selectedMunicipality !=
                                                            city) {
                                                          setState(() {
                                                            selectedMunicipality =
                                                                city;
                                                          });
                                                        
                                                          //// GET BARANGAYS
                                                          try {
                                                            barangays = await LocationUtils
                                                                .instance
                                                                .getBarangay(
                                                                    cityMunicipality:
                                                                        selectedMunicipality!);
                                                          } catch (e) {
                                                            NavigationService
                                                                .navigatorKey
                                                                .currentContext
                                                                ?.read<
                                                                    LearningDevelopmentBloc>()
                                                                .add(CallErrorState(
                                                                    message: e
                                                                        .toString()));
                                                          }
                                                        
                                                          setState(() {
                                                            selectedBarangay =
                                                                barangays![0];
                                                          });
                                                        }
                                                                                                            },
                                                                                                            decoration:
                                                          normalTextFieldStyle(
                                                                  "Municipality*",
                                                                  "Municipality")
                                                              .copyWith(
                                                                  filled: !enabled
                                                                      ? !overseas
                                                                      : false,
                                                                  fillColor: Colors
                                                                      .grey
                                                                      .shade300),
                                                                                                            value: selectedMunicipality,
                                                                                                            items: citymuns == null
                                                          ? []
                                                          : citymuns!.map<
                                                                  DropdownMenuItem<
                                                                      CityMunicipality>>(
                                                              (CityMunicipality
                                                                  c) {
                                                              return DropdownMenuItem(
                                                                  enabled: !enabled
                                                                      ? overseas
                                                                      : true,
                                                                  value: c,
                                                                  child: Text(c
                                                                      .description!));
                                                            }).toList(),
                                                                                                          ),
                                                      ),
                                                ),
                                                //// BARANGAY
                                                SizedBox(
                                                  height: 60,
                                                  child:
                                                      SlideInLeft(

                                                                                                           delay: const Duration(milliseconds: 330),
                                                        child: DropdownButtonFormField<
                                                            Barangay>(
                                                                                                            isExpanded: true,
                                                                                                            onChanged:
                                                          (Barangay? baragay) {
                                                        selectedBarangay =
                                                            baragay;
                                                                                                            },
                                                                                                            decoration:
                                                          normalTextFieldStyle(
                                                                  "Barangay*",
                                                                  "Barangay")
                                                              .copyWith(
                                                                  filled: !enabled
                                                                      ? !overseas
                                                                      : false,
                                                                  fillColor: Colors
                                                                      .grey
                                                                      .shade300),
                                                                                                            value: selectedBarangay,
                                                                                                            items: barangays == null
                                                          ? []
                                                          : barangays!.map<
                                                                  DropdownMenuItem<
                                                                      Barangay>>(
                                                              (Barangay
                                                                  barangay) {
                                                              return DropdownMenuItem(
                                                                  enabled: !enabled
                                                                      ? overseas
                                                                      : true,
                                                                  value: barangay,
                                                                  child: Text(barangay
                                                                      .description!));
                                                            }).toList(),
                                                                                                          ),
                                                      ),
                                                ),
                                              ],
                                            )
                                          //// COUNTRY DROPDOWN
                                          : SizedBox(
                                              height: 60,
                                              child:
                                                  SlideInLeft(
                                                    child: FormBuilderDropdown<Country>(
                                                                                                    enabled: overseas,
                                                                                                    initialValue:
                                                      selectedCountry?.id == 175
                                                          ? null
                                                          : selectedCountry,
                                                                                                    validator: FormBuilderValidators
                                                      .required(
                                                          errorText:
                                                              "This field is required"),
                                                                                                    items: state.countries.map<
                                                          DropdownMenuItem<
                                                              Country>>(
                                                      (Country country) {
                                                    return DropdownMenuItem<
                                                            Country>(
                                                        value: country,
                                                        child: FittedBox(
                                                            child: Text(
                                                                country.name!)));
                                                                                                    }).toList(),
                                                                                                    name: 'country',
                                                                                                    decoration:
                                                      normalTextFieldStyle(
                                                              "Country*",
                                                              "Country")
                                                          .copyWith(
                                                              filled: !overseas,
                                                              fillColor: Colors
                                                                  .grey.shade300),
                                                                                                    onChanged: (Country? value) {
                                                    selectedCountry = value;
                                                                                                    },
                                                                                                  ),
                                                  ),
                                            ),
                                    ),
                                  ],
                                );
                              }),
                            ]),
                          )),
                          const SizedBox(
                            height: 12,
                          ),

                          ////Sponsor
                          StatefulBuilder(builder: (context, setState) {
                            ////has sponsor switch
                            return Column(
                              children: [
                                SlideInLeft(

                                                                                                           delay: const Duration(milliseconds: 350),
                                  child: FormBuilderSwitch(
                                    initialValue: hasSponsor,
                                    activeColor: second,
                                    onChanged: (value) {
                                      setState(() {
                                        hasSponsor = value!;
                                     if(selectedSponsorAgency?.name == null){
                                            showSponsorByAgencySearchField = true;
                                     }else{
                                            showSponsorByAgencySearchField = false;
                                     }
                                      });
                                    },
                                    decoration:
                                        normalTextFieldStyle("Has Sponsor?", ''),
                                    name: 'sponsor',
                                    title: Text(hasSponsor ? "YES" : "NO"),
                                  ),
                                ),
                                ////Add Sponsor Agency============
                                SizedBox(
                                  child: hasSponsor
                                      ? ////Sponsor AGENCY
                                      StatefulBuilder(
                                          builder: (context, setState) {
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                child:
                                                    showSponsorByAgencySearchField
                                                        ? SearchableDropdown
                                                            .paginated(
                                                                backgroundDecoration:
                                                                    (child) {
                                                                  return Card(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          16),
                                                                      child:
                                                                          child,
                                                                    ),
                                                                  );
                                                                },
                                                                hintText:
                                                                    const Text(
                                                                        "Search Sponsor Agency"),
                                                                changeCompletionDelay:
                                                                    const Duration(
                                                                        milliseconds:
                                                                            1200),
                                                                ////Empty result
                                                                noRecordText:
                                                                    EmptyWidget(
                                                                        controller:
                                                                            addSponsorAgencyController,
                                                                        onpressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            Agency newAgency = Agency(
                                                                                id: null,
                                                                                name: addSponsorAgencyController.text.toUpperCase(),
                                                                                category: null,
                                                                                privateEntity: null);
                                                                            selectedSponsorAgency =
                                                                                newAgency;
                                                                            addSponsorAgencyController.text =
                                                                                "";
                                                                            showSponsorCategoryAgency =
                                                                                true;
                                                                            showSponsorAgencyPrivateRadio =
                                                                                true;
                                                                            showSponsorByAgencySearchField = false;
                                                                            
                                                                            Navigator.pop(context);

                                                                            Navigator.of(context).pop();
                                                                          });
                                                                        },
                                                                        title:
                                                                            "Add Agency"),
                                                                paginatedRequest:
                                                                    (int page,
                                                                        String?
                                                                            key) async {
                                                                  List<Agency>
                                                                      paginatedAgency =
                                                                      [];
                                                                  try {
                                                                    paginatedAgency = await ProfileUtilities
                                                                        .instance
                                                                        .getPaginatedAgencies(
                                                                            key: key ??=
                                                                                '');
                                                                    return paginatedAgency
                                                                        .map(
                                                                            (e) {
                                                                      return SearchableDropdownMenuItem(
                                                                          value:
                                                                              e,
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              selectedSponsorAgency = e;
                                                                              showSponsorByAgencySearchField = false;
                                                                            });
                                                                          },
                                                                          label: e
                                                                              .name!,
                                                                          child:
                                                                              ListTile(
                                                                            title:
                                                                                Text(e.name!),
                                                                            subtitle: e.privateEntity == true
                                                                                ? const Text("Private")
                                                                                : const Text("Government"),
                                                                          ));
                                                                    }).toList();
                                                                  } catch (e) {
                                                                    debugPrint(e
                                                                        .toString());
                                                                  }
                                                                  return null;
                                                                })
                                                        : const SizedBox(),
                                              ),
                                              const Gap(12),
                                              SizedBox(
                                                child:
                                                    showSponsorByAgencySearchField == false
                                                        ? SlideInLeft(
                                                                                              delay: const Duration(milliseconds: 370),
                                                          child: TextFormField(
                                                            initialValue: selectedSponsorAgency?.name,
                                                                                                              
                                                              decoration: normalTextFieldStyle(
                                                                      "",
                                                                      "")
                                                                  .copyWith(
                                                                      labelText:
                                                                          "Training",
                                                                      suffixIcon:
                                                                          IconButton(
                                                                              onPressed:
                                                                                  () {
                                                                                setState(() {
                                                                                  selectedSponsorAgency = null;
                                                                                  showSponsorCategoryAgency = false;
                                                                                  showSponsorAgencyPrivateRadio = false;
                                                                                  showSponsorByAgencySearchField = true;
                                                                                });
                                                                              },
                                                                              icon:
                                                                                  const Icon(Icons.close))),
                                                            ),
                                                        )
                                                        : const SizedBox(),
                                              ),
                                              SizedBox(
                                                height:
                                                    showSponsorCategoryAgency
                                                        ? 12
                                                        : 0,
                                              ),
                                              ////SHOW CATEGORY AGENCY
                                              SizedBox(
                                                child: showSponsorCategoryAgency
                                                    ? SearchField(
                                                        focusNode:
                                                            sponsorAgencyCategoryFocusNode,
                                                        itemHeight: 70,
                                                        suggestions: state
                                                            .agencyCategory
                                                            .map((Category
                                                                    category) =>
                                                                SearchFieldListItem(
                                                                    category
                                                                        .name!,
                                                                    item:
                                                                        category,
                                                                    child:
                                                                        ListTile(
                                                                      title: Text(
                                                                          category
                                                                              .name!),
                                                                      subtitle: Text(category
                                                                          .industryClass!
                                                                          .name!),
                                                                    )))
                                                            .toList(),
                                                        emptyWidget: Container(
                                                          height: 100,
                                                          decoration: box1(),
                                                          child: const Center(
                                                              child: Text(
                                                                  "No result found ...")),
                                                        ),
                                                        onSuggestionTap:
                                                            (agencyCategory) {
                                                          setState(() {
                                                            selectedSponsorAgencyCategory =
                                                                agencyCategory
                                                                    .item;
                                                            sponsorAgencyCategoryFocusNode
                                                                .unfocus();
                                                            selectedSponsorAgency = Agency(
                                                                id: null,
                                                                name:
                                                                    selectedSponsorAgency!
                                                                        .name,
                                                                category:
                                                                    selectedSponsorAgencyCategory,
                                                                privateEntity:
                                                                    null);
                                                          });
                                                        },
                                                        searchInputDecoration:
                                                            normalTextFieldStyle(
                                                                    "Category *",
                                                                    "")
                                                                .copyWith(
                                                                    suffixIcon:
                                                                        IconButton(
                                                          icon: const Icon(Icons
                                                              .arrow_drop_down),
                                                          onPressed: () {
                                                            sponsorAgencyCategoryFocusNode
                                                                .unfocus();
                                                          },
                                                        )),
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return "This field is required";
                                                          }
                                                          return null;
                                                        },
                                                      )
                                                    : const SizedBox(),
                                              ),

                                              ////PRVIATE SECTOR
                                              SizedBox(
                                                  child:
                                                      showSponsorAgencyPrivateRadio
                                                          ? StatefulBuilder(
                                                              builder: (context,
                                                                  setState) {
                                                              return FormBuilderRadioGroup(
                                                                decoration:
                                                                    InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  label: Row(
                                                                    children: [
                                                                      Text(
                                                                        "Is this private sector? ",
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headlineSmall!
                                                                            .copyWith(fontSize: 24),
                                                                      ),
                                                                      const Icon(
                                                                          FontAwesome
                                                                              .help_circled)
                                                                    ],
                                                                  ),
                                                                ),
                                                                options: [
                                                                  "YES",
                                                                  "NO"
                                                                ]
                                                                    .map((lang) =>
                                                                        FormBuilderFieldOption(
                                                                            value:
                                                                                lang))
                                                                    .toList(
                                                                        growable:
                                                                            false),
                                                                ////onvhange private sector
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    if (value
                                                                            .toString()
                                                                            .toUpperCase() ==
                                                                        "YES") {
                                                                      sponsorAgencyIsPrivate =
                                                                          true;
                                                                    } else {
                                                                      sponsorAgencyIsPrivate =
                                                                          false;
                                                                    }
                                                                    selectedSponsorAgency = Agency(
                                                                        id:
                                                                            null,
                                                                        name: selectedSponsorAgency!
                                                                            .name,
                                                                        category:
                                                                            selectedSponsorAgencyCategory,
                                                                        privateEntity:
                                                                            sponsorAgencyIsPrivate);
                                                                    sponsorAgencyCategoryFocusNode
                                                                        .unfocus();
                                                                    sponsorByFocusNode
                                                                        .unfocus();
                                                                  });
                                                                },

                                                                name:
                                                                    'sponsorByisPrivate',
                                                                validator:
                                                                    FormBuilderValidators
                                                                        .required(),
                                                              );
                                                            })
                                                          : const SizedBox()),
                                            ],
                                          );
                                        })
                                      : const SizedBox(),
                                ),
                              ],
                            );
                          }),
                       
                          const SizedBox(
                            height: 12,
                          ),
                          SlideInLeft(
                                           delay: const Duration(milliseconds: 390),
                            child: FormBuilderTextField(
                              initialValue: state
                                  .learningDevelopement.totalHoursAttended
                                  .toString(),
                              validator: numericRequired,
                              name: "total_hours_attended",
                              keyboardType: TextInputType.number,
                              decoration: normalTextFieldStyle(
                                  "Total Hours Attended *",
                                  "Total Hours Attended *"),
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: FadeInUp(
                        child: ElevatedButton(
                          style:
                              mainBtnStyle(primary, Colors.transparent, second),
                          child: const Text(submit),
                          onPressed: () {
                            if (formKey.currentState!.saveAndValidate()) {
                              ConductedTraining? training;
                              Agency? sponsor;
                              Venue venue;
                              ////Address
                              if (overseas) {
                                venue = Venue(
                                    id: state.learningDevelopement
                                        .conductedTraining!.venue!.id,
                                    country: selectedCountry,
                                    barangay: null,
                                    category: null,
                                    areaClass: null,
                                    cityMunicipality: null);
                              } else {
                                venue = Venue(
                                    id: state.learningDevelopement
                                        .conductedTraining!.venue!.id,
                                    country: Country(
                                        id: 175, name: 'Philippines', code: 'PH'),
                                    barangay: selectedBarangay,
                                    areaClass: null,
                                    category: null,
                                    cityMunicipality: selectedMunicipality);
                              }
                        
                              training = ConductedTraining(
                                  title: selectedTraining,
                                  topic: selectedTopic,
                                  id: state
                                      .learningDevelopement.conductedTraining!.id,
                                  locked: state.learningDevelopement
                                      .conductedTraining?.locked,
                                  venue: venue,
                                  toDate: DateTime.parse(toDateController.text),
                                  fromDate:
                                      DateTime.parse(fromDateController.text),
                                  totalHours: double.parse(
                                      formKey.currentState!.value['total_hours']),
                                  conductedBy: selectedConductedByAgency,
                                  sessionsAttended: [],
                                  learningDevelopmentType:
                                      selectedLearningDevelopmentType);
                        
                              if (hasSponsor) {
                                sponsor = selectedSponsorAgency;
                              }
                              LearningDevelopement learningDevelopement =
                                  LearningDevelopement(
                                      attachments: null,
                                      sponsoredBy: hasSponsor
                                          ? selectedSponsorAgency
                                          : null,
                                      conductedTraining: training,
                                      totalHoursAttended: double.parse(formKey
                                          .currentState!
                                          .value['total_hours_attended']));
                              final progress = ProgressHUD.of(context);
                              progress!.showWithText("Loading...");
                              context.read<LearningDevelopmentBloc>().add(
                                  UpdateLearningDevelopment(
                                      learningDevelopement: learningDevelopement,
                                      profileId: widget.profileId,
                                      token: widget.token));
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ));
        }
        return const Center(
          child: Text("ds"),
        );
      },
    );
  }

  Future<void> getProvinces() async {
    try {
      List<Province> newProvinces = await LocationUtils.instance
          .getProvinces(selectedRegion: selectedRegion!);
      setState(() {
        provinces = newProvinces;
        selectedProvince = provinces![0];
        provinceCall = false;
        cityCall = true;
        getCities();
      });
    } catch (e) {
      context
          .read<LearningDevelopmentBloc>()
          .add(CallErrorState(message: e.toString()));
    }
  }

  Future<void> getCities() async {
    try {
      List<CityMunicipality> newCities = await LocationUtils.instance
          .getCities(selectedProvince: selectedProvince!);
      citymuns = newCities;
      setState(() {
        selectedMunicipality = newCities[0];
        cityCall = false;
        barangayCall = true;
        getBarangays();
      });
    } catch (e) {
      context
          .read<LearningDevelopmentBloc>()
          .add(CallErrorState(message: e.toString()));
    }
  }

  Future<void> getBarangays() async {
    try {
      List<Barangay> newBarangays = await LocationUtils.instance
          .getBarangay(cityMunicipality: selectedMunicipality!);
      barangays = newBarangays;
      setState(() {
        selectedBarangay = newBarangays[0];
        barangayCall = false;
      });
    } catch (e) {
      context
          .read<LearningDevelopmentBloc>()
          .add(CallErrorState(message: e.toString()));
    }
  }
}
