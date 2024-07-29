import 'package:animate_do/animate_do.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:unit2/model/location/city.dart';
import 'package:unit2/model/profile/eligibility.dart';
import 'package:unit2/model/utils/eligibility.dart';
import 'package:unit2/utils/global_context.dart';
import 'package:unit2/utils/location_utilities.dart';
import '../../../../bloc/profile/eligibility/eligibility_bloc.dart';
import '../../../../model/location/country.dart';
import '../../../../model/location/region.dart';
import '../../../../model/location/provinces.dart';
import '../../../../theme-data.dart/btn-style.dart';
import '../../../../theme-data.dart/colors.dart';
import '../../../../theme-data.dart/form-style.dart';
import '../../../../utils/global.dart';
import '../../../../utils/text_container.dart';

class EditEligibilityScreen extends StatefulWidget {
  final EligibityCert eligibityCert;
  final int profileId;
  final String token;
  const EditEligibilityScreen(
      {super.key,
      required this.eligibityCert,
      required this.profileId,
      required this.token});

  @override
  State<EditEligibilityScreen> createState() => _EditEligibilityScreenState();
}

class _EditEligibilityScreenState extends State<EditEligibilityScreen> {
  final formKey = GlobalKey<FormBuilderState>();
  bool? overseas;
  List<Province>? provinces;
  List<CityMunicipality>? citymuns;
  List<Region>? regions;
  DateFormat dteFormat2 = DateFormat.yMMMMd('en_US');
  Region? selectedRegion;
  Province? selectedProvince;
  CityMunicipality? selectedMunicipality;
  Country? selectedCountry;
  Eligibility? selectedEligibility;
  bool provinceCall = false;
  bool cityCall = false;
  String? token;
  String? profileId;
  String? rating;
  String? license;
  final examDateController = TextEditingController();
  final validityDateController = TextEditingController();

  @override
  void dispose() {
    examDateController.dispose();
    validityDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<EligibilityBloc>(context);
    return BlocBuilder<EligibilityBloc, EligibilityState>(
      buildWhen: (previous, current) {
        return false;
      },
      builder: (context, state) {
        //EDIT ELIGIBILITY STATE
        if (state is EditEligibilityState) {
          examDateController.text = state.eligibityCert.examDate == null
              ? ''
              : state.eligibityCert.examDate.toString();
          validityDateController.text = state.eligibityCert.validityDate == null
              ? ''
              : state.eligibityCert.validityDate.toString();
          DateTime? examDate = DateTime.tryParse(examDateController.text);
          DateTime? expireDate = DateTime.tryParse(validityDateController.text);
          provinces = state.provinces;
          citymuns = state.cities;
          regions = state.regions;
          overseas = state.isOverseas;
          selectedRegion = state.currentRegion;
          selectedProvince = state.currentProvince;
          selectedMunicipality = state.currentCity;
          selectedEligibility = state.currentEligibility;
          rating = state.eligibityCert.rating?.toString();
          license = state.eligibityCert.licenseNumber;
          selectedCountry = state.selectedCountry;
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 28),
              child: FormBuilder(
                key: formKey,
                child: ListView(children: [
                  const SizedBox(
                    height: 24,
                  ),
                  ////ELIGIBILITIES DROPDOWN
                  SlideInLeft(
                    child: DropdownButtonFormField<Eligibility>(
                        validator: (value) => value == null ? 'required' : null,
                        isExpanded: true,
                        onChanged: (Eligibility? eligibility) {
                          selectedEligibility = eligibility;
                        },
                        value: selectedEligibility,
                        items: state.eligibilities
                            .map<DropdownMenuItem<Eligibility>>(
                                (Eligibility eligibility) {
                          return DropdownMenuItem<Eligibility>(
                              value: eligibility, child: Text(eligibility.title));
                        }).toList(),
                        decoration: normalTextFieldStyle("Eligibility", "")),
                  ),
                  const SizedBox(
                    height: 12,
                  ),

                  SlideInLeft(
                                     delay: const Duration(milliseconds: 150),
                    child: SizedBox(
                      width: screenWidth,
                      child: Row(
                        children: [
                          ////LICENSE NUMBER
                          Flexible(
                            flex: 1,
                            child: FormBuilderTextField(
                              onChanged: (value) {
                                license = value;
                              },
                              name: 'license_number',
                              initialValue: license,
                              decoration: normalTextFieldStyle(
                                  "license number", "license number"),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          // //RATING
                          Flexible(
                            flex: 1,
                            child: FormBuilderTextField(
                              validator: FormBuilderValidators.numeric(
                                  errorText: "Enter a number"),
                              keyboardType:
                                  const TextInputType.numberWithOptions(),
                              onChanged: (value) {
                                rating = value;
                              },
                              name: 'rating',
                              initialValue:
                                  rating == null ? 'N/A' : rating.toString(),
                              decoration:
                                  normalTextFieldStyle('rating', 'rating'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SlideInLeft(
                                     delay: const Duration(milliseconds: 170),
                    child: SizedBox(
                      width: screenWidth,
                      child: StatefulBuilder(builder: (context, setState) {
                        return Row(
                          children: [
                            // //EXAM DATE
                            Flexible(
                                flex: 1,
                                child: DateTimePicker(
                                  use24HourFormat: false,
                                  controller: examDateController,
                                  firstDate: DateTime(1990),
                                  lastDate: DateTime(2100),
                                  decoration:
                                      normalTextFieldStyle("Exam date", "")
                                          .copyWith(
                                              prefixIcon: const Icon(
                                    Icons.date_range,
                                    color: Colors.black87,
                                  )),
                                  initialDate: expireDate == null
                                      ? DateTime.now()
                                      : expireDate!
                                          .subtract(const Duration(days: 1)),
                                  selectableDayPredicate: (date) {
                                    if (expireDate != null &&
                                        expireDate!.microsecondsSinceEpoch <=
                                            date.microsecondsSinceEpoch) {
                                      return false;
                                    }
                                    return true;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      examDate = DateTime.parse(value);
                                    });
                                  },
                                )),
                    
                            const SizedBox(
                              width: 12,
                            ),
                            ////VALIDITY DATE
                            Flexible(
                              flex: 1,
                              child: DateTimePicker(
                                use24HourFormat: false,
                                controller: validityDateController,
                                firstDate: DateTime(1970),
                                lastDate: DateTime(2100),
                                decoration:
                                    normalTextFieldStyle("validity date", "")
                                        .copyWith(
                                            prefixIcon: const Icon(
                                  Icons.date_range,
                                  color: Colors.black87,
                                )),
                                selectableDayPredicate: (date) {
                                  if (examDate != null &&
                                      examDate!.microsecondsSinceEpoch >=
                                          date.microsecondsSinceEpoch) {
                                    return false;
                                  }
                                  return true;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    expireDate = DateTime.parse(value);
                                  });
                                },
                                initialDate: examDate == null
                                    ? DateTime.now()
                                    : examDate!.add(const Duration(days: 1)),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SlideInLeft(
                                   delay: const Duration(milliseconds: 170),
                    child: Text(
                      "Placement of Examination/Confinement",
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(fontSize: blockSizeVertical * 2),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  //OVERSEAS ADDRESS SWITCH
                  StatefulBuilder(builder: (context, StateSetter setState) {
                    return Column(
                      children: [
                        SlideInLeft(
                                                             delay: const Duration(milliseconds: 190),
                          child: FormBuilderSwitch(
                            initialValue: overseas,
                            activeColor: second,
                            onChanged: (value) {
                              setState(() {
                                overseas = value;
                              });
                            },
                            decoration: normalTextFieldStyle("", ''),
                            name: 'overseas',
                            title: const Text("Overseas Address?"),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        //COUNTRY DROPDOWN
                        SizedBox(
                            child: overseas == true
                                ? SlideInLeft(
                                  child: FormBuilderDropdown<Country>(
                                      validator: (value) =>
                                          value == null ? 'required' : null,
                                      initialValue: selectedCountry!.id == 175
                                          ? null
                                          : selectedCountry,
                                      items: state.countries
                                          .map<DropdownMenuItem<Country>>(
                                              (Country country) {
                                        return DropdownMenuItem<Country>(
                                            value: country,
                                            child: FittedBox(
                                                child: Text(country.name!)));
                                      }).toList(),
                                      name: 'country',
                                      decoration: normalTextFieldStyle(
                                          "Country*", "Country"),
                                      onChanged: (Country? value) {
                                        selectedCountry = value;
                                      },
                                    ),
                                )
                                : Column(
                                    children: [
                                      ////REGION DROPDOWN
                                      SlideInLeft(
                                                   delay: const Duration(milliseconds: 210),
                                        child: DropdownButtonFormField<Region?>(
                                          validator: (value) =>
                                              value == null ? 'required' : null,
                                          isExpanded: true,
                                          onChanged: (Region? region) async {
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
                                              bloc.add(CallErrorState());
                                            }
                                                  
                                            setState(() {
                                                                      selectedProvince = provinces![0];
                                            });
                                            try {
                                              citymuns = await LocationUtils
                                                  .instance
                                                  .getCities(
                                                      selectedProvince:
                                                          selectedProvince!);
                                            } catch (e) {
                                              NavigationService
                                                  .navigatorKey.currentContext
                                                  ?.read<EligibilityBloc>()
                                                  .add(CallErrorState());
                                            }
                                                                            
                                            setState(() {
                                         selectedMunicipality = citymuns![0];
                                            });
                                          },
                                          value: selectedRegion,
                                          decoration: normalTextFieldStyle(
                                              "Region*", "Region"),
                                          items: regions == null
                                              ? []
                                              : regions!
                                                  .map<DropdownMenuItem<Region>>(
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
                                      ////PROVINCE DROPDOWN
                                      SizedBox(
                                        height: 60,
                                        child: SlideInLeft(
                                                                      delay: const Duration(milliseconds: 210),
                                          child: DropdownButtonFormField<
                                                  Province?>(
                                              validator: (value) => value == null
                                                  ? 'required'
                                                  : null,
                                              isExpanded: true,
                                              value: selectedProvince,
                                              onChanged:
                                                  (Province? province) async {
                                                setState(() {
                                                      selectedProvince = province;
                                                });
                                                                              
                                                try {
                                                  citymuns = await LocationUtils
                                                      .instance
                                                      .getCities(
                                                          selectedProvince:
                                                              selectedProvince!);
                                                } catch (e) {
                                                  bloc.add(CallErrorState());
                                                }
                                                                              
                                                setState(() {
                                             selectedMunicipality =
                                                    citymuns![0];
                                                });
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
                                                  "Province*", "Province")),
                                        ),
                                      ),

                                      //// City municipality
                                      SizedBox(
                                        height: 60,
                                        child: SlideInLeft(
                                                                      delay: const Duration(milliseconds: 230),
                                          child: DropdownButtonFormField<
                                              CityMunicipality>(
                                            validator: (value) =>
                                                value == null ? 'required' : null,
                                            isExpanded: true,
                                            onChanged: (CityMunicipality? city) {
                                              selectedMunicipality = city;
                                            },
                                            decoration: normalTextFieldStyle(
                                                "Municipality*", "Municipality"),
                                            value: selectedMunicipality,
                                            items: citymuns == null
                                                ? []
                                                : citymuns!.map<
                                                        DropdownMenuItem<
                                                            CityMunicipality>>(
                                                    (CityMunicipality c) {
                                                    return DropdownMenuItem(
                                                        value: c,
                                                        child:
                                                            Text(c.description!));
                                                  }).toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                      ],
                    );
                  }),
                  const SizedBox(
                    height: 18,
                  ),
                  SizedBox(
                    width: screenWidth,
                    height: 60,
                    child: FadeInUp(
                      child: ElevatedButton(
                          style:
                              mainBtnStyle(primary, Colors.transparent, second),
                          onPressed: () {
                            ExamAddress examAddress;
                            ////rating
                            double? rate =
                                rating == null ? null : double.tryParse(rating!);
                            ////license
                            String? newLicense = license;
                            ////city municipality
                            CityMunicipality? cityMunicipality =
                                selectedMunicipality;
                            ////exam date
                            DateTime? examDate = examDateController.text.isEmpty
                                ? null
                                : DateTime.parse(examDateController.text);
                            // // validity date
                            DateTime? validityDate =
                                validityDateController.text.isEmpty
                                    ? null
                                    : DateTime.parse(validityDateController.text);
                            //// exam address
                            if (overseas!) {
                              examAddress = ExamAddress(
                                  barangay: null,
                                  id: state.eligibityCert.examAddress?.id,
                                  addressCategory: state
                                      .eligibityCert.examAddress?.addressCategory,
                                  examAddressClass: state.eligibityCert
                                      .examAddress?.examAddressClass,
                                  country: selectedCountry,
                                  cityMunicipality: null);
                            } else {
                              examAddress = ExamAddress(
                                  barangay:
                                      state.eligibityCert.examAddress?.barangay,
                                  id: state.eligibityCert.examAddress?.id,
                                  addressCategory: state
                                      .eligibityCert.examAddress?.addressCategory,
                                  examAddressClass: state.eligibityCert
                                      .examAddress?.examAddressClass,
                                  country: Country(
                                      id: 175, name: 'Philippines', code: 'PH'),
                                  cityMunicipality: cityMunicipality);
                            }
                      
                            EligibityCert eligibityCert = EligibityCert(
                                id: state.eligibityCert.id,
                                rating: rate,
                                examDate: examDate,
                                attachments: null,
                                eligibility: selectedEligibility,
                                examAddress: examAddress,
                                validityDate: validityDate,
                                licenseNumber: newLicense,
                                overseas: overseas);
                            if (formKey.currentState!.saveAndValidate()) {
                              final progress = ProgressHUD.of(context);
                              progress!.showWithText("Loading...");
                              context.read<EligibilityBloc>().add(
                                  UpdateEligibility(
                                      eligibityCert: eligibityCert,
                                      oldEligibility:
                                          state.eligibityCert.eligibility!.id,
                                      profileId: widget.profileId.toString(),
                                      token: widget.token));
                            }
                          },
                          child: const Text(submit)),
                    ),
                  ),
                ]),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
