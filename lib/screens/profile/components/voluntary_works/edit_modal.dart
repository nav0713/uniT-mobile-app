import 'package:animate_do/animate_do.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:searchfield/searchfield.dart';
import 'package:unit2/bloc/profile/voluntary_works/voluntary_work_bloc.dart';
import 'package:unit2/utils/global.dart';
import 'package:unit2/utils/global_context.dart';
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

class EditVoluntaryWorkScreen extends StatefulWidget {
  final int profileId;
  final String token;
  const EditVoluntaryWorkScreen(
      {super.key, required this.profileId, required this.token});

  @override
  State<EditVoluntaryWorkScreen> createState() =>
      _EditVoluntaryWorkScreenState();
}

class _EditVoluntaryWorkScreenState extends State<EditVoluntaryWorkScreen> {
  final formKey = GlobalKey<FormBuilderState>();
  ////controllers
  final addPositionController = TextEditingController();
  final addAgencyController = TextEditingController();
  final toDateController = TextEditingController();
  final fromDateController = TextEditingController();
  final positionController = TextEditingController();
  final agencyController = TextEditingController();
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
  DateTime? from;
  DateTime? to;
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
  @override
  void dispose() {
    addPositionController.dispose();
    addAgencyController.dispose();
    toDateController.dispose();
    fromDateController.dispose();
    positionController.dispose();
    agencyController.dispose();
    positionFocusNode.dispose();
    agencyFocusNode.dispose();
    agencyCategoryFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoluntaryWorkBloc, VoluntaryWorkState>(
      buildWhen: (previous, current) {
        return false;
      },
      builder: (context, state) {
        if (state is EditVoluntaryWorks) {
          ////config
          String? todate = state.work.toDate?.toString();
          provinces = state.provinces;
          citymuns = state.cities;
          positionController.text = state.currentPosition.title!;
          agencyController.text = state.currentAgency.name!;
          fromDateController.text = state.work.fromDate.toString();
          toDateController.text = todate ??= "";
          currentlyInvolved = todate.isEmpty || todate == "null" ? true : false;
          overseas = state.overseas;
          selectedCountry = state.currentCountry;
          selectedPosition = state.currentPosition;
          selectedAgency = state.currentAgency;
          selectedRegion = state.currentRegion;
          selectedProvince = state.currentProvince;
          selectedMunicipality = state.currentCity;
          from = state.work.fromDate;
          to = state.work.toDate;
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              child: FormBuilder(
                  key: formKey,
                  child: Column(
                    children: [
                      Flexible(
                        child: ListView(
                          children: [
                            ////POSITIONS
                            StatefulBuilder(builder: (context, setState) {
                              return SlideInLeft(
                                child: SearchField(
                                  inputFormatters: [UpperCaseTextFormatter()],
                                  controller: positionController,
                                  itemHeight: 70,
                                  suggestionsDecoration:
                                      searchFieldDecoration(),
                                  suggestions: state.positions
                                      .map((PositionTitle position) =>
                                          SearchFieldListItem(position.title!,
                                              item: position,
                                              child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
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
                                          PositionTitle newAgencyPosition =
                                              PositionTitle(
                                                  id: null,
                                                  title: addPositionController
                                                      .text
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
                            ////AGENCY
                            StatefulBuilder(builder: (context, setState) {
                              return Column(
                                children: [
                                  SlideInLeft(
                                    delay: const Duration(milliseconds: 150),
                                    child: SearchField(
                                        enabled: false,
                                        inputFormatters: [
                                          UpperCaseTextFormatter()
                                        ],
                                        controller: agencyController,
                                        itemHeight: 100,
                                        focusNode: agencyFocusNode,
                                        suggestions: state.agencies
                                            .map((Agency agency) =>
                                                SearchFieldListItem(
                                                    agency.name!,
                                                    item: agency,
                                                    child: ListTile(
                                                      title: Text(
                                                        agency.name!,
                                                        overflow: TextOverflow
                                                            .visible,
                                                      ),
                                                      subtitle: Text(agency
                                                                  .privateEntity ==
                                                              true
                                                          ? "Private"
                                                          : agency.privateEntity ==
                                                                  false
                                                              ? "Government"
                                                              : ""),
                                                    )))
                                            .toList(),
                                        searchInputDecoration:
                                            normalTextFieldStyle("Agency *", "")
                                                .copyWith(
                                                    filled: true,
                                                    fillColor:
                                                        Colors.grey.shade300,
                                                    suffixIcon: GestureDetector(
                                                      child: const Icon(
                                                        Icons.arrow_drop_down,
                                                      ),
                                                      onTap: () =>
                                                          agencyFocusNode
                                                              .unfocus(),
                                                    )),
                                        ////SELETECTED
                                        onSuggestionTap: (agency) {
                                          setState(() {
                                            selectedAgency = agency.item;
                                            if (selectedAgency!.privateEntity ==
                                                null) {
                                              showAgency = true;
                                              showIsPrivateRadio = true;
                                            } else {
                                              showAgency = false;
                                              showIsPrivateRadio = false;
                                            }
                                            agencyFocusNode.unfocus();
                                          });
                                        },
                                        validator: (agency) {
                                          if (agency!.isEmpty) {
                                            return "This field is required";
                                          }
                                          return null;
                                        },
                                        emptyWidget: EmptyWidget(
                                            controller: addAgencyController,
                                            onpressed: () {
                                              setState(() {
                                                Agency newAgency = Agency(
                                                    id: null,
                                                    name: addAgencyController
                                                        .text
                                                        .toUpperCase(),
                                                    category: null,
                                                    privateEntity: null);
                                                state.agencies
                                                    .insert(0, newAgency);

                                                addAgencyController.text = "";
                                                Navigator.pop(context);
                                              });
                                            },
                                            title: "Add Agency")),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SlideInLeft(
                                        delay:
                                            const Duration(milliseconds: 150),
                                        child: Text(
                                          "You cannot change agency on update mode",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        )),
                                  ),

                                  const SizedBox(
                                    height: 12,
                                  ),
                                  //// total hours
                                  SlideInLeft(
                                    delay: const Duration(milliseconds: 170),
                                    child: FormBuilderTextField(
                                      initialValue:
                                          state.work.totalHours.toString(),
                                      validator: FormBuilderValidators.required(
                                          errorText: "This Field is required"),
                                      name: "total_hours",
                                      keyboardType: TextInputType.number,
                                      decoration: normalTextFieldStyle(
                                          "Total Hours*", "0"),
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
                                          delay:
                                              const Duration(milliseconds: 190),
                                          child: FormBuilderSwitch(
                                            initialValue: currentlyInvolved,
                                            activeColor: second,
                                            onChanged: (value) {
                                              setState(() {
                                                currentlyInvolved = value!;
                                                print(currentlyInvolved);
                                              });
                                            },
                                            decoration: normalTextFieldStyle(
                                                "Currently Involved?",
                                                'Graduated?'),
                                            name: 'currently_involved',
                                            title: Text(currentlyInvolved
                                                ? "YES"
                                                : "NO"),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        SlideInLeft(
                                          delay:
                                              const Duration(milliseconds: 210),
                                          child: SizedBox(
                                            width: screenWidth,
                                            child: Row(
                                              children: [
                                                //// FROM DATE
                                                Flexible(
                                                    flex: 1,
                                                    child: DateTimePicker(
                                                      validator:
                                                          FormBuilderValidators
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
                                                          initialValue:
                                                              "PRESENT",
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black45),
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
                                                          firstDate:
                                                              DateTime(1990),
                                                          lastDate:
                                                              DateTime(2100),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              to = DateTime
                                                                  .parse(value);
                                                            });
                                                          },
                                                          initialDate: from ==
                                                                  null
                                                              ? DateTime.now()
                                                              : from!.add(
                                                                  const Duration(
                                                                      days: 1)),
                                                          decoration: normalTextFieldStyle(
                                                                  "To *",
                                                                  "To *")
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
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
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
                                                delay: const Duration(
                                                    milliseconds: 250),
                                                child: DropdownButtonFormField<
                                                    Region?>(
                                                  isExpanded: true,
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
                                                        provinceCall = true;
                                                      });
                                                      selectedRegion = region;
                                                      try {
                                                        provinces = await LocationUtils
                                                            .instance
                                                            .getProvinces(
                                                                selectedRegion:
                                                                    selectedRegion!);
                                                      } catch (e) {
                                                        context
                                                            .read<
                                                                VoluntaryWorkBloc>()
                                                            .add(ShowErrorState(
                                                                message: e
                                                                    .toString()));
                                                      }
                                                      selectedProvince =
                                                          provinces![0];
                                                      setState(() {
                                                        provinceCall = false;
                                                        cityCall = true;
                                                      });
                                                      try {
                                                        citymuns = await LocationUtils
                                                            .instance
                                                            .getCities(
                                                                selectedProvince:
                                                                    selectedProvince!);
                                                        selectedMunicipality =
                                                            citymuns![0];
                                                        setState(() {
                                                          cityCall = false;
                                                        });
                                                      } catch (e) {
                                                        NavigationService
                                                            .navigatorKey
                                                            .currentContext
                                                            ?.read<
                                                                VoluntaryWorkBloc>()
                                                            .add(ShowErrorState(
                                                                message: e
                                                                    .toString()));
                                                      }
                                                    }
                                                  },
                                                  value: selectedRegion,
                                                  decoration:
                                                      normalTextFieldStyle(
                                                          "Region*", "Region"),
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
                                                height: 12,
                                              ),
                                              //// PROVINCE DROPDOWN
                                              SizedBox(
                                                height: 60,
                                                child: ProgressModalHud(
                                                  inAsyncCall: provinceCall,
                                                  child: SlideInLeft(
                                                    delay: const Duration(
                                                        milliseconds: 270),
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
                                                              cityCall = true;
                                                            });
                                                            selectedProvince =
                                                                province;
                                                            try {
                                                              citymuns = await LocationUtils
                                                                  .instance
                                                                  .getCities(
                                                                      selectedProvince:
                                                                          selectedProvince!);
                                                              selectedMunicipality =
                                                                  citymuns![0];
                                                              setState(() {
                                                                cityCall =
                                                                    false;
                                                              });
                                                            } catch (e) {
                                                              context
                                                                  .read<
                                                                      VoluntaryWorkBloc>()
                                                                  .add(ShowErrorState(
                                                                      message: e
                                                                          .toString()));
                                                            }
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
                                                                    value:
                                                                        province,
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
                                                    delay: const Duration(
                                                        milliseconds: 290),
                                                    child:
                                                        DropdownButtonFormField<
                                                            CityMunicipality>(
                                                      validator:
                                                          FormBuilderValidators
                                                              .required(
                                                                  errorText:
                                                                      "This field is required"),
                                                      isExpanded: true,
                                                      onChanged:
                                                          (CityMunicipality?
                                                              city) {
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
                                                      value:
                                                          selectedMunicipality,
                                                      items: citymuns == null
                                                          ? []
                                                          : citymuns!.map<
                                                                  DropdownMenuItem<
                                                                      CityMunicipality>>(
                                                              (CityMunicipality
                                                                  c) {
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
                                              child: DropdownButtonFormField<
                                                  Country>(
                                                isExpanded: true,
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
                                                value: selectedCountry!.id == 175
                                                    ? null
                                                    : selectedCountry,
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
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: FadeInUp(
                          child: ElevatedButton(
                              style: mainBtnStyle(
                                  primary, Colors.transparent, second),
                              onPressed: () {
                                if (formKey.currentState!.saveAndValidate()) {
                                  Address address;
                                  //// if not overseas
                                  if (!overseas) {
                                    address = Address(
                                        barangay: null,
                                        id: state.work.address?.id,
                                        addressCategory:
                                            state.work.address?.addressCategory,
                                        addressClass:
                                            state.work.address?.addressClass,
                                        cityMunicipality: selectedMunicipality,
                                        country: Country(
                                            code: "PH",
                                            id: 175,
                                            name: "PHILIPPINES"));
                                  } else {
                                    ////if overseas
                                    address = Address(
                                        barangay: null,
                                        id: state.work.address?.id,
                                        addressCategory:
                                            state.work.address?.addressCategory,
                                        addressClass:
                                            state.work.address?.addressClass,
                                        cityMunicipality: null,
                                        country: selectedCountry);
                                  }
                          
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
                                    totalHours: double.parse(formKey
                                        .currentState!.value["total_hours"]),
                                    ////to date
                                    toDate: currentlyInvolved
                                        ? null
                                        : DateTime.parse(toDateController.text),
                                    ////from date
                                    fromDate:
                                        DateTime.parse(fromDateController.text),
                                  );
                          
                                  context.read<VoluntaryWorkBloc>().add(
                                      UpdateVolunataryWork(
                                          oldAgencyId: state.work.agency!.id!,
                                          oldFromDate:
                                              state.work.fromDate.toString(),
                                          oldPosId: state.work.position!.id!,
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
            ),
          );
        }
        return const Placeholder();
      },
    );
  }
}
