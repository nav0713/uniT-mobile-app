import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:searchfield/searchfield.dart';
import 'package:unit2/bloc/role/unit2_assign_area/unit2_assign_area_bloc.dart';
import 'package:unit2/bloc/user/user_bloc.dart';
import 'package:unit2/model/location/barangay.dart';
import 'package:unit2/model/location/city.dart';
import 'package:unit2/model/location/provinces.dart';
import 'package:unit2/model/location/purok.dart';
import 'package:unit2/model/location/region.dart';
import 'package:unit2/model/rbac/rbac.dart';
import 'package:unit2/model/rbac/rbac_station.dart';
import 'package:unit2/model/utils/agency.dart';
import 'package:unit2/sevices/roles/rbac_operations/station_services.dart';
import 'package:unit2/theme-data.dart/btn-style.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/theme-data.dart/form-style.dart';
import 'package:unit2/utils/alerts.dart';
import 'package:unit2/utils/formatters.dart';
import 'package:unit2/utils/location_utilities.dart';
import 'package:unit2/utils/profile_utilities.dart';
import 'package:unit2/widgets/Leadings/add_leading.dart';
import 'package:unit2/widgets/empty_data.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/modal_progress_hud.dart';
import 'package:unit2/widgets/progress_hud.dart';

class Unit2AssignArea extends StatefulWidget {
  final String firstname;
  final String lastname;
  final int id;
  const Unit2AssignArea(
      {super.key,
      required this.firstname,
      required this.lastname,
      required this.id});

  @override
  State<Unit2AssignArea> createState() => _Unit2AssignAreaState();
}

class _Unit2AssignAreaState extends State<Unit2AssignArea> {
  int? userId;
  List<RBAC> roles = [];
  bool agencyAsyncCall = false;
  bool stationAsyncCall = false;
  bool provinceAsyncCall = false;
  bool cityAsyncCall = false;
  bool barangayAsyncCall = false;
  bool purokAsyncCall = false;
  Map<String, List<Content>> assignedAreas = {};
  int? areaTypeId;
  int? roleId;
  String? areaId;
  String? areaType;
  List<Agency> agencies = [];
  List<RbacStation> stations = [];
  List<Province> provinces = [];
  List<CityMunicipality> cities = [];
  List<Barangay> barangays = [];
  List<Purok> puroks = [];
  CityMunicipality? selectedMunicipality;
  FocusNode agencyFocusNode = FocusNode();
  final formKey = GlobalKey<FormBuilderState>();
  final agencyController =
      TextEditingController(text: "PROVINCIAL GOVERNMENT OF AGUSAN DEL NORTE");
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<Unit2AssignAreaBloc>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Assign Areas"),
        backgroundColor: primary,
        centerTitle: true,
        actions: [
          AddLeading(onPressed: () {
            areaType = null;
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Add new assign area"),
                    content: FormBuilder(
                        key: formKey,
                        child: StatefulBuilder(builder: (context, setState) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FormBuilderDropdown<RBAC>(
                                decoration: normalTextFieldStyle(
                                    "Select Role", "Select Role"),
                                name: 'role',
                                items: roles.map<DropdownMenuItem<RBAC>>((e) {
                                  return DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name!),
                                    onTap: () async {
                                      roleId = e.id;
                                      //// barangay
                                      if (e.name!.toLowerCase() == "barangay chairperson" ||
                                          e.name!.toLowerCase() ==
                                              "barangay councilor" ||
                                          e.name!.toLowerCase() ==
                                              "barangay nurse" ||
                                          e.name!.toLowerCase() ==
                                              "health officer in-charge" ||
                                          e.name!.toLowerCase() ==
                                              "health monitoring in-charge" ||
                                          e.name!.toLowerCase() ==
                                              "health nurse") {
                                        try {
                                          areaType = "barangay";
                                          areaTypeId = 1;
                                          setState(() {
                                            provinceAsyncCall = true;
                                          });
                                                                               provinces = await LocationUtils
                                              .instance
                                              .getProvinces(selectedRegion: Region(code: 16, description:  "REGION XIII (Caraga)", psgcCode: "160000000"
));
                                          setState(() {
                                            provinceAsyncCall = false;
                                            cityAsyncCall = true;
                                          });
                                          cities = await LocationUtils.instance
                                              .getCities(
                                                  selectedProvince: provinces[0]);
                                          setState(() {
                                            cityAsyncCall = false;
                                            barangayAsyncCall = true;
                                          });
                                          barangays = await LocationUtils
                                              .instance
                                              .getBarangay(
                                                  cityMunicipality: cities[0]);
                                          setState(() {
                                            barangayAsyncCall = false;
                                          });
                                        } catch (e) {
                                          bloc.add(
                                              Unit2AssignAreaCallErrorState(
                                                  message: e.toString()));
                                        }

                                        //// purok
                                      } else if (e.name!.toLowerCase() ==
                                          "purok president") {
                                        try {
                                          areaType = "purok";
                                          areaTypeId = 2;
                                          setState(() {
                                            provinceAsyncCall = true;
                                          });
                                                                               provinces = await LocationUtils
                                              .instance
                                              .getProvinces(selectedRegion: Region(code: 16, description:  "REGION XIII (Caraga)", psgcCode: "160000000"
));
                                          setState(() {
                                            provinceAsyncCall = false;
                                            cityAsyncCall = true;
                                          });
                                          cities = await LocationUtils.instance
                                              .getCities(
                                                  selectedProvince: provinces[0]);
                                          setState(() {
                                            cityAsyncCall = false;
                                            barangayAsyncCall = true;
                                          });
                                          barangays = await LocationUtils
                                              .instance
                                              .getBarangay(
                                                  cityMunicipality: cities[0]);
                                          setState(() {
                                            barangayAsyncCall = false;
                                            purokAsyncCall = true;
                                          });
                                          puroks = await LocationUtils.instance
                                              .getPurok(
                                                  barangay: barangays[0].code!);
                                          setState(() {
                                            purokAsyncCall = false;
                                          });
                                        } catch (e) {
                                          bloc.add(
                                              Unit2AssignAreaCallErrorState(
                                                  message: e.toString()));
                                        }
                                        //// station
                                      } else if (e.name!.toLowerCase() == "qr code scanner" ||
                                          e.name!.toLowerCase() ==
                                              "security guard" ||
                                          e.name!.toLowerCase() ==
                                              "checkpoint in-charge" ||
                                          e.name!.toLowerCase() ==
                                              'office/branch chief' ||
                                          e.name!.toLowerCase() ==
                                              "process server") {
                                        try {
                                          areaType = "station";
                                          areaTypeId = 4;
                                          setState(() {
                                            stationAsyncCall = true;
                                          });
                                          stations = await RbacStationServices
                                              .instance
                                              .getStationsAvailableToUser(
                                                  userId: widget.id);
                                          setState(() {
                                            stationAsyncCall = false;
                                          });
                                        } catch (e) {
                                          bloc.add(
                                              Unit2AssignAreaCallErrorState(
                                                  message: e.toString()));
                                        }
                                        //// agency-------------------------------
                                      } else if (e.name!.toLowerCase() ==
                                              "establishment point-person" ||
                                          e.name!.toLowerCase() ==
                                              'registration in-charge' ||
                                          e.name!.toLowerCase() ==
                                              "provincial/city drrm officer in-charge") {
                                        areaType = "agency";
                                        areaTypeId = 3;
                                        try {
                                          setState(() {
                                            agencyAsyncCall = true;
                                          });
                                          agencies = await ProfileUtilities
                                              .instance
                                              .getAgenciesAvailableToUser(
                                                  userId: widget.id);
                                        } catch (e) {
                                          bloc.add(
                                              Unit2AssignAreaCallErrorState(
                                                  message: e.toString()));
                                        }
                                        setState(() {
                                          agencyAsyncCall = false;
                                        });
                                      }
                                    },
                                  );
                                }).toList(),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              areaType == "agency"
                                  ? SizedBox(
                                      height: 70,
                                      child: ProgressModalHud(
                                 
                                        inAsyncCall: agencyAsyncCall,
                                        child: SearchField(
                                            inputFormatters: [
                                              UpperCaseTextFormatter()
                                            ],
                                            focusNode: agencyFocusNode,
                                            itemHeight: 100,
                                            suggestions: agencies
                                                .map((Agency agency) =>
                                                    SearchFieldListItem(
                                                        agency.name!,
                                                        item: agency,
                                                        child: ListTile(
                                                          title: AutoSizeText(
                                                            agency.name!
                                                                .toUpperCase(),
                                                            minFontSize: 12,
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
                                            validator:
                                                FormBuilderValidators.required(
                                                    errorText:
                                                        "This field is required"),
                                            searchInputDecoration:
                                                normalTextFieldStyle(
                                                        "Agency *", "")
                                                    .copyWith(
                                                        suffixIcon:
                                                            GestureDetector(
                                              onTap: () =>
                                                  agencyFocusNode.unfocus(),
                                              child: const Icon(
                                                Icons.arrow_drop_down,
                                              ),
                                            )),
                                            ////agency suggestion tap
                                            onSuggestionTap: (agency) {
                                              // setState(() {
                                                areaId =
                                                    agency.item!.id.toString();
                                                agencyFocusNode.unfocus();
                                              // });
                                            },
                                            emptyWidget: const Text(
                                                "No Result Found..")),
                                      ),
                                    )
                                  //// station ------------------------------------------------
                                  : areaType == "station"
                                      ? SizedBox(
                                          height: 75,
                                          child: Flexible(
                                            child: Column(
                                              children: [
                                                ////Stations
                                                Expanded(
                                                  child: SizedBox(
                                                    height: 75,
                                                    child: ProgressModalHud(
                      
                                                      inAsyncCall:
                                                          stationAsyncCall,
                                                      child:
                                                          FormBuilderDropdown<
                                                              RbacStation>(
                                                        decoration:
                                                            normalTextFieldStyle(
                                                                "Station",
                                                                "Station"),
                                                        name: "parent-stations",
                                                        items: stations.isEmpty
                                                            ? []
                                                            : stations.map((e) {
                                                                return DropdownMenuItem(
                                                                  value: e,
                                                                  child: Text(e
                                                                      .stationName!),
                                                                );
                                                              }).toList(),
                                                        onChanged:
                                                            (RbacStation? e) {
                                                          areaId =
                                                              e!.id.toString();
                                                        },
                                                        validator:
                                                            FormBuilderValidators
                                                                .required(
                                                                    errorText:
                                                                        "This field is required"),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      //// barangay ------------------------------------------------------------
                                      : areaType == 'barangay'
                                          ? SizedBox(
                                              height: 180,
                                              child: Column(
                                                children: [
                                                  //// PROVINCE DROPDOWN
                                                  Expanded(
                                                    child: SizedBox(
                                                      height: 60,
                                                      child: ProgressModalHud(
                                            
                                                        inAsyncCall:
                                                            provinceAsyncCall,
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
                                                            // value: selectedProvince,
                                                            onChanged: (Province?
                                                                province) async {
                                                              try {
                                                                setState(() {
                                                                  cityAsyncCall =
                                                                      true;
                                                                });
                                                                cities = await LocationUtils
                                                                    .instance
                                                                    .getCities(
                                                                        selectedProvince: provinces[0]
                                                                            );
                                                                setState(() {
                                                                  cityAsyncCall =
                                                                      false;
                                                                  barangayAsyncCall =
                                                                      true;
                                                                });
                                                                barangays = await LocationUtils
                                                                    .instance
                                                                    .getBarangay(
                                                                        cityMunicipality: cities[0]
                                                                            );
                                                                setState(() {
                                                                  barangayAsyncCall =
                                                                      false;
                                                                });
                                                              } catch (e) {
                                                                bloc.add(Unit2AssignAreaCallErrorState(
                                                                    message: e
                                                                        .toString()));
                                                              }
                                                            },
                                                            items: provinces
                                                                    .isEmpty
                                                                ? []
                                                                : provinces.map<
                                                                    DropdownMenuItem<
                                                                        Province>>((Province
                                                                    province) {
                                                                    return DropdownMenuItem(
                                                                        value:
                                                                            province,
                                                                        child:
                                                                            FittedBox(
                                                                          child:
                                                                              Text(province.description!),
                                                                        ));
                                                                  }).toList(),
                                                            decoration:
                                                                normalTextFieldStyle(
                                                                    "Province*",
                                                                    "Province")),
                                                      ),
                                                    ),
                                                  ),
                                                  //// CITIES DROPDOWN

                                                  Expanded(
                                                    child: SizedBox(
                                                      height: 60,
                                                      child: ModalProgressHUD(
                                                        color: Colors.white,
                                                        inAsyncCall:
                                                            cityAsyncCall,
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
                                                                  city) async {
                                                            try {
                                                              setState(() {
                                                                selectedMunicipality =
                                                                    city;
                                                                barangayAsyncCall =
                                                                    true;
                                                              });
                                                              barangays = await LocationUtils
                                                                  .instance
                                                                  .getBarangay(
                                                                      cityMunicipality: selectedMunicipality!
                                                                          );
                                                              setState(() {
                                                                barangayAsyncCall =
                                                                    false;
                                                              });
                                                            } catch (e) {
                                                              bloc.add(
                                                                  Unit2AssignAreaCallErrorState(
                                                                      message: e
                                                                          .toString()));
                                                            }
                                                          },
                                                          decoration:
                                                              normalTextFieldStyle(
                                                                  "Municipality*",
                                                                  "Municipality"),
                                                          // value: selectedMunicipality,
                                                          items: cities.isEmpty
                                                              ? []
                                                              : cities.map<
                                                                      DropdownMenuItem<
                                                                          CityMunicipality>>(
                                                                  (CityMunicipality
                                                                      c) {
                                                                  return DropdownMenuItem(
                                                                      value: c,
                                                                      child: Text(
                                                                          c.description!));
                                                                }).toList(),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  ////Barangay

                                                  Expanded(
                                                    child: SizedBox(
                                                      height: 60,
                                                      child: ProgressModalHud(
                                            
                                                        inAsyncCall:
                                                            barangayAsyncCall,
                                                        child:
                                                            DropdownButtonFormField<
                                                                Barangay>(
                                                          isExpanded: true,
                                                          onChanged: (Barangay?
                                                              baragay) {
                                                            areaId =
                                                                baragay!.code;
                                                          },
                                                          decoration:
                                                              normalTextFieldStyle(
                                                                  "Barangay*",
                                                                  "Barangay"),
                                                          // value: selectedBarangay,
                                                          validator:
                                                              FormBuilderValidators
                                                                  .required(
                                                                      errorText:
                                                                          "This field is required"),
                                                          items: barangays
                                                                  .isEmpty
                                                              ? []
                                                              : barangays.map<
                                                                  DropdownMenuItem<
                                                                      Barangay>>((Barangay
                                                                  barangay) {
                                                                  return DropdownMenuItem(
                                                                      value:
                                                                          barangay,
                                                                      child: Text(
                                                                          barangay
                                                                              .description!));
                                                                }).toList(),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ))
                                          : //// Purok ------------------------------------------------------------
                                          areaType == 'purok'
                                              ? SizedBox(
                                                  height: 200,
                                                  child: Column(
                                                    children: [
                                                      //// PROVINCE DROPDOWN
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 60,
                                                          child:
                                                              ProgressModalHud(
                                     
                                                            inAsyncCall:
                                                                provinceAsyncCall,
                                                            child: DropdownButtonFormField<
                                                                    Province?>(
                                                                autovalidateMode:
                                                                    AutovalidateMode
                                                                        .onUserInteraction,
                                                                validator: (value) =>
                                                                    value == null
                                                                        ? 'required'
                                                                        : null,
                                                                isExpanded:
                                                                    true,
                                                                // value: selectedProvince,
                                                                onChanged:
                                                                    (Province?
                                                                        province) async {
                                                                  try {
                                                                    setState(
                                                                        () {
                                                                      province;
                                                                      cityAsyncCall =
                                                                          true;
                                                                    });
                                                                    cities = await LocationUtils
                                                                        .instance
                                                                        .getCities(
                                                                            selectedProvince:
                                                                                provinces[0]);
                                                                    setState(
                                                                        () {
                                                                      cityAsyncCall =
                                                                          false;
                                                                      barangayAsyncCall =
                                                                          true;
                                                                    });
                                                                    barangays = await LocationUtils
                                                                        .instance
                                                                        .getBarangay(
                                                                            cityMunicipality:
                                                                                cities[0]);
                                                                    setState(
                                                                        () {
                                                                      barangayAsyncCall =
                                                                          false;
                                                                      purokAsyncCall =
                                                                          true;
                                                                    });
                                                                    puroks = await LocationUtils
                                                                        .instance
                                                                        .getPurok(
                                                                            barangay:
                                                                                barangays[0].code!);
                                                                    setState(
                                                                        () {
                                                                      purokAsyncCall =
                                                                          false;
                                                                    });
                                                                  } catch (e) {
                                                                    bloc.add(Unit2AssignAreaCallErrorState(
                                                                        message:
                                                                            e.toString()));
                                                                  }
                                                                },
                                                                items: provinces
                                                                        .isEmpty
                                                                    ? []
                                                                    : provinces.map<
                                                                        DropdownMenuItem<
                                                                            Province>>((Province
                                                                        province) {
                                                                        return DropdownMenuItem(
                                                                            value:
                                                                                province,
                                                                            child:
                                                                                FittedBox(
                                                                              child: Text(province.description!),
                                                                            ));
                                                                      }).toList(),
                                                                decoration: normalTextFieldStyle(
                                                                    "Province*",
                                                                    "Province")),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                      //// CITIES DROPDOWN
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 60,
                                                          child:
                                                              ProgressModalHud(
                                                  
                                                            inAsyncCall:
                                                                cityAsyncCall,
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
                                                                try {
                                                                  setState(() {
                                                                    selectedMunicipality =
                                                                        city;
                                                                    barangayAsyncCall =
                                                                        true;
                                                                  });
                                                                  barangays = await LocationUtils
                                                                      .instance
                                                                      .getBarangay(
                                                                          cityMunicipality:
                                                                              selectedMunicipality!);
                                                                  setState(() {
                                                                    barangayAsyncCall =
                                                                        false;
                                                                    purokAsyncCall =
                                                                        true;
                                                                  });
                                                                  puroks = await LocationUtils
                                                                      .instance
                                                                      .getPurok(
                                                                          barangay:
                                                                              barangays[0].code!);

                                                                  setState(() {
                                                                    purokAsyncCall =
                                                                        false;
                                                                  });
                                                                } catch (e) {
                                                                  bloc.add(Unit2AssignAreaCallErrorState(
                                                                      message: e
                                                                          .toString()));
                                                                }
                                                              },

                                                              decoration: normalTextFieldStyle(
                                                                  "Municipality*",
                                                                  "Municipality"),
                                                              // value: selectedMunicipality,
                                                              items: cities
                                                                      .isEmpty
                                                                  ? []
                                                                  : cities.map<
                                                                          DropdownMenuItem<
                                                                              CityMunicipality>>(
                                                                      (CityMunicipality
                                                                          c) {
                                                                      return DropdownMenuItem(
                                                                          value:
                                                                              c,
                                                                          child:
                                                                              Text(c.description!));
                                                                    }).toList(),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      ////Barangay
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 60,
                                                          child:
                                                              ModalProgressHUD(
                                                            color: Colors.white,
                                                            inAsyncCall:
                                                                barangayAsyncCall,
                                                            child:
                                                                DropdownButtonFormField<
                                                                    Barangay>(
                                                              isExpanded: true,
                                                              onChanged: (Barangay?
                                                                  baragay) async {
                                                                areaId =
                                                                    baragay!
                                                                        .code;
                                                                try {
                                                                  setState(() {
                                                                    purokAsyncCall =
                                                                        true;
                                                                  });
                                                                  puroks = await LocationUtils
                                                                      .instance
                                                                      .getPurok(
                                                                          barangay:
                                                                              barangays[0].code!);
                                                                  setState(() {
                                                                    purokAsyncCall =
                                                                        false;
                                                                  });
                                                                } catch (e) {
                                                                  bloc.add(Unit2AssignAreaCallErrorState(
                                                                      message: e
                                                                          .toString()));
                                                                }
                                                              },
                                                              decoration:
                                                                  normalTextFieldStyle(
                                                                      "Barangay*",
                                                                      "Barangay"),
                                                              // value: selectedBarangay,
                                                              validator: FormBuilderValidators
                                                                  .required(
                                                                      errorText:
                                                                          "This field is required"),

                                                              items: barangays
                                                                      .isEmpty
                                                                  ? []
                                                                  : barangays.map<
                                                                      DropdownMenuItem<
                                                                          Barangay>>((Barangay
                                                                      barangay) {
                                                                      return DropdownMenuItem(
                                                                          value:
                                                                              barangay,
                                                                          child:
                                                                              Text(barangay.description!));
                                                                    }).toList(),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                      ////Purok
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 60,
                                                          child:
                                                              ProgressModalHud(
                                             
                                                            inAsyncCall:
                                                                purokAsyncCall,
                                                            child:
                                                                DropdownButtonFormField<
                                                                    Purok>(
                                                              isExpanded: true,
                                                              onChanged: (Purok?
                                                                  purok) {
                                                                areaId =
                                                                    purok!.code;
                                                              },
                                                              decoration:
                                                                  normalTextFieldStyle(
                                                                      "Purok*",
                                                                      "Parangay"),
                                                              // value: selectedBarangay,
                                                              validator: FormBuilderValidators
                                                                  .required(
                                                                      errorText:
                                                                          "This field is required"),
                                                              items: puroks
                                                                      .isEmpty
                                                                  ? []
                                                                  : puroks.map<
                                                                      DropdownMenuItem<
                                                                          Purok>>((Purok
                                                                      purok) {
                                                                      return DropdownMenuItem(
                                                                          value:
                                                                              purok,
                                                                          child:
                                                                              Text(purok.description));
                                                                    }).toList(),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ))
                                              : Container(),
                              const SizedBox(
                                height: 25,
                              ),
                              SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                      style: mainBtnStyle(
                                          primary, Colors.transparent, second),
                                      onPressed: () {
                                        if (formKey.currentState!
                                            .saveAndValidate()) {
                                          if (areaId != null) {
                                            bloc.add(Unit2AddAssignArea(
                                                areaId: areaId!,
                                                areaTypeId: areaTypeId!,
                                                roleId: roleId!,
                                                userId: userId!));
                                          }
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: const Text("Add")))
                            ],
                          );
                        })),
                  );
                });
          })
        ],
      ),
      body: LoadingProgress(

          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoggedIn) {
                return BlocConsumer<Unit2AssignAreaBloc, Unit2AssignAreaState>(
                    listener: (context, state) {
                  if (state is Uni2AssignAreaLoadingState) {
                    final progress = ProgressHUD.of(context);
                    progress!.showWithText("Please wait...");
                  }
                  if (state is Unit2AssignAreaLoaded ||
                      state is UserNotExistError ||
                      state is Unit2AssignAreaErorState ||
                      state is Unit2AssignedAreaDeletedState || state is Unit2AssignAreaAddedState) {
                    final progress = ProgressHUD.of(context);
                    progress!.dismiss();
                  }

                  if (state is Unit2AssignedAreaDeletedState) {
                    if (state.success) {
                      successAlert(context, "Delete Successfull!",
                          "Assign Area Deleted Successfully", () {
                        Navigator.of(context).pop();
                        context
                            .read<Unit2AssignAreaBloc>()
                            .add(LoadUnit2AssignedAreas(userId: userId!));
                      });
                    } else {
                      errorAlert(context, "Delete Failed",
                          "Assign Area Deletion Failed", () {
                        Navigator.of(context).pop();
                        context
                            .read<Unit2AssignAreaBloc>()
                            .add(LoadUnit2AssignedAreas(userId: userId!));
                      });
                    }
                  }

                  ////Added State
                  if (state is Unit2AssignAreaAddedState) {
                    if (state.response['success']) {
                      successAlert(context, "Adding Successfull!",
                          state.response['message'], () {
                        Navigator.of(context).pop();
                   bloc.add(LoadUnit2AssignedAreas(userId: widget.id));
                      });
                    } else {
                      errorAlert(context, "Adding Failed",
                          "Something went wrong. Please try again.", () {
                        Navigator.of(context).pop();
                  bloc.add(LoadUnit2AssignedAreas(userId: widget.id));
                      });
                    }
                  }
                }, builder: (context, state) {
                  if (state is Unit2AssignAreaLoaded) {
                    roles = state.roles;
                    assignedAreas = {};
                    userId = state.userId;
                    if (state.userAssignedAreas.isNotEmpty) {
                      for (var roleMod in state.userAssignedAreas) {
                        assignedAreas.addAll({
                          roleMod.assignedRole!.role!.name!.toLowerCase(): []
                        });
                        String areaType = roleMod
                            .assignedRoleAreaType!.areaTypeName
                            .toLowerCase();
                        for (var area in roleMod.assignedArea) {
                          if (areaType == 'baranggay') {
                            assignedAreas[roleMod.assignedRole!.role!.name!
                                    .toLowerCase()]!
                                .add(Content(
                                    id: area['id'],
                                    name: area['area']['brgydesc'],subtitle: null));
                          } else if (areaType == 'purok') {
                            assignedAreas[roleMod.assignedRole!.role!.name!
                                    .toLowerCase()]!
                                .add(Content(
                                    id: area['id'],
                                    name: area['area']['purokdesc'],subtitle: null));
                          } else if (areaType == 'station') {
                            assignedAreas[roleMod.assignedRole!.role!.name!
                                    .toLowerCase()]!
                                .add(Content(
                                    id: area['id'],
                                    name: area['area']["station_name"],subtitle:" (${ area['area']['acronym']}) - "+  area['area']['government_agency']['agencyname']));
                          } else if (areaType == 'agency') {
                            assignedAreas[roleMod.assignedRole!.role!.name!
                                    .toLowerCase()]!
                                .add(Content(
                                    id: area['id'],
                                    name: area['area']['name'],subtitle: null));
                          }
                        }
                      }
                    }
                    if (state.userAssignedAreas.isNotEmpty) {
                      return Column(
                        children: [
                          ListTile(
                            tileColor: second,
                            leading: const Icon(
                              FontAwesome5.user_alt,
                              color: Colors.white,
                            ),
                            title: Text(state.fullname.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(color: Colors.white)),
                            subtitle: Text("Person full name",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(color: Colors.white)),
                          ),
                          Expanded(
                            child: GroupListView(
                              sectionsCount: assignedAreas.keys.toList().length,
                              countOfItemInSection: (int section) {
                                return assignedAreas.values
                                    .toList()[section]
                                    .length;
                              },
                              itemBuilder:
                                  (BuildContext context, IndexPath index) {
                                return ListTile(
                                  dense: true,
                                  trailing: IconButton(
                                    color: Colors.grey.shade600,
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      confirmAlert(context, () {
                                        context.read<Unit2AssignAreaBloc>().add(
                                            DeleteUnit2AssignedArea(
                                                areaId: assignedAreas.values
                                                    .toList()[index.section]
                                                        [index.index]
                                                    .id));
                                      }, "Delete?", "Confirm Delete?");
                                    },
                                  ),
                                  title: 
                              
                                    
                                      Expanded(
                                        child: Text(
                                          assignedAreas.values
                                              .toList()[index.section]
                                                  [index.index]
                                              .name
                                              .toUpperCase(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge!
                                              .copyWith(color: primary),
                                        ),
                                      ),
                                    
                                  
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 5,left: 6),
                                    child: Text(
                                            assignedAreas.values
                                                .toList()[index.section]
                                                    [index.index].subtitle??'',style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 8),),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Divider();
                              },
                              groupHeaderBuilder:
                                  (BuildContext context, int section) {
                                return ListTile(
                                  tileColor: Colors.white,
                                  title: Text(
                                    assignedAreas.keys
                                        .toList()[section]
                                        .toUpperCase(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                            color: primary,
                                            fontWeight: FontWeight.bold),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    } else {
                      return EmptyData(
                          message:
                              "No Assigned Area available for ${state.fullname}. Please click + to add.");
                    }
                  }
                  if (state is Unit2AssignAreaErorState) {
                    return SomethingWentWrong(
                        message: state.message, onpressed: () {
                          bloc.add(LoadUnit2AssignedAreas(userId: widget.id));
                        });
                  }
                  if (state is UserNotExistError) {
                    return const Center(
                      child: Text("User Not Exsit"),
                    );
                  }
                  return Container();
                });
              }
              return Container();
            },
          )),
    );
  }
}

class Content {
  final int id;
  final String name;
  final String? subtitle;
  const Content({required this.id, required this.name,required this.subtitle});
}
