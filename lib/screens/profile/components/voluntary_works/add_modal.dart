import 'package:animate_do/animate_do.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
import 'package:searchfield/searchfield.dart';
import 'package:unit2/bloc/profile/voluntary_works/voluntary_work_bloc.dart';
import 'package:unit2/utils/global.dart';
import 'package:unit2/utils/profile_utilities.dart';
import 'package:unit2/widgets/modal_progress_hud.dart';
import '../../../../model/location/city.dart';
import '../../../../model/location/country.dart';
import '../../../../model/location/provinces.dart';
import '../../../../model/location/region.dart';
import '../../../../model/profile/voluntary_works.dart';
import '../../../../model/utils/agency.dart';
import '../../../../model/utils/category.dart';
import '../../../../model/utils/position.dart';
import '../../../../theme-data.dart/box_shadow.dart';
import '../../../../theme-data.dart/btn-style.dart';
import '../../../../theme-data.dart/colors.dart';
import '../../../../theme-data.dart/form-style.dart';
import '../../../../utils/formatters.dart';
import '../../../../utils/location_utilities.dart';
import '../../../../utils/text_container.dart';
import '../../shared/add_for_empty_search.dart';



  ////Sponsor Agency Searchfield
  Agency? selectedSponsorAgency;
  Category? selectedSponsorAgencyCategory;
  bool showSponsorCategoryAgency = false;
  bool showSponsorAgencyPrivateRadio = false;
  bool sponsorAgencyIsPrivate = false;
  final addSponsorAgencyController = TextEditingController();
  final sponsorByFocusNode = FocusNode();
  final sponsorAgencyCategoryFocusNode = FocusNode();
      bool showSponsorByAgencySearchField = true;



class AddVoluntaryWorkScreen extends StatefulWidget {
  final int profileId;
  final String token;
  const AddVoluntaryWorkScreen(
      {super.key, required this.profileId, required this.token});

  @override
  State<AddVoluntaryWorkScreen> createState() => _AddVoluntaryWorkScreenState();
}

class _AddVoluntaryWorkScreenState extends State<AddVoluntaryWorkScreen> {
  final formKey = GlobalKey<FormBuilderState>();
  ////controllers
  final addPositionController = TextEditingController();
  final addAgencyController = TextEditingController();
  final toDateController = TextEditingController();
  final fromDateController = TextEditingController();
  ////focus nodes
  final positionFocusNode = FocusNode();
  final agencyFocusNode = FocusNode();
  final agencyCategoryFocusNode = FocusNode();
  ////booleans
  bool showAgency = false;
  bool showIsPrivateRadio = false;
  bool currentlyInvolved = false;
  bool overseas = false;
  bool provinceCall = false;
  bool cityCall = false;
  bool isPrivate = false;
    bool showAgencySearchField = true;
  ////Lists
  List<Province>? provinces;
  List<CityMunicipality>? citymuns;
  ////Selected
  PositionTitle? selectedPosition;
  Agency? selectedAgency;
  Category? selectedCategoty;
  Region? selectedRegion;
  Province? selectedProvince;
  CityMunicipality? selectedMunicipality;
  Country? selectedCountry;
  DateTime? from;
  DateTime? to;
  @override
  void dispose() {
    addPositionController.dispose();
    addAgencyController.dispose();
    toDateController.dispose();
    fromDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoluntaryWorkBloc, VoluntaryWorkState>(
      builder: (context, state) {
        if (state is AddVoluntaryWorkState) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 28),
            child: FormBuilder(
                key: formKey,
                child: ListView(
                  children: [
                                 ////AGENCY
                  StatefulBuilder(builder: (context, setState) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: showAgencySearchField
                              ? SlideInLeft(
                                child: SearchableDropdown.paginated(
                                    backgroundDecoration: (child) {
                                      return Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: child,
                                        ),
                                      );
                                    },
                                    hintText: const Text("Search Agency"),
                                    changeCompletionDelay:
                                        const Duration(milliseconds: 1200),
                                    ////Empty result
                                    noRecordText: EmptyWidget(
                                        controller: addAgencyController,
                                        onpressed: () {
                                          setState(() {
                                            Agency newAgency = Agency(
                                                id: null,
                                                name: addAgencyController.text
                                                    .toUpperCase(),
                                                category: null,
                                                privateEntity: null);
                                            selectedAgency = newAgency;
                                            addAgencyController.text = "";
                                            showAgency = true;
                                            showIsPrivateRadio = true;
                                            showAgencySearchField =
                                                !showAgencySearchField;
                                            Navigator.pop(context);
                                
                                            Navigator.of(context).pop();
                                          });
                                        },
                                        title: "Add Agency"),
                                       
                                    paginatedRequest:
                                        (int page, String? key) async {
                                      List<Agency> paginatedAgency = [];
                                      try {
                                        paginatedAgency = await ProfileUtilities
                                            .instance
                                            .getPaginatedAgencies(
                                                key: key ??= '');
                                        return paginatedAgency.map((e) {
                                          return SearchableDropdownMenuItem(
                                              value: e,
                                              onTap: () {
                                               setState((){
                                                 selectedAgency = e;
                                                               showAgencySearchField =
                                             false;
                                               });
                                              },
                                              label: e.name!,
                                              child: ListTile(
                                                title: Text(e.name!),
                                                subtitle: e.privateEntity == true
                                                    ? const Text("Private")
                                                    : const Text("Government"),
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
                          child: !showAgencySearchField
                              ? Column(
                                children: [
                            
                                  TextFormField(
                                      initialValue: selectedAgency!.name,
                                      decoration:
                                          normalTextFieldStyle("", "").copyWith(
                                              labelText: "Training",
                                              suffixIcon: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      selectedAgency = null;
                                                      showAgency = false;
                                                      showIsPrivateRadio = false;
                                                      showAgencySearchField =
                                                          !showAgencySearchField;
                                                    });
                                                  },
                                                  icon: const Icon(Icons.close))),
                                    ),
                                                          const Gap(12),
                                ],
                              )
                              : const SizedBox(),
                        ),
      
                        ////SHOW CATEGORY AGENCY
                        SizedBox(
                          child: showAgency
                              ? SearchField(
                                  focusNode: agencyCategoryFocusNode,
                                  itemHeight: 70,
                                  suggestions: state.agencyCategory
                                      .map((Category category) =>
                                          SearchFieldListItem(category.name!,
                                              item: category,
                                              child: ListTile(
                                                title: Text(category.name!),
                                                subtitle: Text(category
                                                    .industryClass!.name!),
                                              )))
                                      .toList(),
                                  emptyWidget: Container(
                                    height: 100,
                                    decoration: box1(),
                                    child: const Center(
                                        child: Text("No result found ...")),
                                  ),
                                  onSuggestionTap: (agencyCategory) {
                                    setState(() {
                                      selectedCategoty =
                                          agencyCategory.item;
                                      agencyCategoryFocusNode.unfocus();
                                      selectedAgency = Agency(
                                          id: null,
                                          name: selectedAgency!.name,
                                          category: selectedCategoty,
                                          privateEntity: null);
                                    });
                                  },
                                  searchInputDecoration:
                                      normalTextFieldStyle("Category *", "")
                                          .copyWith(
                                              suffixIcon: IconButton(
                                    icon: const Icon(Icons.arrow_drop_down),
                                    onPressed: () {
                                      agencyCategoryFocusNode.unfocus();
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
                            child: showIsPrivateRadio
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
                                                .copyWith(fontSize: 24),
                                          ),
                                          const Icon(FontAwesome.help_circled)
                                        ],
                                      ),
                                    ),

                                    ////onvhange private sector
                                    onChanged: (value) {
                                      setState(() {
                                        if (value.toString() == "YES") {
                                          isPrivate = true;
                                
                                        } else {
                                          isPrivate = false;
                               
                                        }
                                        selectedAgency = Agency(
                                            id: null,
                                            name: selectedAgency!.name,
                                            category: selectedCategoty,
                                            privateEntity: isPrivate
                                               );
                                        agencyFocusNode.unfocus();
                                        agencyCategoryFocusNode.unfocus();
                                      });
             
                                    },

                                    name: 'isPrivate',
                                    validator: FormBuilderValidators.required(),
                                    options: ["YES", "NO"]
                                        .map((lang) =>
                                            FormBuilderFieldOption(value: lang))
                                        .toList(growable: false),
                                  )
                                : const SizedBox()),
                    
                        ////SALARY GRADE AND SALARY GRADE STEP
                   
                      ],
                    );
                  }),
                    ////POSITIONS
                    StatefulBuilder(builder: (context, setState) {
                      return SlideInLeft(
                                         
                                                                         delay: const Duration(milliseconds: 150),
                        child: SearchField(
                          inputFormatters: [UpperCaseTextFormatter()],
                          itemHeight: 70,
                          suggestionsDecoration:  searchFieldDecoration(),
                          suggestions: state.positions
                              .map((PositionTitle position) =>
                                  SearchFieldListItem(position.title!,
                                      item: position,
                                      child: Padding(
                                          padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10),
                                          child: ListTile(
                                            title: Text(
                                              position.title!,
                                              overflow:
                                                  TextOverflow.visible,
                                            ),
                                          ))))
                              .toList(),
                          focusNode: positionFocusNode,
                          searchInputDecoration:
                              normalTextFieldStyle("Position *", "")
                                  .copyWith(
                                      suffixIcon: GestureDetector(
                            child: const Icon(Icons.arrow_drop_down),
                            onTap: () => positionFocusNode.unfocus(),
                          )),
                          onSuggestionTap: (position) {
                            setState(() {
                              selectedPosition = position.item;
                              positionFocusNode.unfocus();
                            });
                          },
                          ////EMPTY WIDGET
                          emptyWidget: EmptyWidget(
                              title: "Add Position",
                              controller: addPositionController,
                              onpressed: () {
                                setState(() {
                                  PositionTitle newAgencyPosition = PositionTitle(
                                      id: null,
                                      title: addPositionController.text
                                          .toUpperCase());
                        
                                  state.positions
                                      .insert(0, newAgencyPosition);
                        
                                  addPositionController.text = "";
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
                    //// total hours
                    SlideInLeft(
                                                       delay: const Duration(milliseconds: 170),
                      child: FormBuilderTextField(
                        validator: FormBuilderValidators.required(
                            errorText: "This Field is required"),
                        name: "total_hours",
                        keyboardType: TextInputType.number,
                        decoration:
                            normalTextFieldStyle("Total Hours*", "0"),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    ////Currently Involved
                    StatefulBuilder(builder: (context, setState) {
                      return Column(
                        children: [
                          SlideInLeft(
                                         delay: const Duration(milliseconds: 190),
                            child: FormBuilderSwitch(
                              initialValue: currentlyInvolved,
                              activeColor: second,
                              onChanged: (value) {
                                setState(() {
                                  currentlyInvolved = value!;
                                });
                              },
                              decoration: normalTextFieldStyle(
                                  "Currently Involved?",
                                  'Graduated?'),
                              name: 'currently_involved',
                              title: Text(
                                  currentlyInvolved ? "YES" : "NO"),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          SlideInLeft(
                                                                     delay: const Duration(milliseconds: 210),
                            child: SizedBox(
                              width: screenWidth,
                              child: StatefulBuilder(
                                  builder: (context, setState) {
                                return Row(
                                  children: [
                                    //// FROM DATE
                                    Flexible(
                                        flex: 1,
                                        child: DateTimePicker(
                                          validator: FormBuilderValidators
                                              .required(
                                                  errorText:
                                                      "This field is required"),
                                          use24HourFormat: false,
                                          icon: const Icon(
                                              Icons.date_range),
                                          controller:
                                              fromDateController,
                                          firstDate: DateTime(1990),
                                          lastDate: DateTime(2100),
                                          // selectableDayPredicate:
                                          //     (date) {
                                          //   if (to != null &&
                                          //       to!.microsecondsSinceEpoch >=
                                          //           date.microsecondsSinceEpoch) {
                                          //     return false;
                                          //   }
                                          //   return true;
                                          // },
                                          onChanged: (value) {
                                            setState(() {
                                              from = DateTime.parse(
                                                  value);
                                            });
                                          },
                                          initialDate: to == null
                                              ? DateTime.now()
                                              : to!.subtract(
                                                  const Duration(
                                                      days: 1)),
                                          timeHintText:
                                              "Date of Examination/Conferment",
                                          decoration:
                                              normalTextFieldStyle(
                                                      "From *",
                                                      "From *")
                                                  .copyWith(
                                                      prefixIcon:
                                                          const Icon(
                                            Icons.date_range,
                                            color: Colors.black87,
                                          )),
                                          initialValue: null,
                                        )),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    //// TO DATE
                                    Flexible(
                                      flex: 1,
                                      child: currentlyInvolved
                                          ? TextFormField(
                                              enabled: false,
                                              initialValue: "PRESENT",
                                              style: const TextStyle(
                                                  color:
                                                      Colors.black45),
                                              decoration:
                                                  normalTextFieldStyle(
                                                          "", "")
                                                      .copyWith(),
                                            )
                                          : DateTimePicker(
                                              validator:
                                                  FormBuilderValidators
                                                      .required(
                                                          errorText:
                                                              "This field is required"),
                                              controller:
                                                  toDateController,
                                              // selectableDayPredicate:
                                              //     (date) {
                                              //   if (from != null &&
                                              //       from!.microsecondsSinceEpoch >
                                              //           date.microsecondsSinceEpoch) {
                                              //     return false;
                                              //   }
                                              //   return true;
                                              // },
                                              onChanged: (value) {
                                                setState(() {
                                                  to = DateTime.parse(
                                                      value);
                                                });
                                              },
                                              initialDate: from ==
                                                      null
                                                  ? DateTime.now()
                                                  : from!.add(
                                                      const Duration(
                                                          days: 1)),
                                              firstDate:
                                                  DateTime(1990),
                                              lastDate:
                                                  DateTime(2100),
                                              decoration: normalTextFieldStyle(
                                                      "To *", "To *")
                                                  .copyWith(
                                                      prefixIcon:
                                                          const Icon(
                                                        Icons
                                                            .date_range,
                                                        color: Colors
                                                            .black87,
                                                      ),
                                                      prefixText:
                                                          currentlyInvolved
                                                              ? "PRESENT"
                                                              : ""),
                                              initialValue: null,
                                            ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(
                      height: 12,
                    ),
                    //// OVERSEAS
                    StatefulBuilder(builder: (context, setState) {
                      return Column(
                        children: [
                          SlideInLeft(
                                                delay: const Duration(milliseconds: 230),
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
                            height: overseas == true ? 12 : 0,
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
                                                                   delay: const Duration(milliseconds: 250),
                                        child: FormBuilderDropdown<Region?>(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          validator: FormBuilderValidators
                                              .required(
                                                  errorText:
                                                      "This field is required"),
                                          onChanged:
                                              (Region? region) async {
                                            if (selectedRegion != region) {
                                              setState(() {
                                                provinceCall = true;
                                              });
                                              selectedRegion = region;
                                              getProvinces();
                                            }
                                          },
                                          initialValue: null,
                                          decoration: normalTextFieldStyle(
                                              "Region*", "Region"),
                                          name: 'region',
                                          items: state.regions.map<
                                                  DropdownMenuItem<Region>>(
                                              (Region region) {
                                            return DropdownMenuItem<Region>(
                                                value: region,
                                                child: Text(
                                                    region.description!));
                                          }).toList(),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      //// PROVINCE DROPDOWN
                                      SizedBox(
                                        height: 60,
                                        child: ProgressModalHud(
                              
                                          inAsyncCall: provinceCall,
                                          child: SlideInLeft(
                                                    delay: const Duration(milliseconds: 250),
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
                                                onChanged:
                                                    (Province? province) {
                                                  if (selectedProvince !=
                                                      province) {
                                                    setState(() {
                                                      cityCall = true;
                                                    });
                                                    selectedProvince =
                                                        province;
                                                    getCities();
                                                  }
                                                },
                                                items: provinces == null
                                                    ? []
                                                    : provinces!.map<
                                                            DropdownMenuItem<
                                                                Province>>(
                                                        (Province
                                                            province) {
                                                        return DropdownMenuItem(
                                                            value: province,
                                                            child:
                                                                FittedBox(
                                                              child: Text(
                                                                  province
                                                                      .description!),
                                                            ));
                                                      }).toList(),
                                                decoration:
                                                    normalTextFieldStyle(
                                                        "Province*",
                                                        "Province")),
                                          ),
                                        ),
                                      ),
                                      ////CITY MUNICIPALITY
                                      SizedBox(
                                        height: 60,
                                        child: ProgressModalHud(
                                   
                                          inAsyncCall: cityCall,
                                          child: SlideInLeft(
                                                    delay: const Duration(milliseconds: 270),
                                            child: DropdownButtonFormField<
                                                CityMunicipality>(
                                              validator: FormBuilderValidators
                                                  .required(
                                                      errorText:
                                                          "This field is required"),
                                              isExpanded: true,
                                              onChanged:
                                                  (CityMunicipality? city) {
                                                if (selectedMunicipality !=
                                                    city) {
                                                  selectedMunicipality =
                                                      city;
                                                }
                                              },
                                              decoration:
                                                  normalTextFieldStyle(
                                                      "Municipality*",
                                                      "Municipality"),
                                              value: selectedMunicipality,
                                              items: citymuns == null
                                                  ? []
                                                  : citymuns!.map<
                                                          DropdownMenuItem<
                                                              CityMunicipality>>(
                                                      (CityMunicipality c) {
                                                      return DropdownMenuItem(
                                                          value: c,
                                                          child: Text(c
                                                              .description!));
                                                    }).toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                //// COUNTRY DROPDOWN
                                : SizedBox(
                                    height: 60,
                                    child: SlideInLeft(
                                      child: FormBuilderDropdown<Country>(
                                        initialValue: null,
                                        validator:
                                            FormBuilderValidators.required(
                                                errorText:
                                                    "This field is required"),
                                        items: state.countries
                                            .map<DropdownMenuItem<Country>>(
                                                (Country country) {
                                          return DropdownMenuItem<Country>(
                                              value: country,
                                              child: FittedBox(
                                                  child:
                                                      Text(country.name!)));
                                        }).toList(),
                                        name: 'country',
                                        decoration: normalTextFieldStyle(
                                            "Country*", "Country"),
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
                    const SizedBox(height: 16,),
                      SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: FadeInUp(
                        child: ElevatedButton(
                            style:
                                mainBtnStyle(primary, Colors.transparent, second),
                            onPressed: () {
                              if (formKey.currentState!.saveAndValidate()) {
                                Country country = selectedCountry ??= Country(
                                    id: 175, name: 'Philippines', code: 'PH');
                                Address address = Address(
                                    barangay: null,
                                    id: null,
                                    addressCategory: null,
                                    addressClass: null,
                                    cityMunicipality: selectedMunicipality,
                                    country: country);
                                if (selectedCategoty != null) {
                                  selectedAgency = Agency(
                                      id: selectedAgency?.id,
                                      name: selectedAgency!.name,
                                      category: selectedCategoty,
                                      privateEntity: isPrivate);
                                }
                                VoluntaryWork work = VoluntaryWork(
                                  ////address
                                  address: address,
                                  //// agency
                                  agency: selectedAgency,
                                  ////
                                  position: selectedPosition,
                                  ////total hours
                                  totalHours: double.parse(
                                      formKey.currentState!.value["total_hours"]),
                                  ////to date
                                  toDate: toDateController.text.isEmpty ||
                                          toDateController.text.toUpperCase() ==
                                              "PRESENT"
                                      ? null
                                      : DateTime.parse(toDateController.text),
                                  ////from date
                                  fromDate:
                                      DateTime.parse(fromDateController.text),
                                );
                                final progress = ProgressHUD.of(context);
                                progress!.showWithText("Loading...");
                                context.read<VoluntaryWorkBloc>().add(
                                    AddVoluntaryWork(
                                        profileId: widget.profileId,
                                        token: widget.token,
                                        work: work));
                              }
                            },
                            child: const Text(submit)),
                      ),
                    )
                  ],
                )),
          );
        }
        return const Placeholder();
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
          .read<VoluntaryWorkBloc>()
          .add(ShowErrorState(message: e.toString()));
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
      });
    } catch (e) {
      context
          .read<VoluntaryWorkBloc>()
          .add(ShowErrorState(message: e.toString()));
    }
  }
}
