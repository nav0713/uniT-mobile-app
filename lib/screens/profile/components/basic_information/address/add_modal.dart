import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:unit2/bloc/profile/primary_information/address/address_bloc.dart';
import 'package:unit2/model/location/address_category.dart';
import 'package:unit2/model/profile/basic_information/adress.dart';
import 'package:unit2/utils/global.dart';
import '../../../../../model/location/barangay.dart';
import '../../../../../model/location/city.dart';
import '../../../../../model/location/country.dart';
import '../../../../../model/location/provinces.dart';
import '../../../../../model/location/region.dart';
import '../../../../../theme-data.dart/btn-style.dart';
import '../../../../../theme-data.dart/colors.dart';
import '../../../../../theme-data.dart/form-style.dart';
import '../../../../../utils/location_utilities.dart';
import '../../../../../utils/text_container.dart';
import '../../../../../utils/validators.dart';

class AddAddressScreen extends StatefulWidget {
  final int profileId;
  final String token;
  const AddAddressScreen(
      {super.key, required this.profileId, required this.token});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  ////boolean
  bool hasLotandBlock = false;
  bool overseas = false;
  bool provinceCall = false;
  bool cityCall = false;
  bool barangayCall = false;
  ////selected
  AddressCategory? selectedAddressCategory;
  String? selectedAreaClass;
  Region? selectedRegion;
  Province? selectedProvince;
  CityMunicipality? selectedMunicipality;
  Barangay? selectedBarangay;
  Country? selectedCountry;
  ////Lists
  final List<Area> areaClass = [
    const Area(value: "Rural Area", group: 0),
    const Area(value: "Sitio", group: 1),
    const Area(value: "Village", group: 1),
    const Area(value: "Urban Area", group: 0),
    const Area(value: "Town", group: 1),
    const Area(value: "City", group: 1),
    const Area(value: "Metropolis", group: 1),
    const Area(value: "Megacity", group: 1),
  ];
  final List<AddressCategory> category = [
    AddressCategory(id: 1, name: "Permanent", type: "home"),
    AddressCategory(id: 2, name: "Residential", type: "home"),
    AddressCategory(id: 3, name: "Birthplace", type: "home")
  ];
  List<Province>? provinces;
  List<CityMunicipality>? citymuns;
  List<Barangay>? barangays;
  final formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressBloc, AddressState>(
      builder: (context, state) {
        if (state is AddAddressState) {
          return FormBuilder(
              key: formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                child: SizedBox(
                  height: screenHeight * 88,
                  child: ListView(
                    children: [
                      SlideInLeft(
                        child: FormBuilderDropdown(
                            validator: FormBuilderValidators.required(
                                errorText: "This field is required"),
                            decoration:
                                normalTextFieldStyle("Category*", "Category"),
                            name: "category",
                            onChanged: (AddressCategory? category) {
                              selectedAddressCategory = category;
                            },
                            items: category
                                .map<DropdownMenuItem<AddressCategory>>(
                                    (AddressCategory category) {
                              return DropdownMenuItem(
                                  value: category, child: Text(category.name!));
                            }).toList()),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      ////Area Class
                      SlideInLeft(
                        delay: const Duration(milliseconds: 110),
                        child: FormBuilderDropdown(
                            decoration: normalTextFieldStyle(
                                "Area class *", "Area class"),
                            name: "area_class",
                            onChanged: (Area? area) {
                              selectedAreaClass = area!.value;
                            },
                            items: areaClass
                                .map<DropdownMenuItem<Area>>((Area area) {
                              return area.group == 0
                                  ? DropdownMenuItem(
                                      enabled: false,
                                      value: area,
                                      child: Text(area.value.toUpperCase(),
                                          style: const TextStyle(
                                              color: Colors.black38)))
                                  : DropdownMenuItem(
                                      value: area,
                                      enabled: true,
                                      child: Text(
                                          "  ${area.value.toUpperCase()}"));
                            }).toList()),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      ////stateful builder
                      StatefulBuilder(builder: (context, setState) {
                        return Column(
                          children: [
                            ////with block & Lot Switch
                            SlideInLeft(
                              delay: const Duration(milliseconds: 120),
                              child: FormBuilderSwitch(
                                initialValue: hasLotandBlock,
                                activeColor: second,
                                onChanged: (value) {
                                  setState(() {
                                    hasLotandBlock = value!;
                                  });
                                },
                                decoration: normalTextFieldStyle(
                                    "With Lot and Block?", 'Graduated?'),
                                name: 'graudated',
                                title: Text(hasLotandBlock ? "YES" : "NO"),
                              ),
                            ),
                            SizedBox(
                              height: hasLotandBlock ? 12 : 0,
                            ),
                            SlideInLeft(
                                           delay: const Duration(milliseconds: 130),
                              child: SizedBox(
                                width: screenWidth,
                                child: hasLotandBlock
                                    ? Row(
                                        children: [
                                          ////block #
                                          Flexible(
                                              flex: 1,
                                              child: FormBuilderTextField(
                                                validator: FormBuilderValidators
                                                    .compose([numericRequired]),
                                                keyboardType:
                                                    TextInputType.number,
                                                name: "block_number",
                                                decoration:
                                                    normalTextFieldStyle(
                                                        "Block #*", "Block #"),
                                              )),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          //// lot #
                                          Flexible(
                                              flex: 1,
                                              child: FormBuilderTextField(
                                                validator: FormBuilderValidators
                                                    .compose([numericRequired]),
                                                name: "lot_number",
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    normalTextFieldStyle(
                                                        "Lot #*", "Lot #"),
                                              )),
                                        ],
                                      )
                                    : Container(),
                              ),
                            ),
                          ],
                        );
                      }),
                      const SizedBox(
                        height: 12,
                      ),
                      //// Address Line
                      SlideInLeft(
                                     delay: const Duration(milliseconds: 140),
                        child: FormBuilderTextField(
                          name: "address_line",
                          decoration: normalTextFieldStyle(
                              "Address Line ", "Address Line"),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      StatefulBuilder(builder: (context, setState) {
                        return Column(
                          children: [
                            SlideInLeft(
                                           delay: const Duration(milliseconds: 150),
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
                                                       delay: const Duration(milliseconds: 160),
                                          child: FormBuilderDropdown<Region?>(
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
                                                getProvinces();
                                                });
                                               
                                              }
                                            },
                                            initialValue: null,
                                            decoration: normalTextFieldStyle(
                                                "Region*", "Region"),
                                            name: 'region',
                                            items: state.regions
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
                                          height: 8,
                                        ),
                                        //// PROVINCE DROPDOWN
                                        SlideInLeft(
                                                       delay: const Duration(milliseconds: 170),
                                          child: SizedBox(
                                            height: 60,
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
                                                selectedProvince =
                                                        province;
                                                    getCities();
                                                    });
                                                  
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
                                                decoration:
                                                    normalTextFieldStyle(
                                                        "Province*",
                                                        "Province")),
                                          ),
                                        ),
                                        ////CITY MUNICIPALITY
                                        SlideInLeft(
                                                       delay: const Duration(milliseconds: 180),
                                          child: SizedBox(
                                            height: 60,
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
                                                  setState(() {
                                            selectedMunicipality = city;
                                                  getBarangays();
                                                  });
                                               
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
                                        //// BARANGAY
                                        SlideInLeft(
                                                       delay: const Duration(milliseconds: 190),
                                          child: SizedBox(
                                            height: 60,
                                            child: DropdownButtonFormField<
                                                Barangay>(
                                              isExpanded: true,
                                              onChanged: (Barangay? baragay) {
                                                selectedBarangay = baragay;
                                              },
                                              decoration:
                                                  normalTextFieldStyle(
                                                      "Barangay*",
                                                      "Barangay"),
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
                                  : SlideInLeft(
                                    child: SizedBox(
                                        height: 60,
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
                      const SizedBox(height: 24,),
                       SlideInUp(
                         child: SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                              style:
                                  mainBtnStyle(primary, Colors.transparent, second),
                              onPressed: () {
                                if (formKey.currentState!.saveAndValidate()) {
                                  String? lotNumber;
                                  String? blockNumber;
                                  String? addressLine;
                                  Country country = selectedCountry ??= Country(
                                      id: 175, name: 'Philippines', code: 'PH');
                                  AddressClass address = AddressClass(
                                      barangay: selectedBarangay,
                                      id: null,
                                      category: null,
                                      areaClass: selectedAreaClass,
                                      cityMunicipality: selectedMunicipality,
                                      country: country);
                                  if (hasLotandBlock) {
                                    lotNumber =
                                        formKey.currentState!.value['lot_number'];
                                    blockNumber =
                                        formKey.currentState!.value['block_number'];
                                  }
                                  addressLine =
                                      formKey.currentState?.value['address_line'];
                           
                                  context.read<AddressBloc>().add(AddAddress(
                                      address: address,
                                      profileId: widget.profileId,
                                      token: widget.token,
                                      blockNumber: blockNumber != null
                                          ? int.parse(blockNumber)
                                          : null,
                                      categoryId: selectedAddressCategory!.id!,
                                      details: addressLine,
                                      lotNumber: lotNumber != null
                                          ? int.parse(lotNumber)
                                          : null));
                                }
                              },
                              child: const Text(submit)),
                                               ),
                       ),
                     
                    ],
                  ),
                ),
              ));
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
      context.read<AddressBloc>().add(CallErrorState());
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
      context.read<AddressBloc>().add(CallErrorState());
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
      context.read<AddressBloc>().add(CallErrorState());
    }
  }
}

class Area {
  final int group;
  final String value;
  const Area({required this.group, required this.value});
}
