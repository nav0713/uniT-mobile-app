import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:searchfield/searchfield.dart';
import 'package:unit2/model/rbac/rbac_station.dart';
import 'package:unit2/model/utils/position.dart';
import 'package:unit2/widgets/Leadings/add_leading.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';
import '../../../../bloc/role/pass_check/est_point_person/est_point_person_station/est_point_person_station_bloc.dart';
import '../../../../model/rbac/station_type.dart';
import '../../../../theme-data.dart/box_shadow.dart';
import '../../../../theme-data.dart/btn-style.dart';
import '../../../../theme-data.dart/colors.dart';
import '../../../../theme-data.dart/form-style.dart';
import '../../../../utils/alerts.dart';
import '../../../../utils/global.dart';
import '../../../../widgets/empty_data.dart';
import '../../../profile/shared/add_for_empty_search.dart';

class EstPointPersonStationScreen extends StatelessWidget {
  final String agencyId;
  const EstPointPersonStationScreen({
    required this.agencyId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final estPointPersonBloc =
        BlocProvider.of<EstPointPersonStationBloc>(context);
    List<RbacStation> stations = [];
    final formKey = GlobalKey<FormBuilderState>();
    List<Map<dynamic, dynamic>> hierarchy = [];
    bool mainParent = false;
    bool isWithinParent = true;
    bool isHospital = false;
    List<StationType> stationTypes = [];
    List<PositionTitle> positions = [];
    List<RbacStation> mainParentStations = [];
    List<RbacStation> parentStations = [];
    RbacStation? selectedMainParentStation;
    RbacStation? selectedParentStation;
    StationType? selectedStationType;
    PositionTitle? selectedPositiontitle;
    final addStationTypeController = TextEditingController();
    final stationTypeFocusNode = FocusNode();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primary,
        title: const Text("Station Screen"),
        actions: [
          AddLeading(onPressed: () {
            BuildContext parent = context;
            mainParentStations = [];
            mainParent = stations.isEmpty?true:false;
            for (RbacStation station in stations) {
              if (station.hierarchyOrderNo == 1) {
                mainParentStations.add(station);
              }
            }
            //// Add New Station
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Add New Station"),
                    content: SingleChildScrollView(
                      child: FormBuilder(
                        key: formKey,
                        child: StatefulBuilder(builder: (context, setState) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ////is main parent
                              FormBuilderSwitch(
                                initialValue: mainParent,
                                activeColor: second,
                                onChanged: (value) {
                                  setState(() {
                                    mainParent = !mainParent;
                                  });
                                },
                                decoration: normalTextFieldStyle(
                                    "is Main Parent?", 'is Main Parent?'),
                                name: 'main-parent',
                                title: Text(mainParent ? "YES" : "NO"),
                                validator: FormBuilderValidators.required(
                                    errorText: "This field is required"),
                              ),
                               SizedBox(
                                height: mainParent?0: 8,
                              ),
                              //// selected main parent
                              SizedBox(
                                child: mainParent == true
                                    ? const SizedBox.shrink()
                                    : FormBuilderDropdown<RbacStation>(
                                        decoration: normalTextFieldStyle(
                                            "Main Parent Station",
                                            "Main Parent Station"),
                                        name: "parent-stations",
                                        items: mainParentStations.isEmpty
                                            ? []
                                            : mainParentStations.map((e) {
                                                return DropdownMenuItem(
                                                  value: e,
                                                  child: Text(e.stationName!),
                                                );
                                              }).toList(),
                                        onChanged: (RbacStation? e) {
                                          setState(() {
                                            selectedMainParentStation = e;
                                            parentStations = [];
                                            for (RbacStation station
                                                in stations) {
                                              if (station.mainParentStation ==
                                                  selectedMainParentStation!
                                                      .id) {
                                                parentStations.add(station);
                                              }
                                            }
                                            parentStations.add(
                                                selectedMainParentStation!);
                                          });
                                        },
                                        validator:
                                            FormBuilderValidators.required(
                                                errorText:
                                                    "This field is required"),
                                      ),
                              ),
                                   SizedBox(
                                height: mainParent?0: 8,
                              ),
                              ////parent station
                              SizedBox(
                                child: mainParent == true
                                    ? const SizedBox.shrink()
                                    : FormBuilderDropdown<RbacStation>(
                                        decoration: normalTextFieldStyle(
                                            "Parent Station", "Parent Station"),
                                        name: "parent-stations",
                                        onChanged: (RbacStation? e) {
                                          setState(() {
                                            selectedParentStation = e;
                                          });
                                        },
                                        items: parentStations.isEmpty
                                            ? []
                                            : parentStations.map((e) {
                                                return DropdownMenuItem(
                                                  value: e,
                                                  child: Text(e.stationName!),
                                                );
                                              }).toList(),
                                        validator:
                                            FormBuilderValidators.required(
                                                errorText:
                                                    "This field is required"),
                                      ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              ////Station Type
                              SearchField(
                                itemHeight: 50,
                                suggestionsDecoration: searchFieldDecoration(),
                                suggestions: stationTypes
                                    .map((StationType stationType) =>
                                        SearchFieldListItem(
                                            stationType.typeName!,
                                            item: stationType,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: ListTile(
                                                  title: Text(
                                                stationType.typeName!,
                                                overflow: TextOverflow.visible,
                                              )),
                                            )))
                                    .toList(),
                                validator: (station) {
                                  if (station!.isEmpty) {
                                    return "This field is required";
                                  }
                                  return null;
                                },
                                focusNode: stationTypeFocusNode,
                                searchInputDecoration:
                                    normalTextFieldStyle("Station Type *", "")
                                        .copyWith(
                                            suffixIcon: GestureDetector(
                                  onTap: () => stationTypeFocusNode.unfocus(),
                                  child: const Icon(Icons.arrow_drop_down),
                                )),
                                onSuggestionTap: (position) {
                                  setState(() {
                                    selectedStationType = position.item!;
                                    stationTypeFocusNode.unfocus();
                                  });
                                },
                                emptyWidget: EmptyWidget(
                                    title: "Add StationType",
                                    controller: addStationTypeController,
                                    onpressed: () {
                                      setState(() {
                                        StationType stationType = StationType(
                                            id: null,
                                            typeName:
                                                addStationTypeController.text,
                                            color: null,
                                            order: null,
                                            isActive: null,
                                            group: null);
                                        stationTypes.add(stationType);
                                        Navigator.pop(context);
                                      });
                                    }),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              ////Position title
                              FormBuilderDropdown(
                                decoration: normalTextFieldStyle(
                                    "Head Position", "Head Position"),
                                name: "head-position",
                                items: positions.map((e) {
                                  return DropdownMenuItem(
                                    value: e,
                                    child: Text(e.title!),
                                  );
                                }).toList(),
                                onChanged: (title) {
                                  selectedPositiontitle = title;
                                },
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              ////is within parent
                              FormBuilderSwitch(
                                initialValue: true,
                                activeColor: second,
                                onChanged: (value) {
                                  setState(() {
                                    isWithinParent = value!;
                                  });
                                },
                                decoration: normalTextFieldStyle(
                                    "Location of the station within this parent?",
                                    'Location of the station within this parent?'),
                                name: 'isWithinParent',
                                title: Text(isWithinParent ? "YES" : "NO"),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                //// Station Name
                                children: [
                                  Flexible(
                                    child: FormBuilderTextField(
                                        validator:
                                            FormBuilderValidators.required(
                                                errorText:
                                                    "This Field is required"),
                                        decoration: normalTextFieldStyle(
                                            "Station name", "Station name"),
                                        name: "station-name"),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  //// Acronym
                                  Flexible(
                                    child: FormBuilderTextField(
                                        validator:
                                            FormBuilderValidators.required(
                                                errorText:
                                                    "This Field is required"),
                                        decoration: normalTextFieldStyle(
                                            "Acronym", "Acronym"),
                                        name: "acronym"),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              FormBuilderTextField(
                                  ////Description
                                  decoration: normalTextFieldStyle(
                                      "Station description",
                                      "Station description"),
                                  name: "station-description"),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    ////Code
                                    child: FormBuilderTextField(
                                        decoration: normalTextFieldStyle(
                                            "Code", "Code"),
                                        name: "code"),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Flexible(
                                    //// Full Code
                                    child: FormBuilderTextField(
                                        decoration: normalTextFieldStyle(
                                            "Full Code", "Full Code"),
                                        name: "fullcode"),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              ////is Hospital
                              FormBuilderSwitch(
                                initialValue: isHospital,
                                activeColor: second,
                                onChanged: (value) {
                                  setState(() {
                                    isHospital = !isHospital;
                                  });
                                },
                                decoration:
                                    normalTextFieldStyle("Is Hospital", ''),
                                name: 'isHospital',
                                title: Text(isHospital == true ? "YES" : "NO"),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                      style: mainBtnStyle(
                                          primary, Colors.transparent, second),
                                      onPressed: () {
                                        RbacStation? newStation;
                                        if (formKey.currentState!
                                            .saveAndValidate()) {
                                          String? stationName = formKey
                                              .currentState!
                                              .value['station-name'];
                                          String? acronym = formKey
                                              .currentState!.value['acronym'];
                                          String? code = formKey
                                              .currentState!.value['code'];
                                          String? fullcode = formKey
                                              .currentState!.value['fullcode'];
                                          String? description = formKey
                                              .currentState!
                                              .value['station-description'];
                                          newStation = RbacStation(
                                              id: null,
                                              stationName: stationName,
                                              stationType: selectedStationType,
                                              hierarchyOrderNo:mainParent?1:
                                                  selectedParentStation!
                                                          .hierarchyOrderNo! +
                                                      1,
                                              headPosition:
                                                  selectedPositiontitle?.title,
                                              governmentAgency:
                                                  GovernmentAgency(
                                                      agencyid: int.tryParse(
                                                          agencyId),
                                                      agencyname: null,
                                                      agencycatid: null,
                                                      privateEntity: null,
                                                      contactinfoid: null),
                                              acronym: acronym,
                                              parentStation: mainParent?null:  selectedParentStation!.id!,
                                                
                                              code: code,
                                              fullcode: fullcode,
                                              childStationInfo: null,
                                              islocationUnderParent:
                                                  isWithinParent,
                                              mainParentStation:
                                                  mainParent?null:selectedMainParentStation!
                                                      .id!,
                                              description: description,
                                              ishospital: isHospital,
                                              isactive: true,
                                              sellingStation: null);
                                          Navigator.pop(context);
                                          estPointPersonBloc.add(
                                              AddEstPointPersonStation(
                                                  station: newStation));
                                        }
                                      },
                                      child: const Text("Add"))),
                            ],
                          );
                        }),
                      ),
                    ),
                  );
                });
          })
        ],
      ),
      body: LoadingProgress(

        child:
            BlocConsumer<EstPointPersonStationBloc, EstPointPersonStationState>(
          listener: (context, state) {
            if (state is EstPersonStationLoadingState) {
              final progress = ProgressHUD.of(context);
              progress!.showWithText("Please wait...");
            }
            if (state is EstPointPersonAddedState) {
              if (state.response['success']) {
                successAlert(
                    context, "Adding Successfull!", state.response['message'],
                    () {
                  Navigator.of(context).pop();
                  context.read<EstPointPersonStationBloc>().add(
                      EstPointPersonGetStations(agencyId: agencyId.toString()));
                });
              } else {
                errorAlert(context, "Adding Failed", state.response['message'],
                    () {
                  Navigator.of(context).pop();
                  context.read<EstPointPersonStationBloc>().add(
                      EstPointPersonGetStations(agencyId: agencyId.toString()));
                });
              }
            }
            if (state is EstPersonStationLoadedState ||
                state is EstPointPersonAddedState ||
                state is EstPersonStationErrorState) {
              final progress = ProgressHUD.of(context);
              progress!.dismiss();
            }
          },
          builder: (context, state) {
            final parent = context;
            if (state is EstPersonStationLoadedState) {
              stations = state.stations;
              stationTypes = state.stationTypes;
              positions = state.positions;
              int max = 0;
              for (RbacStation station in stations) {
                if (station.hierarchyOrderNo != null) {
                  if (max < station.hierarchyOrderNo!) {
                    max = station.hierarchyOrderNo!;
                  }
                }
              }
              for (int i = 1; i <= max; i++) {
                hierarchy.add({i: []});
              }
              for (var station in stations) {
                if (station.hierarchyOrderNo != null) {
                  for (int i = 0; i <= max; i++) {
                    if (station.hierarchyOrderNo == i + 1) {
                      hierarchy[i][i + 1].add(station);
                    }
                  }
                }
              }

              if (stations.isNotEmpty && hierarchy[0][1].isNotEmpty) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10),
                          itemCount: hierarchy[0][1].length,
                          itemBuilder: (BuildContext context, int index) {
                            List<RbacStation> second = [];
                           if(max >=2){
                             for (var rbacStation in hierarchy[1][2]) {
                              if (rbacStation.parentStation ==
                                  hierarchy[0][1][index].id) {
                                second.add(rbacStation);
                              }
                            }
                           }
                            return Column(
                              children: [
                                Container(
                                  width: screenWidth,
                                  decoration: box1(),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Row(
                                        children: [
                                          const CircleAvatar(
                                            child: Text('1'),
                                          ),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          Flexible(
                                            child: Text(
                                                hierarchy[0][1][index]
                                                    .stationName!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: primary)),
                                          ),
                                        ],
                                      )),
                                    ],
                                  ),
                                ),
                                ////SECOND
                                SizedBox(
                                    child: second.isNotEmpty
                                        ? Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: second.map((e) {
                                              List<RbacStation> childs = [];
                                              if (max >= 3) {
                                                for (RbacStation station
                                                    in hierarchy[2][3]) {
                                                  if (station.parentStation ==
                                                      e.id) {
                                                    childs.add(station);
                                                  }
                                                }
                                              } else {
                                                childs = [];
                                              }
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          width: screenWidth,
                                                          decoration: box1()
                                                              .copyWith(
                                                                  boxShadow: []),
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 30),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                  child: Row(
                                                                children: [
                                                                  Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              6),
                                                                      child:
                                                                          Text(
                                                                        "2",
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .bodyLarge,
                                                                        selectionColor:
                                                                            Colors.redAccent,
                                                                      )),
                                                                  const SizedBox(
                                                                    width: 12,
                                                                  ),
                                                                  Flexible(
                                                                    child: Text(
                                                                        e
                                                                            .stationName!,
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .titleMedium!
                                                                            .copyWith(
                                                                                fontWeight: FontWeight.w500,
                                                                                color: primary)),
                                                                  ),
                                                                ],
                                                              )),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  ////THIRD
                                                  SizedBox(
                                                      child: childs.isNotEmpty
                                                          ? Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: childs
                                                                  .map((e) {
                                                                List<RbacStation>
                                                                    childs = [];
                                                                if (max >= 4) {
                                                                  for (RbacStation station
                                                                      in hierarchy[
                                                                              3]
                                                                          [4]) {
                                                                    if (station
                                                                            .parentStation ==
                                                                        e.id) {
                                                                      childs.add(
                                                                          station);
                                                                    }
                                                                  }
                                                                } else {
                                                                  childs = [];
                                                                }
                                                                return Column(
                                                                  children: [
                                                                    Container(
                                                                      width:
                                                                          screenWidth,
                                                                      decoration:
                                                                          box1()
                                                                              .copyWith(boxShadow: []),
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              50),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Expanded(
                                                                              child: Row(
                                                                            children: [
                                                                              Padding(
                                                                                  padding: const EdgeInsets.all(6),
                                                                                  child: Text(
                                                                                    "3",
                                                                                    style: Theme.of(context).textTheme.bodyLarge,
                                                                                    selectionColor: Colors.redAccent,
                                                                                  )),
                                                                              const SizedBox(
                                                                                width: 12,
                                                                              ),
                                                                              Flexible(
                                                                                child: Text(e.stationName!, style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500, color: primary)),
                                                                              ),
                                                                            ],
                                                                          )),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    ////Fourth
                                                                    SizedBox(
                                                                        child: childs.isNotEmpty
                                                                            ? Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: childs.map((e) {
                                                                                  List<RbacStation> childs = [];
                                                                                  if (max > 4) {
                                                                                    for (RbacStation station in hierarchy[4][5]) {
                                                                                      if (station.parentStation == e.id) {
                                                                                        childs.add(station);
                                                                                      }
                                                                                    }
                                                                                  } else {
                                                                                    childs = [];
                                                                                  }
                                                                                  return Column(
                                                                                    children: [
                                                                                      Container(
                                                                                        width: screenWidth,
                                                                                        decoration: box1().copyWith(boxShadow: []),
                                                                                        padding: const EdgeInsets.only(left: 80),
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Expanded(
                                                                                                child: Row(
                                                                                              children: [
                                                                                                Padding(
                                                                                                    padding: const EdgeInsets.all(6),
                                                                                                    child: Text(
                                                                                                      "4",
                                                                                                      style: Theme.of(context).textTheme.bodyLarge,
                                                                                                      selectionColor: Colors.redAccent,
                                                                                                    )),
                                                                                                const SizedBox(
                                                                                                  width: 12,
                                                                                                ),
                                                                                                Flexible(
                                                                                                  child: Text(e.stationName!, style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500, color: primary)),
                                                                                                ),
                                                                                              ],
                                                                                            )),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      ////Fifth
                                                                                      SizedBox(
                                                                                          child: childs.isNotEmpty
                                                                                              ? Column(
                                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                                  children: childs.map((e) {
                                                                                                    List<RbacStation> childs = [];
                                                                                                    if (max > 5) {
                                                                                                      for (RbacStation station in hierarchy[5][6]) {
                                                                                                        if (station.parentStation == e.id) {
                                                                                                          childs.add(station);
                                                                                                        }
                                                                                                      }
                                                                                                    } else {
                                                                                                      childs = [];
                                                                                                    }

                                                                                                    return Column(
                                                                                                      children: [
                                                                                                        Container(
                                                                                                          width: screenWidth,
                                                                                                          decoration: box1(),
                                                                                                          padding: const EdgeInsets.only(left: 80),
                                                                                                          child: Row(
                                                                                                            children: [
                                                                                                              Expanded(
                                                                                                                  child: Row(
                                                                                                                children: [
                                                                                                                  const CircleAvatar(
                                                                                                                    child: Text('5'),
                                                                                                                  ),
                                                                                                                  const SizedBox(
                                                                                                                    width: 12,
                                                                                                                  ),
                                                                                                                  Flexible(
                                                                                                                    child: Text(e.stationName!, style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500, color: primary)),
                                                                                                                  ),
                                                                                                                ],
                                                                                                              )),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    );
                                                                                                  }).toList(),
                                                                                                )
                                                                                              : const SizedBox()),
                                                                                    ],
                                                                                  );
                                                                                }).toList(),
                                                                              )
                                                                            : const SizedBox()),
                                                                  ],
                                                                );
                                                              }).toList(),
                                                            )
                                                          : const SizedBox
                                                              .shrink()),
                                                ],
                                              );
                                            }).toList(),
                                          )
                                        : const SizedBox()),
                                const Divider(
                                  height: 5,
                                ),
                              ],
                            );
                          }),
                    ),
                  ],
                );
              } else {
                return const EmptyData(
                    message: "No Station available. Please click + to add.");
              }
            }
            if (state is EstPersonStationErrorState) {
              return SomethingWentWrong(
                  message: state.message,
                  onpressed: () {
                    context.read<EstPointPersonStationBloc>().add(EstPointPersonGetStations(agencyId: agencyId));
                  });
            }

            return Container();
          },
        ),
      ),
    );
  }
}
