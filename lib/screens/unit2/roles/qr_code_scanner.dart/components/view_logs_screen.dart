
import 'package:data_table_2/data_table_2.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/svg.dart';
import 'package:unit2/bloc/role/pass_check/pass_check_bloc.dart';
import 'package:unit2/bloc/user/user_bloc.dart';
import 'package:unit2/theme-data.dart/btn-style.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/theme-data.dart/form-style.dart';
import 'package:unit2/utils/global.dart';
import 'package:unit2/widgets/empty_data.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';

class PassCheckLogs extends StatelessWidget {
  const PassCheckLogs({super.key});

  @override
  Widget build(BuildContext context) {
    String? startDate;
    String? endDate;
    int? checkerId;
    String? passerLname;
    String? passerFname;
    final bloc = BlocProvider.of<PassCheckBloc>(context);
    final formKey = GlobalKey<FormBuilderState>();
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
          backgroundColor: primary,
          centerTitle: true,
          title: const Text("Pass Check Logs"),
          actions: context.watch<PassCheckBloc>().state
                      is PassCheckLoadingState ||
                  context.watch<PassCheckBloc>().state is PassCheckErrorState
              ? []
              : context.watch<PassCheckBloc>().state is TodayEmptyPassCheckLogs
                  ? [
                      IconButton(
                          onPressed: () {
                            passerFname = null;
                            passerLname = null;
                            startDate = null;
                            endDate = null;
                            showModalBottomSheet(
                          
                                isScrollControlled: true,
                                context: context,
                                builder: ((context) {
                                  return Padding(
                       padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                                    child: FormBuilder(
                                        key: formKey,
                                        child: Padding(
                                          padding: const EdgeInsets.all(24),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: screenWidth,
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Flexible(
                                                        child: Text(
                                                      "Filter Logs",
                                                      style: TextStyle(
                                                          color: primary),
                                                    )),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Flexible(
                                                        child: Icon(
                                                      Icons.sort,
                                                      color: primary,
                                                    )),
                                                  ],
                                                ),
                                              ),
                                              const Divider(),
                                              const SizedBox(
                                                height: 24,
                                              ),
                                              const Text("Passer Information"),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              SizedBox(
                                                width: screenWidth,
                                                child: Row(
                                                  children: [
                                                    Flexible(
                                                        child:
                                                            FormBuilderTextField(
                                                      decoration:
                                                          normalTextFieldStyle(
                                                              'first name',
                                                              'given name'),
                                                      name: "passer_given_name",
                                                      onChanged: ((value) {
                                                        passerFname = value;
                                                      }),
                                                      validator: ((value) {
                                                        if (passerLname != null &&
                                                            passerFname == null) {
                                                          return "Please input Passer first name";
                                                        }
                                                        return null;
                                                      }),
                                                    )),
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    Flexible(
                                                      child: FormBuilderTextField(
                                                        decoration:
                                                            normalTextFieldStyle(
                                                                'last name',
                                                                'last name'),
                                                        name: "passer_last_name",
                                                        onChanged: (value) {
                                                          passerLname = value;
                                                        },
                                                        validator: ((value) {
                                                          if (passerFname !=
                                                                  null &&
                                                              passerLname ==
                                                                  null) {
                                                            return "Please input Passer last name";
                                                          }
                                                          return null;
                                                        }),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              const Text(
                                                  " Start date and End date"),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              SizedBox(
                                                  width: screenWidth,
                                                  child: Row(
                                                    children: [
                                                      ////Start DATE
                                                      Flexible(
                                                          flex: 1,
                                                          child: DateTimePicker(
                                                            use24HourFormat:
                                                                false,
                                                            icon: const Icon(
                                                                Icons.date_range),
                                                            firstDate:
                                                                DateTime(1990),
                                                            lastDate:
                                                                DateTime(2100),
                                                            timeHintText:
                                                                "start date",
                                                            decoration: normalTextFieldStyle(
                                                                    "start date",
                                                                    "")
                                                                .copyWith(
                                                                    prefixIcon:
                                                                        const Icon(
                                                              Icons.date_range,
                                                              color:
                                                                  Colors.black87,
                                                            )),
                                                            initialDate:
                                                                DateTime.now(),
                                                            onChanged: (value) {
                                                              startDate = value;
                                                            },
                                                            validator: ((value) {
                                                              if (endDate !=
                                                                      null &&
                                                                  startDate ==
                                                                      null) {
                                                                return "Please input Passer start date";
                                                              }
                                                              return null;
                                                            }),
                                                          )),
                                                      const SizedBox(
                                                        width: 8,
                                                      ),
                                                      ////End DATE
                                                      Flexible(
                                                        flex: 1,
                                                        child: DateTimePicker(
                                                          firstDate:
                                                              DateTime(1970),
                                                          lastDate:
                                                              DateTime(2100),
                                                          decoration:
                                                              normalTextFieldStyle(
                                                                      "end date",
                                                                      "end date")
                                                                  .copyWith(
                                                                      prefixIcon:
                                                                          const Icon(
                                                            Icons.date_range,
                                                            color: Colors.black87,
                                                          )),
                                                          onChanged: (value) {
                                                            endDate = value;
                                                          },
                                                          validator: ((value) {
                                                            if (startDate !=
                                                                    null &&
                                                                endDate == null) {
                                                              return "Please input Passer end date";
                                                            }
                                                            return null;
                                                          }),
                                                          initialDate:
                                                              DateTime.now(),
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                              const SizedBox(
                                                height: 50,
                                              ),
                                              Center(
                                                child: SizedBox(
                                                  width: 200,
                                                  height: 50,
                                                  child: ElevatedButton(
                                                    style: mainBtnStyle(
                                                        primary,
                                                        Colors.transparent,
                                                        second),
                                                    child: const Text("Submit"),
                                                    onPressed: () {
                                                      if (formKey.currentState!
                                                          .saveAndValidate()) {
                                                        Navigator.pop(context);
                                                                            
                                                        bloc.add(FilterLogs(
                                                            endDate: endDate,
                                                            startDate: startDate,
                                                            passerLastName:
                                                                passerLname,
                                                            passerName:
                                                                passerFname,
                                                            webUserId:
                                                                checkerId!));
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 32,
                                              ),
                                            ],
                                          ),
                                        )),
                                  );
                                }));
                          },
                          icon: const Icon(Icons.sort)),
                    ]
                  : context.watch<PassCheckBloc>().state
                              is PassCheckLogsLoaded ||
                          context.watch<PassCheckBloc>().state
                              is FilterEmptyLogs
                      ? [
                          IconButton(
                              onPressed: () {
                                passerFname = null;
                                passerLname = null;
                                startDate = null;
                                endDate = null;
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: ((context) {
                                      return Container(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom,
                                            left: 24,
                                            right: 24,
                                            top: 24),
                                        width: screenWidth,
                                        child: FormBuilder(
                                            key: formKey,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: screenWidth,
                                                    child: const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Flexible(
                                                            child: Text(
                                                          "Filter Logs",
                                                          style: TextStyle(
                                                              color: primary),
                                                        )),
                                                        SizedBox(
                                                          width: 8,
                                                        ),
                                                        Flexible(
                                                            child: Icon(
                                                          Icons.sort,
                                                          color: primary,
                                                        )),
                                                      ],
                                                    ),
                                                  ),
                                                  const Divider(),
                                                  const SizedBox(
                                                    height: 24,
                                                  ),
                                                  const Text(
                                                      "Passer Information"),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  SizedBox(
                                                    width: screenWidth,
                                                    child: Row(
                                                      children: [
                                                        Flexible(
                                                            child:
                                                                FormBuilderTextField(
                                                          decoration:
                                                              normalTextFieldStyle(
                                                                  'first name',
                                                                  'given name'),
                                                          name:
                                                              "passer_given_name",
                                                          onChanged: ((value) {
                                                            passerFname = value;
                                                          }),
                                                        )),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Flexible(
                                                          child:
                                                              FormBuilderTextField(
                                                            decoration:
                                                                normalTextFieldStyle(
                                                                    'last name',
                                                                    'last name'),
                                                            name:
                                                                "passer_last_name",
                                                            onChanged: (value) {
                                                              passerLname = value;
                                                            },
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 12,
                                                  ),
                                                  const Text(
                                                      " Start date and End date"),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  SizedBox(
                                                      width: screenWidth,
                                                      child: Row(
                                                        children: [
                                                          ////Start DATE
                                                          Flexible(
                                                              flex: 1,
                                                              child:
                                                                  DateTimePicker(
                                                                use24HourFormat:
                                                                    false,
                                                                icon: const Icon(
                                                                    Icons
                                                                        .date_range),
                                                                firstDate:
                                                                    DateTime(
                                                                        1990),
                                                                lastDate:
                                                                    DateTime(
                                                                        2100),
                                                                timeHintText:
                                                                    "start date",
                                                                decoration: normalTextFieldStyle(
                                                                        "start date",
                                                                        "")
                                                                    .copyWith(
                                                                        prefixIcon:
                                                                            const Icon(
                                                                  Icons
                                                                      .date_range,
                                                                  color: Colors
                                                                      .black87,
                                                                )),
                                                                initialDate:
                                                                    DateTime
                                                                        .now(),
                                                                onChanged:
                                                                    (value) {
                                                                  startDate =
                                                                      value;
                                                                },
                                                              )),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          ////End DATE
                                                          Flexible(
                                                            flex: 1,
                                                            child: DateTimePicker(
                                                              firstDate:
                                                                  DateTime(1970),
                                                              lastDate:
                                                                  DateTime(2100),
                                                              decoration: normalTextFieldStyle(
                                                                      "end date",
                                                                      "end date")
                                                                  .copyWith(
                                                                      prefixIcon:
                                                                          const Icon(
                                                                Icons.date_range,
                                                                color: Colors
                                                                    .black87,
                                                              )),
                                                              onChanged: (value) {
                                                                endDate = value;
                                                              },
                                                              initialDate:
                                                                  DateTime.now(),
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                  const SizedBox(
                                                    height: 50,
                                                  ),
                                                  Center(
                                                    child: SizedBox(
                                                      width: 200,
                                                      height: 50,
                                                      child: ElevatedButton(
                                                        style: mainBtnStyle(
                                                            primary,
                                                            Colors.transparent,
                                                            second),
                                                        child:
                                                            const Text("Submit"),
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                            
                                                          bloc.add(FilterLogs(
                                                              endDate: endDate,
                                                              startDate:
                                                                  startDate,
                                                              passerLastName:
                                                                  passerLname,
                                                              passerName:
                                                                  passerFname,
                                                              webUserId:
                                                                  checkerId!));
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 32,
                                                  ),
                                                ],
                                              ),
                                            )),
                                      );
                                    }));
                              },
                              icon: const Icon(Icons.sort)),
                          IconButton(
                              onPressed: () {
                                context.read<PassCheckBloc>().add(ShareLogs(webUserId: checkerId!));
                              },
                              icon: const Icon(Icons.share))
                        ]
                      : []),
      body: LoadingProgress(

        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoggedIn) {
              checkerId = state.userData!.user!.login!.user!.id;
              return BlocConsumer<PassCheckBloc, PassCheckState>(
                listener: (context, state) {
                  if (state is PassCheckLoadingState) {
                    final progress = ProgressHUD.of(context);
                    progress!.showWithText("Please wait...");
                  }
                  if (state is PassCheckLogsLoaded ||
                      state is PassCheckErrorState ||
                      state is ErrorFilterLogs ||
                      state is TodayEmptyPassCheckLogs ||
                      state is FilterEmptyLogs) {
                    final progress = ProgressHUD.of(context);
                    progress!.dismiss();
                  }
                },
                builder: (context, state) {
                  if (state is PassCheckLogsLoaded) {
                    if (state.logs.isNotEmpty) {
                      return PaginatedDataTable2(
                          availableRowsPerPage: const <int>[
                            defaultRowsPerPage,
                            defaultRowsPerPage * 2,
                            defaultRowsPerPage * 5,
                            defaultRowsPerPage * 15
                          ],
                          dividerThickness: 1,
                          sortArrowAlwaysVisible: true,
                          renderEmptyRowsInTheEnd: false,
                          // headingRowColor:
                          //     MaterialStateProperty.all<Color>(Colors.black87),
                          rowsPerPage: 15,
                          dataRowHeight: 50,
                          columnSpacing: 0,
                          minWidth: 900,
                          headingTextStyle: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(color: Colors.black),
                          columns: const [
                            DataColumn2(
                                fixedWidth: 30,
                                label: Center(
                                    child: Text(
                                  "No. ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ))),
                            DataColumn2(
                                fixedWidth: 180,
                                label: Center(
                                    child: Text("Passer ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)))),
                            DataColumn2(
                                fixedWidth: 70,
                                label: Center(
                                    child: Text("In/Out ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)))),
                            DataColumn2(
                                fixedWidth: 220,
                                label: Center(
                                    child: Text("Time Check",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)))),
                            DataColumn2(
                                fixedWidth: 140,
                                label: Center(
                                    child: Text("Area",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)))),
                            DataColumn2(
                                fixedWidth: 150,
                                label: Center(
                                    child: Text("Scanner",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)))),
                          ],
                          source: state.dataTableSource);
                    }
                  }
                  if (state is TodayEmptyPassCheckLogs) {
                    return const EmptyData(message: "Empty Logs for Today");
                  }
                  if (state is FilterEmptyLogs) {
                    return SizedBox(
                      width: screenWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/svgs/empty.svg',
                            height: 200.0,
                            width: 200.0,
                            allowDrawingOutsideViewBox: true,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Empty Logs",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            child: state.fname != null
                                ? Text(
                                    "Passer name : "
                                    "${state.fname?.toUpperCase()} ${state.lname?.toUpperCase()}",
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  )
                                : const SizedBox(),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            child: state.startDate != null &&
                                    state.endDate != null
                                ? Text(
                                    "Start date : ${state.startDate} | End date: ${state.endDate}",
                                    style:
                                        Theme.of(context).textTheme.labelLarge)
                                : const SizedBox(),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is PassCheckErrorState) {
                    return SomethingWentWrong(
                        message: state.message,
                        onpressed: () {
                          bloc.add(ViewPassCheckLogs(webUserId: checkerId!));
                        });
                  }
                  if (state is ErrorFilterLogs) {
                    return SomethingWentWrong(
                        message: state.message,
                        onpressed: () {
                          bloc.add(FilterLogs(
                              endDate: state.endDate,
                              startDate: state.startDate,
                              passerLastName: state.lname,
                              passerName: state.fname,
                              webUserId: checkerId!));
                        });
                  }
                  return Container();
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
