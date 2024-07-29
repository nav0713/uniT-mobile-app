import 'package:animate_do/animate_do.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:unit2/bloc/profile/primary_information/identification/identification_bloc.dart';
import 'package:unit2/theme-data.dart/btn-style.dart';
import 'package:unit2/utils/text_container.dart';
import '../../../../../model/location/city.dart';
import '../../../../../model/location/country.dart';
import '../../../../../model/location/provinces.dart';
import '../../../../../model/location/region.dart';
import '../../../../../model/profile/basic_information/identification_information.dart';
import '../../../../../model/utils/agency.dart';
import '../../../../../model/utils/category.dart';
import '../../../../../theme-data.dart/colors.dart';
import '../../../../../theme-data.dart/form-style.dart';
import '../../../../../utils/global.dart';
import '../../../../../utils/global_context.dart';
import '../../../../../utils/location_utilities.dart';

class EditIdentificationScreen extends StatefulWidget {
  final int profileId;
  final String token;
  const EditIdentificationScreen(
      {super.key, required this.profileId, required this.token});

  @override
  State<EditIdentificationScreen> createState() =>
      _EditIdentificationScreenState();
}

class _EditIdentificationScreenState extends State<EditIdentificationScreen> {
  final addAgencyController = TextEditingController();
  final dateIssuedController = TextEditingController();
  final expirationController = TextEditingController();
  final agencyFocusNode = FocusNode();
  final agencyCategoryFocusNode = FocusNode();
  bool asPdfReference = false;
  bool overseas = false;
  bool provinceCall = false;
  bool cityCall = false;
  bool otherAgency = false;
  ////selected
  Agency? selectedAgency;
  Category? selectedCategoty;
  Region? selectedRegion;
  Province? selectedProvince;
  CityMunicipality? selectedMunicipality;
  Country? selectedCountry;
  List<Province>? provinces;
  List<CityMunicipality>? citymuns;

  final formKey = GlobalKey<FormBuilderState>();
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
      builder: (context, state) {
        if (state is IdentificationEditingState) {
          String? issuedDate = state.identification.dateIssued.toString();
          String? expDate = state.identification.expirationDate.toString();
          provinces = state.provinces;
          citymuns = state.cities;
          selectedCountry = state.currentCountry;
          dateIssuedController.text =
              issuedDate.isEmpty || issuedDate == "null" ? "" : issuedDate;
          expirationController.text =
              expDate.isEmpty || expDate == "null" ? "" : expDate;
          selectedRegion = state.currentRegion;
          selectedProvince = state.currentProvince;
          selectedMunicipality = state.currentCity;
          overseas = state.overseas;
          asPdfReference = state.identification.asPdfReference!;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 24),
            child: FormBuilder(
                key: formKey,
                child: SizedBox(
                  height: screenHeight * 90,
                  child: ListView(
                    children: [
                      SlideInLeft(
                        child: FormBuilderTextField(
                          initialValue: state.identification.agency!.name,
                          enabled: false,
                          name: "",
                          decoration: normalTextFieldStyle("", "")
                              .copyWith(filled: true, fillColor: Colors.black12),
                        ),
                      ),
                      SizedBox(
                        height: otherAgency ? 8 : 0,
                      ),

                      const SizedBox(
                        height: 12,
                      ),
                      //// Identification numner
                      SlideInLeft(
                                                      delay: const Duration(milliseconds: 100),
                        child: FormBuilderTextField(
                          initialValue: state.identification.identificationNumber,
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
                                    controller: dateIssuedController,
                                    use24HourFormat: false,
                                    icon: const Icon(Icons.date_range),
                                    firstDate: DateTime(1990),
                                    lastDate: DateTime(2100),
                                    timeHintText: "Date Issued",
                                    decoration: normalTextFieldStyle(
                                            "Date Issued ", "Date Issued *")
                                        .copyWith(
                                            prefixIcon: const Icon(
                                      Icons.date_range,
                                      color: Colors.black87,
                                    )),
                                    onChanged: (value) {
                                      setState(() {
                                        issuedDate = value;
                                      });
                                    },
                                    selectableDayPredicate: (date) {
                                      if ((expDate != "null" &&
                                              expDate != null) &&
                                          DateTime.tryParse(expDate!)!
                                                  .microsecondsSinceEpoch <=
                                              date.microsecondsSinceEpoch) {
                                        return false;
                                      }
                                      return true;
                                    },
                                    initialDate: expDate == "null" ||
                                            expDate == null
                                        ? DateTime.now()
                                        : DateTime.tryParse(expDate!)
                                            ?.subtract(const Duration(days: 1)),
                                  )),
                          
                              const SizedBox(
                                width: 12,
                              ),
                              //// Expiration Date
                              Flexible(
                                  flex: 1,
                                  child: DateTimePicker(
                                    controller: expirationController,
                                    use24HourFormat: false,
                                    icon: const Icon(Icons.date_range),
                                    firstDate: DateTime(1990),
                                    lastDate: DateTime(2100),
                                    timeHintText: "Expiration date",
                                    onChanged: (value) {
                                      setState(() {
                                        expDate = value;
                                      });
                                    },
                                    decoration: normalTextFieldStyle(
                                            "Expiration Date", "Expiration Date")
                                        .copyWith(
                                            prefixIcon: const Icon(
                                      Icons.date_range,
                                      color: Colors.black87,
                                    )),
                                    selectableDayPredicate: (date) {
                                      if ((issuedDate != "null" &&
                                              issuedDate != null) &&
                                          DateTime.tryParse(issuedDate!)!
                                                  .microsecondsSinceEpoch >=
                                              date.microsecondsSinceEpoch) {
                                        return false;
                                      }
                                      return true;
                                    },
                                    initialDate:
                                        issuedDate == null && issuedDate == "null"
                                            ? DateTime.now()
                                            : DateTime.tryParse(issuedDate!)
                                                ?.add(const Duration(days: 1)),
                                  )),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(
                        height: 12,
                      ),
       SlideInLeft(
                                      delay: const Duration(milliseconds: 140),
         child: StatefulBuilder(builder: (context, setState) {
                          return FormBuilderSwitch(
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
                          );
                        }),
       ),

                      const Gap(13),
                      //// OVERSEAS
                      StatefulBuilder(builder: (context, setState) {
                        return Column(
                          children: [
                            SlideInLeft(
                                                            delay: const Duration(milliseconds: 140),
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
                                                                        delay: const Duration(milliseconds: 160),
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
                                                } catch (e) {
                                                  bloc.add(ShowErrorState(
                                                      message: e.toString()));
                                                }
                                          
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
                                                  NavigationService
                                                      .navigatorKey.currentContext
                                                      ?.read<IdentificationBloc>()
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
                                                                          delay: const Duration(milliseconds: 180),
                                            child: DropdownButtonFormField<
                                                    Province?>(
                                                value: selectedProvince,
                                                autovalidateMode: AutovalidateMode
                                                    .onUserInteraction,
                                                validator: (value) =>
                                                    value == null
                                                        ? 'required'
                                                        : null,
                                                isExpanded: true,
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
                                                      bloc.add(ShowErrorState(
                                                          message: e.toString()));
                                                    }
                                                  }
                                                },
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
                                                    "Province *", "Province")),
                                          ),
                                        ),
                                        ////CITY MUNICIPALITY
                                        SizedBox(
                                          height: 60,
                                          child: SlideInLeft(
                                                 delay: const Duration(milliseconds: 200),
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
                                                  "Municipality *",
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
                                          value: selectedCountry?.id == 175
                                              ? null
                                              : selectedCountry,
                                          decoration: normalTextFieldStyle(
                                              "Country *", "Country"),
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
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: SlideInLeft(
                               delay: const Duration(milliseconds: 220),
                          child: ElevatedButton(
                              style: mainBtnStyle(
                                  primary, Colors.transparent, second),
                              onPressed: () {
                                if (formKey.currentState!.saveAndValidate()) {
                                  IssuedAt? issuedAt;
                                  if (!overseas) {
                                    issuedAt = IssuedAt(
                                        id: state.identification.issuedAt!.id,
                                        barangay: null,
                                        addressCategory: state.identification
                                            .issuedAt?.addressCategory,
                                        issuedAtClass: null,
                                        cityMunicipality: selectedMunicipality,
                                        country: Country(
                                            id: 175,
                                            code: "PH",
                                            name: "PHILIPPINES"));
                                  } else {
                                    issuedAt = IssuedAt(
                                        id: state.identification.issuedAt!.id,
                                        barangay: null,
                                        addressCategory: state.identification
                                            .issuedAt?.addressCategory,
                                        issuedAtClass: null,
                                        cityMunicipality: null,
                                        country: selectedCountry);
                                  }
                          
                                  Identification identification = Identification(
                                      id: state.identification.id,
                                      agency: state.identification.agency,
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
                                      UpdateIdentifaction(
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
      NavigationService.navigatorKey.currentContext!
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
      NavigationService.navigatorKey.currentContext!
          .read<IdentificationBloc>()
          .add(ShowErrorState(message: e.toString()));
    }
  }
}
