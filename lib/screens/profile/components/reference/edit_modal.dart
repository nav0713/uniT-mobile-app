import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:unit2/utils/global_context.dart';
import '../../../../bloc/profile/references/references_bloc.dart';
import '../../../../model/location/address_category.dart';
import '../../../../model/location/barangay.dart';
import '../../../../model/location/city.dart';
import '../../../../model/location/country.dart';
import '../../../../model/location/provinces.dart';
import '../../../../model/location/region.dart';
import '../../../../model/profile/references.dart';
import '../../../../theme-data.dart/btn-style.dart';
import '../../../../theme-data.dart/colors.dart';
import '../../../../theme-data.dart/form-style.dart';
import '../../../../utils/formatters.dart';
import '../../../../utils/location_utilities.dart';
import '../../../../utils/text_container.dart';

class EditReferenceScreen extends StatefulWidget {
  final String token;
  final int profileId;
  const EditReferenceScreen(
      {super.key, required this.profileId, required this.token});

  @override
  State<EditReferenceScreen> createState() => _EditReferenceScreenState();
}

class _EditReferenceScreenState extends State<EditReferenceScreen> {
  final formKey = GlobalKey<FormBuilderState>();
  bool provinceCall = false;
  bool cityCall = false;
  bool barangayCall = false;
  bool overseas = false;
  List<Province>? provinces;
  List<CityMunicipality>? citymuns;
  List<Barangay>? barangays;
  ////seletected
  Region? selectedRegion;
  Province? selectedProvince;
  CityMunicipality? selectedMunicipality;
  Barangay? selectedBarangay;
  Country? selectedCountry;
  AddressCategory? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ReferencesBloc>(context);
    return BlocBuilder<ReferencesBloc, ReferencesState>(
      buildWhen: (previous, current) => false,
      builder: (context, state) {
        if (state is EditReferenceState) {
          overseas = state.isOverseas;
          selectedCategory = state.selectedCategory;
          ////if not overseas address
          //// set initial values
          if (!overseas) {
            selectedRegion = state.selectedRegion;
            provinces = state.provinces;
            selectedProvince = state.selectedProvince;
            citymuns = state.cities;
            selectedMunicipality = state.selectedCity;
            barangays = state.barangays;
            selectedBarangay = state.selectedBarangay;
          } else {
            selectedCountry = state.selectedCountry;
          }

          return FormBuilder(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: ListView(
                  children: [
                    SlideInLeft(
                      child: Row(
                        children: [
                          ////LAST NAME
                          Flexible(
                            flex: 1,
                            child: FormBuilderTextField(
                              inputFormatters: [
                                UpperCaseTextFormatter(),
                                mobileFormatter
                              ],
                              initialValue: state.ref.lastName,
                              decoration: normalTextFieldStyle(
                                  "Last name *", "Last name *"),
                              name: "lastname",
                              validator: FormBuilderValidators.required(
                                  errorText: "This field is required"),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          ////FIRST  NAME
                          Flexible(
                            flex: 1,
                            child: FormBuilderTextField(
                              inputFormatters: [UpperCaseTextFormatter()],
                              initialValue: state.ref.firstName,
                              decoration: normalTextFieldStyle(
                                  "First name *", "First name *"),
                              name: "firstname",
                              validator: FormBuilderValidators.required(
                                  errorText: "This field is required"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SlideInLeft(
                                                delay: const Duration(milliseconds: 150),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: FormBuilderTextField(
                              inputFormatters: [UpperCaseTextFormatter()],
                              initialValue: state.ref.middleName,
                              decoration: normalTextFieldStyle(
                                  "Middle name *", "Midlle name *"),
                              name: "middlename",
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          ////CATEGORY
                          Flexible(
                            flex: 1,
                            child: FormBuilderTextField(
                              initialValue: state.ref.contactNo,
                              name: "mobile",
                              decoration: normalTextFieldStyle(
                                  "Tel./Mobile *", "Tel./Mobile"),
                              validator: FormBuilderValidators.required(
                                  errorText: "This field is required"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SlideInLeft(
                                         delay: const Duration(milliseconds: 150),
                      child: FormBuilderDropdown<AddressCategory>(
                        name: 'category',
                        validator: FormBuilderValidators.required(
                            errorText: "This field is required"),
                        decoration: normalTextFieldStyle(
                            "Address Category", "Address Category"),
                        items: state.categories
                            .map<DropdownMenuItem<AddressCategory>>(
                                (AddressCategory cat) {
                          return DropdownMenuItem<AddressCategory>(
                            value: cat,
                            child: Text(cat.name!),
                          );
                        }).toList(),
                        initialValue: selectedCategory,
                        onChanged: (value) {
                          selectedCategory = value;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    ////OVERSEAS ADDRESS
                    StatefulBuilder(builder: (context, setState) {
                      return Column(
                        children: [
                          SlideInLeft(
                                               delay: const Duration(milliseconds: 170),
                            child: FormBuilderSwitch(
                              initialValue: overseas,
                              activeColor: second,
                              onChanged: (value) {
                                setState(() {
                                  overseas = value!;
                                });
                              },
                              decoration: normalTextFieldStyle("", ''),
                              name: 'overseas',
                              title: const Text("Overseas Address?"),
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
                                                          delay: const Duration(milliseconds: 190),
                                        child: DropdownButtonFormField<Region?>(
                                          isExpanded: true,
                                          autovalidateMode:
                                              AutovalidateMode.onUserInteraction,
                                          validator:
                                              FormBuilderValidators.required(
                                                  errorText:
                                                      "This field is required"),
                                          onChanged: (Region? region) async {
                                            setState(() {
                                              provinceCall = true;
                                        
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
                                              bloc.add(CallErrorState());
                                            }
                                            selectedProvince = provinces![0];
                                            setState(() {
                                              provinceCall = false;
                                              cityCall = true;
                                            });
                                            ////GET CITY MUNICIPALITY
                                            try {
                                              citymuns = await LocationUtils
                                                  .instance
                                                  .getCities(
                                                      selectedProvince:
                                                          selectedProvince!);
                                            } catch (e) {
                                              bloc.add(CallErrorState());
                                            }
                                            selectedMunicipality = citymuns![0];
                                            setState(() {
                                              cityCall = false;
                                              barangayCall = true;
                                            });
                                            //// GET BARANGAYS
                                            try {
                                              barangays = await LocationUtils
                                                  .instance
                                                  .getBarangay(
                                                      cityMunicipality:
                                                          selectedMunicipality!);
                                              selectedBarangay = barangays![0];
                                            } catch (e) {
                                              bloc.add(CallErrorState());
                                            }
                                            setState(() {
                                              barangayCall = false;
                                            });
                                          },
                                          value: selectedRegion,
                                          decoration: normalTextFieldStyle(
                                              "Region*", "Region"),
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
                                        height: 12,
                                      ),
                                      //// PROVINCE DROPDOWN
                                      SizedBox(
                                        height: 60,
                                        child: SlideInLeft(
                                                            delay: const Duration(milliseconds: 210),
                                          child: DropdownButtonFormField<
                                                  Province?>(
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              validator: (value) => value == null
                                                  ? 'required'
                                                  : null,
                                              isExpanded: true,
                                              onChanged:
                                                  (Province? province) async {
                                                selectedProvince = province;
                                                setState(() {
                                                  cityCall = true;
                                                });
                                                //// GET CITIES
                                                try {
                                                  citymuns = await LocationUtils
                                                      .instance
                                                      .getCities(
                                                          selectedProvince:
                                                              selectedProvince!);
                                                } catch (e) {
                                                  bloc.add(CallErrorState());
                                                }
                                                selectedMunicipality =
                                                    citymuns![0];
                                                setState(() {
                                                  cityCall = false;
                                                  barangayCall = true;
                                                });
                                                //// GET BARANGAY
                                                try {
                                                  barangays = await LocationUtils
                                                      .instance
                                                      .getBarangay(
                                                          cityMunicipality:
                                                              selectedMunicipality!);
                                                } catch (e) {
                                                  bloc.add(CallErrorState());
                                                }
                                                selectedBarangay = barangays![0];
                                                setState(() {
                                                  barangayCall = false;
                                                });
                                              },
                                              value: selectedProvince,
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
                                                            delay: const Duration(milliseconds: 230),
                                          child: DropdownButtonFormField<
                                              CityMunicipality>(
                                            validator:
                                                FormBuilderValidators.required(
                                                    errorText:
                                                        "This field is required"),
                                            isExpanded: true,
                                            onChanged:
                                                (CityMunicipality? city) async {
                                              setState(() {
                                                barangayCall = true;
                                              });
                                              selectedMunicipality = city;
                                              //// GET BARANGAYS
                                              try {
                                                barangays = await LocationUtils
                                                    .instance
                                                    .getBarangay(
                                                        cityMunicipality:
                                                            selectedMunicipality!);
                                              } catch (e) {
                                                NavigationService
                                                    .navigatorKey.currentContext
                                                    ?.read<ReferencesBloc>()
                                                    .add(CallErrorState());
                                              }
                                              selectedBarangay = barangays![0];
                                              setState(() {
                                                barangayCall = false;
                                              });
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
                                      //// BARANGAY
                                      SizedBox(
                                        height: 60,
                                        child:
                                            SlideInLeft(
                                                                            delay: const Duration(milliseconds: 250),
                                              child: DropdownButtonFormField<Barangay>(
                                                                                        validator:
                                                FormBuilderValidators.required(
                                                    errorText:
                                                        "This field is required"),
                                                                                        isExpanded: true,
                                                                                        onChanged: (Barangay? baragay) {
                                              selectedBarangay = baragay;
                                                                                        },
                                                                                        decoration: normalTextFieldStyle(
                                                "Barangay*", "Barangay"),
                                                                                        value: selectedBarangay,
                                                                                        items: barangays == null
                                                ? []
                                                : barangays!.map<
                                                        DropdownMenuItem<
                                                            Barangay>>(
                                                    (Barangay barangay) {
                                                    return DropdownMenuItem(
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
                                    child: SlideInLeft(
                                      child: DropdownButtonFormField<Country>(
                                        isExpanded: true,
                                        value: selectedCountry?.id == 175
                                            ? null
                                            : selectedCountry,
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
                                      
                                        decoration: normalTextFieldStyle(
                                            "Country*", "Country"),
                                        //// country dropdown
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
                      height: 16,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: FadeInUp(
                        child: ElevatedButton(
                          style:
                              mainBtnStyle(primary, Colors.transparent, second),
                          child: const Text(submit),
                          onPressed: () {
                            PersonalReference? personalReference;
                            if (formKey.currentState!.saveAndValidate()) {
                              final progress = ProgressHUD.of(context);
                              progress!.showWithText("Please wait...");
                              String lastname =
                                  formKey.currentState!.value['lastname'];
                              String firstname =
                                  formKey.currentState!.value['firstname'];
                              String? middlename =
                                  formKey.currentState?.value['middlename'];
                              String mobile =
                                  formKey.currentState!.value['mobile'];
                        
                              Region? region = selectedRegion;
                              Province? province = Province(
                                  code: selectedProvince?.code,
                                  description: selectedProvince?.description,
                                  region: region,
                                  psgcCode: selectedProvince?.psgcCode,
                                  shortname: selectedProvince?.shortname);
                              CityMunicipality? city = CityMunicipality(
                                  code: selectedMunicipality?.code,
                                  description: selectedMunicipality?.description,
                                  province: province,
                                  psgcCode: selectedMunicipality?.psgcCode,
                                  zipcode: selectedMunicipality?.zipcode);
                        
                              ////IF IS OVERSEAS
                              if (overseas) {
                                personalReference = PersonalReference(
                                    id: state.ref.id,
                                    address: Address(
                                        id: state.ref.address!.id,
                                        addressCategory: selectedCategory,
                                        country: selectedCountry,
                                        barangay: null,
                                        cityMunicipality: null,
                                        addressClass: null),
                                    lastName: lastname,
                                    contactNo: mobile,
                                    firstName: firstname,
                                    middleName: middlename);
                              } else {
                                //// IF NOT OVERSEAS
                                personalReference = PersonalReference(
                                    id: state.ref.id,
                                    address: Address(
                                        id: state.ref.address!.id,
                                        addressCategory: selectedCategory,
                                        country: Country(
                                            id: 175, code: null, name: null),
                                        barangay: selectedBarangay,
                                        cityMunicipality: city,
                                        addressClass:
                                            state.ref.address?.addressClass),
                                    lastName: lastname,
                                    contactNo: mobile,
                                    firstName: firstname,
                                    middleName: middlename);
                              }
                        
                              context.read<ReferencesBloc>().add(EditReference(
                                  profileId: widget.profileId,
                                  reference: personalReference,
                                  token: widget.token));
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        }
        return Container();
      },
    );
  }
}
