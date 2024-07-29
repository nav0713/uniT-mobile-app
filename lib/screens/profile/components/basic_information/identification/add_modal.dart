import 'package:animate_do/animate_do.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
import 'package:searchfield/searchfield.dart';
import 'package:unit2/bloc/profile/primary_information/identification/identification_bloc.dart';
import 'package:unit2/model/utils/industry_class.dart';
import 'package:unit2/theme-data.dart/btn-style.dart';
import 'package:unit2/utils/profile_utilities.dart';
import 'package:unit2/utils/text_container.dart';
import '../../../../../model/location/city.dart';
import '../../../../../model/location/country.dart';
import '../../../../../model/location/provinces.dart';
import '../../../../../model/location/region.dart';
import '../../../../../model/profile/basic_information/identification_information.dart';
import '../../../../../model/utils/agency.dart';
import '../../../../../model/utils/category.dart';
import '../../../../../theme-data.dart/box_shadow.dart';
import '../../../../../theme-data.dart/colors.dart';
import '../../../../../theme-data.dart/form-style.dart';
import '../../../../../utils/global.dart';
import '../../../../../utils/global_context.dart';
import '../../../../../utils/location_utilities.dart';
import '../../../shared/add_for_empty_search.dart';

class AddIdentificationScreen extends StatefulWidget {
  final int profileId;
  final String token;
  const AddIdentificationScreen(
      {super.key, required this.profileId, required this.token});

  @override
  State<AddIdentificationScreen> createState() =>
      _AddIdentificationScreenState();
}

class _AddIdentificationScreenState extends State<AddIdentificationScreen> {
  final addAgencyController = TextEditingController();
  final dateIssuedController = TextEditingController();
  final expirationController = TextEditingController();
  final agencyFocusNode = FocusNode();
  final agencyCategoryFocusNode = FocusNode();
    bool showAgencySearchField = true;
  bool showAgency = false;
  bool showIsPrivateRadio = false;
  bool asPdfReference = false;
  bool isPrivate = false;
  bool overseas = false;
  bool provinceCall = false;
  bool cityCall = false;
  bool otherAgency = false;
  ////selected
  Category? selectedAgencyCategory;
  Agency? selectedAgency;
  Category? selectedCategoty;
  Region? selectedRegion;
  Province? selectedProvince;
  CityMunicipality? selectedMunicipality;
  Country? selectedCountry;
  List<Province>? provinces;
  List<CityMunicipality>? citymuns;
  DateTime? issuedDate;
  DateTime? expirationDate;
  final formKey = GlobalKey<FormBuilderState>();
  List<Agency>? requiredAgency = [
    Agency(
        id: 173,
        name: "GOVERNMENT SERVICE INSURANCE SYSTEM (GSIS)",
        category: Category(
            id: 16,
            name: "Government-Owned and Controlled Corporations (GOCC)",
            industryClass: IndustryClass(
                description: null, name: "Public Governance", id: 16)),
        privateEntity: false),
    Agency(
        id: 2,
        name: "SOCIAL SECURITY SYSTEM (SSS)",
        category: Category(
            id: 202,
            name: "Government-Owned and Controlled Corporations (GOCC)",
            industryClass: IndustryClass(
                id: 16, name: "Public Governance", description: null)),
        privateEntity: false),
    Agency(
        id: 3,
        name: "HOME DEVELOPMENT MUTUAL FUND (PAG-IBIG FUND)",
        category: Category(
            id: 202,
            name: "Government-Owned and Controlled Corporations (GOCC)",
            industryClass: IndustryClass(
                name: "Public Governance", id: 16, description: null)),
        privateEntity: false),
    Agency(
        id: 4,
        name: "BUREAU OF INTERNAL REVENUE (BIR)",
        category: Category(
          id: 201,
          name: "National Government Agency",
          industryClass: IndustryClass(
              id: 16, name: "Public Governance", description: null),
        ),
        privateEntity: false),
    Agency(
        id: 165,
        name: "PHILIPPINE HEALTH INSURANCE CORPORATION (PHILHEALTH)",
        category: Category(
            id: 202,
            name: "Government-Owned and Controlled Corporations (GOCC)",
            industryClass: IndustryClass(
                id: 16, name: "Public Governance", description: null)),
        privateEntity: false),
    Agency(id: 0, name: "OTHERS"),
  ];
  List<int> requiredIds = [173, 2, 3, 4, 165];
  @override
  void dispose() {
    dateIssuedController.dispose();
    addAgencyController.dispose();
    expirationController.dispose();
    agencyFocusNode.dispose();
    agencyCategoryFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<IdentificationBloc>(context);
    return BlocBuilder<IdentificationBloc, IdentificationState>(
      buildWhen: (previous, current) {
        return false;
      },
      builder: (context, state) {
        if (state is IdentificationAddingState) {
          for (var agency in state.addedAgencies) {
            if (requiredIds.contains(agency.id)) {
              Agency? newAgency = requiredAgency
                  ?.firstWhere((element) => element.id == agency.id);
              if (newAgency != null) {
                requiredAgency!.remove(newAgency);
              }
            }
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: FormBuilder(
                key: formKey,
                child: SizedBox(
                  height: screenHeight * 90,
                  child: ListView(
                    children: [
                      StatefulBuilder(builder: (context, setState) {
                        return Column(
                          children: [
                            SlideInLeft(
                              child: FormBuilderDropdown<Agency>(
                                validator: FormBuilderValidators.required(
                                    errorText: "This field is required"),
                                isExpanded: true,
                                decoration: normalTextFieldStyle(
                                    "Select Agency", "Select Agency"),
                                name: "requiredAgency",
                                items: requiredAgency!
                                    .map<DropdownMenuItem<Agency>>(
                                        (Agency agency) {
                                  return DropdownMenuItem(
                                    value: agency,
                                    child: Container(
                                        width: double.infinity,
                                        decoration:
                                            box1().copyWith(boxShadow: []),
                                        child: Text(
                                          agency.name!,
                                          maxLines: 3,
                                        )),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  selectedAgency = value;
                              
                                  if (value!.id == 0) {
                                    setState(() {
                                      otherAgency = true;
                                    });
                                  } else {
                                    isPrivate = value.privateEntity!;
                                    setState(() {
                                      otherAgency = false;
                                    });
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: otherAgency ? 12 : 0,
                            ),
                            ////Other agency
                            SizedBox(
                              child: otherAgency
                                  ?              ////AGENCY
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
                                             false;
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
                              : const SizedBox()
                                                 
                        ),
                        FadeIn(
                          child: SizedBox(
                            child: !showAgencySearchField
                                ? TextFormField(
                                    initialValue: selectedAgency!.name,
                                    decoration:
                                        normalTextFieldStyle("", "").copyWith(
                                            labelText: "Agency",
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
                                  )
                                : const SizedBox(),
                          ),
                        ),
                        SizedBox(
                          height: showAgency ? 12 : 0,
                        ),
                        ////SHOW CATEGORY AGENCY
                        SlideInLeft(
                          child: SizedBox(
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
                                        selectedAgencyCategory =
                                            agencyCategory.item;
                                        agencyCategoryFocusNode.unfocus();
                                        selectedAgency = Agency(
                                            id: null,
                                            name: selectedAgency!.name,
                                            category: selectedAgencyCategory,
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
                        ),

                        ////PRVIATE SECTOR
                        SlideInLeft(
                          child: SizedBox(
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
                                   
                                          selectedAgency = Agency(
                                              id: null,
                                              name: selectedAgency!.name,
                                              category: selectedAgencyCategory,
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
                        ),
                      

                            const SizedBox(
                    height: 12,
                  ),
           
            
                       
                      ],
                    );
                  })
                                  : const SizedBox(),
                            ),
                          ],
                        );
                      }),
                      SizedBox(
                        height: otherAgency ? 8 : 0,
                      ),

                      const SizedBox(
                        height: 8,
                      ),
                      //// Identification numner
                      SlideInLeft(
                        delay: const Duration(milliseconds: 100),
                        child: FormBuilderTextField(
                          validator: FormBuilderValidators.required(
                              errorText: "This field is required"),
                          name: "identification_number",
                          decoration:
                              normalTextFieldStyle("Identification Number *", ""),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      StatefulBuilder(builder: (context, setState) {
                        return SlideInLeft(
                                            delay: const Duration(milliseconds: 120),
                          child: Row(
                            children: [
                              //// Date Issued
                              Flexible(
                                  flex: 1,
                                  child: DateTimePicker(
                                    cancelText: "Clear",
                                    type: DateTimePickerType.date,
                                    controller: dateIssuedController,
                                    use24HourFormat: false,
                                    icon: const Icon(Icons.date_range),
                                    selectableDayPredicate: (date) {
                                      if (expirationDate != null &&
                                          expirationDate!
                                                  .microsecondsSinceEpoch <=
                                              date.microsecondsSinceEpoch) {
                                        return false;
                                      }
                                      return true;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        issuedDate = DateTime.parse(value);
                                      });
                                    },
                                    initialDate: expirationDate == null
                                        ? DateTime.now()
                                        : expirationDate!
                                            .subtract(const Duration(days: 1)),
                                    firstDate: DateTime(1990),
                                    lastDate: DateTime(2100),
                                    timeHintText: "Date Issued",
                                    decoration: normalTextFieldStyle(
                                            "Date Issued *", "Date Issued *")
                                        .copyWith(
                                            prefixIcon: const Icon(
                                      Icons.date_range,
                                      color: Colors.black87,
                                    )),
                                  )),
                              const SizedBox(
                                width: 8,
                              ),
                              //// Expiration Date
                              Flexible(
                                  flex: 1,
                                  child: DateTimePicker(
                                    type: DateTimePickerType.date,
                                    controller: expirationController,
                                    use24HourFormat: false,
                                    icon: const Icon(Icons.date_range),
                                    firstDate: DateTime(1990),
                                    lastDate: DateTime(2100),
                                    selectableDayPredicate: (date) {
                                      if (issuedDate != null &&
                                          issuedDate!.microsecondsSinceEpoch >=
                                              date.microsecondsSinceEpoch) {
                                        return false;
                                      }
                                      return true;
                                    },
                                    timeHintText: "Expiration date",
                                    decoration: normalTextFieldStyle(
                                            "Expiration Date *",
                                            "Expiration Date *")
                                        .copyWith(
                                            prefixIcon: const Icon(
                                      Icons.date_range,
                                      color: Colors.black87,
                                    )),
                                    initialDate: issuedDate == null
                                        ? DateTime.now()
                                        : issuedDate!
                                            .add(const Duration(days: 1)),
                                    onChanged: (value) {
                                      setState(() {
                                        expirationDate = DateTime.parse(value);
                                      });
                                    },
                                  )),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(
                        height: 12,
                      ),
                      //// as pdf reference
                      StatefulBuilder(builder: (context, setState) {
                        return SlideInLeft(
                                                        delay: const Duration(milliseconds: 140),
                          child: FormBuilderSwitch(
                            initialValue: asPdfReference,
                            activeColor: second,
                            onChanged: (value) {
                              setState(() {
                                asPdfReference = value!;
                              });
                            },
                            decoration:
                                normalTextFieldStyle("As PDF Reference?", ''),
                            name: 'pdf_reference',
                            title: Text(asPdfReference ? "YES" : "NO"),
                          ),
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
                                                            delay: const Duration(milliseconds: 160),
                              child: FormBuilderSwitch(
                                initialValue: overseas,
                                activeColor: second,
                                onChanged: (value) {
                                  setState(() {
                                    overseas = value!;
                                  });
                                },
                                decoration:
                                    normalTextFieldStyle("Overseas Address?", ''),
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
                                                                        delay: const Duration(milliseconds: 180),
                                          child: DropdownButtonFormField<Region?>(
                                            isExpanded: true,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            validator:
                                                FormBuilderValidators.required(
                                                    errorText:
                                                        "This field is required"),
                                            onChanged: (Region? region) async {
                                              if (selectedRegion != region) {
                                                setState(() {
                                            selectedRegion = region;
                                                });
                                                                               
                                                try {
                                                  provinces = await LocationUtils
                                                      .instance
                                                      .getProvinces(
                                                          selectedRegion:
                                                              selectedRegion!);
                                                                               
                                                  setState(() {
                                                    selectedProvince =
                                                      provinces![0];
                                                  });
                                                  try {
                                                    citymuns = await LocationUtils
                                                        .instance
                                                        .getCities(
                                                            selectedProvince:
                                                                selectedProvince!);
                                            
                                                    setState(() {
                                                      selectedMunicipality =
                                                        citymuns![0];
                                                    });
                                                  } catch (e) {
                                                    NavigationService.navigatorKey
                                                        .currentContext
                                                        ?.read<
                                                            IdentificationBloc>()
                                                        .add(ShowErrorState(
                                                            message:
                                                                e.toString()));
                                                  }
                                                } catch (e) {
                                          
                                                 bloc
                                                      .add(ShowErrorState(
                                                          message: e.toString()));
                                                }
                                              }
                                            },
                                            value: selectedRegion,
                                            decoration: normalTextFieldStyle(
                                                "Region*", "Region"),
                                            items: state.regions
                                                .map<DropdownMenuItem<Region>>(
                                                    (Region region) {
                                              return DropdownMenuItem<Region>(
                                                  value: region,
                                                  child:
                                                      Text(region.description!));
                                            }).toList(),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        //// PROVINCE DROPDOWN
                                        SizedBox(
                                          height: 60,
                                          child: SlideInLeft(
                                                                          delay: const Duration(milliseconds: 200),
                                            child: DropdownButtonFormField<
                                                    Province?>(
                                                autovalidateMode: AutovalidateMode
                                                    .onUserInteraction,
                                                isExpanded: true,
                                                value: selectedProvince,
                                                onChanged:
                                                    (Province? province) async {
                                                  if (selectedProvince !=
                                                      province) {
                                                    setState(() {
                                                      selectedProvince = province;
                                                    });
                                            
                                                    try {
                                                      citymuns = await LocationUtils
                                                          .instance
                                                          .getCities(
                                                              selectedProvince:
                                                                  selectedProvince!);
                                                   
                                                      setState(() {
                                                      selectedMunicipality =
                                                          citymuns![0];
                                                      });
                                                    } catch (e) {
                                                     bloc
                                                          .add(ShowErrorState(
                                                              message:
                                                                  e.toString()));
                                                    }
                                                  }
                                                },
                                                validator: FormBuilderValidators
                                                    .required(
                                                        errorText:
                                                            "This field is required"),
                                                items: provinces == null
                                                    ? []
                                                    : provinces!.map<
                                                            DropdownMenuItem<
                                                                Province>>(
                                                        (Province province) {
                                                        return DropdownMenuItem(
                                                            value: province,
                                                            child: FittedBox(
                                                              child: Text(province
                                                                  .description!),
                                                            ));
                                                      }).toList(),
                                                decoration: normalTextFieldStyle(
                                                    "Province*", "Province")),
                                          ),
                                        ),
                                        ////CITY MUNICIPALITY
                                        SizedBox(
                                          height: 60,
                                          child: SlideInLeft(
                                                                          delay: const Duration(milliseconds: 220),
                                            child: DropdownButtonFormField<
                                                CityMunicipality>(
                                              validator:
                                                  FormBuilderValidators.required(
                                                      errorText:
                                                          "This field is required"),
                                              isExpanded: true,
                                              onChanged:
                                                  (CityMunicipality? city) {
                                                if (selectedMunicipality !=
                                                    city) {
                                                  selectedMunicipality = city;
                                                }
                                              },
                                              decoration: normalTextFieldStyle(
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
                                                          child: Text(
                                                              c.description!));
                                                    }).toList(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  //// COUNTRY DROPDOWN
                                  : SizedBox(
                                      height: 60,
                                      child: SlideInLeft(
                                        child: DropdownButtonFormField<Country>(
                                          isExpanded: true,
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
                                                    child: Text(country.name!)));
                                          }).toList(),
                                          value: selectedCountry,
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
                      const SizedBox(
                        height: 8,
                      ),
                      SlideInUp(
                                                      delay: const Duration(milliseconds: 240),
                        child: SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                              style: mainBtnStyle(
                                  primary, Colors.transparent, second),
                              onPressed: () {
                                if (formKey.currentState!.saveAndValidate()) {
                                  IssuedAt issuedAt;
                                  if (overseas) {
                                    issuedAt = IssuedAt(
                                        id: null,
                                        barangay: null,
                                        addressCategory: null,
                                        issuedAtClass: null,
                                        cityMunicipality: null,
                                        country: selectedCountry);
                                  } else {
                                    issuedAt = IssuedAt(
                                        id: null,
                                        barangay: null,
                                        addressCategory: null,
                                        issuedAtClass: null,
                                        cityMunicipality: overseas
                                            ? null
                                            : selectedMunicipality,
                                        country: Country(
                                            id: 175,
                                            name: 'Philippines',
                                            code: 'PH'));
                                  }
                                  if (selectedCategoty != null) {
                                    selectedAgency = Agency(
                                        id: selectedAgency?.id,
                                        name: selectedAgency!.name,
                                        category: selectedCategoty,
                                        privateEntity: isPrivate);
                                  }
                                  Identification identification = Identification(
                                      id: null,
                                      agency: selectedAgency,
                                      issuedAt: issuedAt,
                                      asPdfReference: asPdfReference,
                                      identificationNumber: formKey.currentState!
                                          .value['identification_number'],
                                      dateIssued:
                                          dateIssuedController.text.isEmpty
                                              ? null
                                              : DateTime.parse(
                                                  dateIssuedController.text),
                                      expirationDate:
                                          expirationController.text.isEmpty
                                              ? null
                                              : DateTime.tryParse(
                                                  expirationController.text));
                                  final progress = ProgressHUD.of(context);
                                  progress!.showWithText("Loading...");
                                  context.read<IdentificationBloc>().add(
                                      AddIdentification(
                                          identification: identification,
                                          profileId: widget.profileId,
                                          token: widget.token));
                                }
                              },
                              child: const Text(submit)),
                        ),
                      ),
                    ],
                  ),
                )),
          );
        }
        return Container();
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
          .read<IdentificationBloc>()
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
          .read<IdentificationBloc>()
          .add(ShowErrorState(message: e.toString()));
    }
  }
}
