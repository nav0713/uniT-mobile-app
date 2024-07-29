import 'package:animate_do/animate_do.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:unit2/model/profile/eligibility.dart';
import '../../../../bloc/profile/eligibility/eligibility_bloc.dart';
import '../../../../model/location/city.dart';
import '../../../../model/location/country.dart';
import '../../../../model/location/provinces.dart';
import '../../../../model/location/region.dart';
import '../../../../model/utils/eligibility.dart';
import '../../../../theme-data.dart/btn-style.dart';
import '../../../../theme-data.dart/colors.dart';
import '../../../../theme-data.dart/form-style.dart';
import '../../../../utils/global.dart';
import '../../../../utils/location_utilities.dart';
import '../../../../utils/text_container.dart';

class AddEligibilityScreen extends StatefulWidget {
  const AddEligibilityScreen(
      {super.key, required this.profileId, required this.token});
  final int profileId;
  final String token;

  @override
  State<AddEligibilityScreen> createState() => _AddEligibilityScreenState();
}

class _AddEligibilityScreenState extends State<AddEligibilityScreen> {
  final formKey = GlobalKey<FormBuilderState>();
  bool? overseas = false;
  DateFormat dteFormat2 = DateFormat.yMMMMd('en_US');
  Region? selectedRegion;
  Province? selectedProvince;
  CityMunicipality? selectedMunicipality;
  Country? selectedCountry;
  Eligibility? selectedEligibility;
  List<Province>? provinces;
  List<CityMunicipality>? citymuns;
  bool provinceCall = false;
  bool cityCall = false;
  final examDateController = TextEditingController();
  final validityDateController = TextEditingController();
  String? token;
  String? profileId;
  String? rating;
  String? license;
  DateTime? examDate;
  DateTime? expireDate;
  @override
  void dispose() {
    examDateController.dispose();
    validityDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EligibilityBloc, EligibilityState>(
      buildWhen: (previous, current) {
        return false;
      },
      builder: (context, state) {
        ////ADD ELIGIBILITY STATE
        if (state is AddEligibilityState) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 28),
            child: FormBuilder(
              key: formKey,
              child: ListView(children: [
                ////ELIGIBILITIES DROPDOWN
                SlideInLeft(
                  child: FormBuilderDropdown<Eligibility>(
                      onChanged: (Eligibility? eligibility) {
                        selectedEligibility = eligibility;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value == null ? 'required' : null,
                      items: state.eligibilities
                          .map<DropdownMenuItem<Eligibility>>(
                              (Eligibility eligibility) {
                        return DropdownMenuItem<Eligibility>(
                            value: eligibility, child: Text(eligibility.title));
                      }).toList(),
                      name: "eligibility",
                      decoration:
                          normalTextFieldStyle("Eligibility", "Eligibility")),
                ),
                const SizedBox(
                  height: 8,
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
                            decoration: normalTextFieldStyle(
                                "license number", "license number"),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        ////RATING
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
                            decoration:
                                normalTextFieldStyle('rating %', 'rating'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  width: screenWidth,
                  child: StatefulBuilder(builder: (context, setState) {
                    return SlideInLeft(
                      delay: const Duration(milliseconds: 170),
                      child: Row(
                        children: [
                          ////EXAM DATE
                          Flexible(
                              flex: 1,
                              child: DateTimePicker(
                                use24HourFormat: false,
                                icon: const Icon(Icons.date_range),
                                controller: examDateController,
                                firstDate: DateTime(1990),
                                lastDate: DateTime(2100),
                                timeHintText: "Date of Examination/Conferment",
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
                            width: 8,
                          ),
                          ////VALIDITY DATE
                          Flexible(
                            flex: 1,
                            child: DateTimePicker(
                              controller: validityDateController,
                              firstDate: DateTime(1970),
                              lastDate: DateTime(2100),
                              decoration: normalTextFieldStyle(
                                      "Expiration date", "Expiration date")
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
                      ),
                    );
                  }),
                ),
                const SizedBox(
                  height: 8,
                ),
                SlideInLeft(
                                        delay: const Duration(milliseconds: 170),
                  child: Text(
                    "Placement of Examination/Conferment",
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(fontSize: blockSizeVertical * 2),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                ////OVERSEAS ADDRESS SWITCH
                Column(
                  children: [
                    SlideInLeft(
                      delay: const Duration(milliseconds: 190),
                      child: FormBuilderSwitch(
                        validator: FormBuilderValidators.required(
                            errorText: 'This field is required'),
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
                      height: 8,
                    ),
                    ////COUNTRY DROPDOWN
                    SizedBox(
                        child: overseas == true
                            ? SlideInLeft(
                                child: FormBuilderDropdown<Country>(
                                  initialValue: null,
                                  validator: FormBuilderValidators.required(
                                      errorText: "This field is required"),
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
                                    child: FormBuilderDropdown<Region?>(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: FormBuilderValidators.required(
                                          errorText: "This field is required"),
                                      //// region onchange
                                      onChanged: (Region? region) async {
                                        if (selectedRegion != region) {
                                          setState(() {
                                            selectedRegion = region;
                                          });
                                          getProvinces();
                                        }
                                      },
                                      initialValue: selectedRegion,
                                      decoration: normalTextFieldStyle(
                                          "Region*", "Region"),
                                      name: 'region',
                                      items: state.regions
                                          .map<DropdownMenuItem<Region>>(
                                              (Region region) {
                                        return DropdownMenuItem<Region>(
                                            value: region,
                                            child: Text(region.description!));
                                      }).toList(),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  ////PROVINCE DROPDOWN
                                  SizedBox(
                                    height: 60,
                                    child: SlideInLeft(
                                      delay: const Duration(milliseconds: 230),
                                      child: DropdownButtonFormField<Province?>(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          validator: (value) =>
                                              value == null ? 'required' : null,
                                          isExpanded: true,
                                          value: selectedProvince,
                                          onChanged: (Province? province) {
                                            if (selectedProvince != province) {
                                              setState(() {
                                                selectedProvince = province;
                                              });

                                              getCities();
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
                                              "Province*", "Province")),
                                    ),
                                  ),

                                  //// CityMunicipalities dropdown
                                  SizedBox(
                                    height: 60,
                                    child: SlideInLeft(
                                      delay: const Duration(milliseconds: 250),
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
                ),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  width: screenWidth,
                  height: 60,
                  child: FadeInUp(
                    child: ElevatedButton(
                        style:
                            mainBtnStyle(primary, Colors.transparent, second),
                        onPressed: () {
                          if (formKey.currentState!.saveAndValidate()) {
                            ////rating
                            double? rate = rating == null
                                ? null
                                : double.tryParse(rating!);
                            ////lisence
                            String? licenseNumber = license;
                            CityMunicipality? cityMunicipality =
                                selectedMunicipality;
                            DateTime? examDate = examDateController.text.isEmpty
                                ? null
                                : DateTime.parse(examDateController.text);
                            DateTime? validityDate = validityDateController
                                    .text.isEmpty
                                ? null
                                : DateTime.parse(validityDateController.text);

                            ExamAddress examAddress = ExamAddress(
                                barangay: null,
                                id: null,
                                addressCategory: null,
                                examAddressClass: null,
                                country: selectedCountry ??
                                    Country(
                                        id: 175,
                                        name: 'Philippines',
                                        code: 'PH'),
                                cityMunicipality: cityMunicipality);
                            EligibityCert eligibityCert = EligibityCert(
                                id: null,
                                rating: rate,
                                examDate: examDate,
                                attachments: null,
                                eligibility: selectedEligibility,
                                examAddress: examAddress,
                                validityDate: validityDate,
                                licenseNumber: licenseNumber,
                                overseas: overseas);
                            final progress = ProgressHUD.of(context);
                            progress!.showWithText("Loading...");
                            context.read<EligibilityBloc>().add(AddEligibility(
                                eligibityCert: eligibityCert,
                                profileId: widget.profileId.toString(),
                                token: widget.token));
                          }
                        },
                        child: const Text(submit)),
                  ),
                ),
              ]),
            ),
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
      context.read<EligibilityBloc>().add(CallErrorState());
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
      context.read<EligibilityBloc>().add(CallErrorState());
    }
  }
}
