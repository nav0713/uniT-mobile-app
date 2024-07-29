import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:unit2/bloc/profile/references/references_bloc.dart';
import 'package:unit2/model/location/address_category.dart';
import 'package:unit2/model/location/barangay.dart';
import 'package:unit2/model/profile/references.dart';
import 'package:unit2/theme-data.dart/btn-style.dart';
import 'package:unit2/theme-data.dart/form-style.dart';
import '../../../../model/location/city.dart';
import '../../../../model/location/country.dart';
import '../../../../model/location/provinces.dart';
import '../../../../model/location/region.dart';
import '../../../../theme-data.dart/colors.dart';
import '../../../../utils/formatters.dart';
import '../../../../utils/location_utilities.dart';
import '../../../../utils/text_container.dart';

class AddReferenceScreen extends StatefulWidget {
  final int profileId;
  final String token;
  const AddReferenceScreen(
      {super.key, required this.profileId, required this.token});

  @override
  State<AddReferenceScreen> createState() => _AddReferenceScreenState();
}

class _AddReferenceScreenState extends State<AddReferenceScreen> {
  final formKey = GlobalKey<FormBuilderState>();
  bool provinceCall = false;
  bool cityCall = false;
  bool barangayCall = false;
  bool overseas = false;
  List<Province>? provinces;
  List<CityMunicipality>? citymuns;
  List<Barangay>? barangays;
  List<String> category = ['Permanent', "Residential", "Birthplace"];
  ////seletected
  Region? selectedRegion;
  Province? selectedProvince;
  CityMunicipality? selectedMunicipality;
  Barangay? selectedBarangay;
  Country? selectedCountry;
  AddressCategory? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReferencesBloc, ReferencesState>(
      builder: (context, state) {
        if (state is AddReferenceState) {
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
                              inputFormatters: [UpperCaseTextFormatter()],
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
                              decoration:
                                  normalTextFieldStyle("Middle name ", ""),
                              name: "middlename",
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          ////Mobile
                          Flexible(
                            flex: 1,
                            child: FormBuilderTextField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [mobileFormatter],
                              name: "mobile",
                              decoration: normalTextFieldStyle(
                                  "Mobile *", "+63 (9xx) xxx - xxxx"),
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
                             delay: const Duration(milliseconds: 170),
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
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    ////OVERSEAS ADDRESS
                    SlideInLeft(
                             delay: const Duration(milliseconds: 190),
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
                                         delay: const Duration(milliseconds: 210),
                                  child: FormBuilderDropdown<Region?>(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: FormBuilderValidators.required(
                                        errorText: "This field is required"),
                                    onChanged: (Region? region) async {
                                      if (selectedRegion != region) {
                                        setState(() {
                                          selectedRegion = region;
                                        });
                                  
                                        getProvinces();
                                      }
                                    },
                                    initialValue: null,
                                    decoration:
                                        normalTextFieldStyle("Region*", "Region"),
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
                                  height: 12,
                                ),
                                //// PROVINCE DROPDOWN
                                SizedBox(
                                  height: 60,
                                  child: SlideInLeft(
                                                              delay: const Duration(milliseconds: 230),
                                    child: DropdownButtonFormField<Province?>(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (value) => value == null
                                            ? 'This field is required'
                                            : null,
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
                                            : provinces!
                                                .map<DropdownMenuItem<Province>>(
                                                    (Province province) {
                                                return DropdownMenuItem(
                                                    value: province,
                                                    child: FittedBox(
                                                      child: Text(
                                                          province.description!),
                                                    ));
                                              }).toList(),
                                        decoration: normalTextFieldStyle(
                                            "Province*", "Province")),
                                  ),
                                ),
                                ////CITY MUNICIPALITY
                                SizedBox(
                                  height: 60,
                                  child:
                                      SlideInLeft(
                                                                  delay: const Duration(milliseconds: 250),
                                        child: DropdownButtonFormField<CityMunicipality>(
                                                                            validator: FormBuilderValidators.required(
                                          errorText: "This field is required"),
                                                                            isExpanded: true,
                                                                            onChanged: (CityMunicipality? city) {
                                        if (selectedMunicipality != city) {
                                          setState(() {
                                            selectedMunicipality = city;
                                          });
                                        
                                          getBarangays();
                                        }
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
                                                  child: Text(c.description!));
                                            }).toList(),
                                                                          ),
                                      ),
                                ),
                                //// BARANGAY
                                SizedBox(
                                  height: 60,
                                  child: SlideInLeft(
                                                              delay: const Duration(milliseconds: 270),
                                    child: DropdownButtonFormField<Barangay>(
                                      isExpanded: true,
                                      onChanged: (Barangay? baragay) {
                                        selectedBarangay = baragay;
                                      },
                                      decoration: normalTextFieldStyle(
                                          "Barangay*", "Barangay"),
                                      value: selectedBarangay,
                                      items: barangays == null
                                          ? []
                                          : barangays!
                                              .map<DropdownMenuItem<Barangay>>(
                                                  (Barangay barangay) {
                                              return DropdownMenuItem(
                                                  value: barangay,
                                                  child: Text(
                                                      barangay.description!));
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
                                  decoration:
                                      normalTextFieldStyle("Country*", "Country"),
                                  onChanged: (Country? value) {
                                    selectedCountry = value;
                                  },
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    FadeInUp(
                      child: SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          style:
                              mainBtnStyle(primary, Colors.transparent, second),
                          child: const Text(submit),
                          onPressed: () {
                            PersonalReference? personalReference;
                            if (formKey.currentState!.saveAndValidate()) {
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
                      
                              Address address = Address(
                                  id: null,
                                  addressCategory: selectedCategory,
                                  country: selectedCountry,
                                  barangay: selectedBarangay,
                                  addressClass: null,
                                  cityMunicipality: city);
                      
                              if (selectedCountry != null) {
                                personalReference = PersonalReference(
                                    id: null,
                                    address: Address(
                                        id: null,
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
                                personalReference = PersonalReference(
                                    id: null,
                                    address: address,
                                    lastName: lastname,
                                    contactNo: mobile,
                                    firstName: firstname,
                                    middleName: middlename);
                              }
                      
                              context.read<ReferencesBloc>().add(AddReference(
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
      context.read<ReferencesBloc>().add(CallErrorState());
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
      context.read<ReferencesBloc>().add(CallErrorState());
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
      context.read<ReferencesBloc>().add(CallErrorState());
    }
  }
}
