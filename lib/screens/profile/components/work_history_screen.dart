import 'package:animate_do/animate_do.dart';
import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:unit2/bloc/profile/profile_bloc.dart';
import 'package:unit2/bloc/user/user_bloc.dart';
import 'package:unit2/model/profile/work_history.dart';
import 'package:unit2/screens/profile/components/work_history/add_modal.dart';
import 'package:unit2/screens/profile/components/work_history/edit_modal.dart';
import 'package:unit2/screens/profile/components/work_history/work_history_view_attachment.dart';
import 'package:unit2/theme-data.dart/box_shadow.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/utils/text_container.dart';
import 'package:unit2/widgets/Leadings/add_leading.dart';
import 'package:unit2/widgets/Leadings/close_leading.dart';
import 'package:unit2/widgets/empty_data.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';
import 'package:unit2/widgets/titlesubtitle.dart';
import '../../../bloc/profile/workHistory/workHistory_bloc.dart';
import '../../../model/profile/attachment.dart';
import '../../../theme-data.dart/btn-style.dart';
import '../../../theme-data.dart/form-style.dart';
import '../../../utils/alerts.dart';
import '../../../utils/global.dart';
import '../shared/multiple_attachment.dart';
import '../shared/single_attachment.dart';

class WorkHistoryScreen extends StatelessWidget {
  const WorkHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DateFormat dteFormat2 = DateFormat.yMMMMd('en_US');

    BuildContext parent = context;
    String? token;
    int? profileId;
    List<PlatformFile>? results = [];
    AttachmentCategory? selectedAttachmentCategory;
    List<AttachmentCategory> attachmentCategories = [];
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: context.watch<WorkHistoryBloc>().state is AddWorkHistoryState
              ? const FittedBox(child: Text("Add Work History"))
              : context.watch<WorkHistoryBloc>().state is EditWorkHistoryState
                  ? const FittedBox(
                      child: Text("Edit Work History"),
                    )
                  : const Text(workHistoryScreenTitle),
          backgroundColor: primary,
          centerTitle: true,
          actions: context.watch<WorkHistoryBloc>().state is WorkHistoryLoaded
              ? [
                  AddLeading(onPressed: () {
                    context
                        .read<WorkHistoryBloc>()
                        .add(ShowAddWorkHistoryForm());
                  })
                ]
              : (context.watch<WorkHistoryBloc>().state
                          is AddWorkHistoryState ||
                      context.watch<WorkHistoryBloc>().state
                          is EditWorkHistoryState)
                  ? [
                      CloseLeading(onPressed: () {
                        context
                            .read<WorkHistoryBloc>()
                            .add(LoadWorkHistories());
                      })
                    ]
                  : [],
        ),
        body:
            //UserBloc
            LoadingProgress(
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoggedIn) {
                token = state.userData!.user!.login!.token;
                profileId = state.userData!.user!.login!.user!.profileId!;
                return BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    //ProfileBloc
                    if (state is ProfileLoaded) {
                      //WorkHistoryBloc
                      return BlocConsumer<WorkHistoryBloc, WorkHistoryState>(
                        listener: (context, state) {
                          if (state is WorkHistoryLoadingState) {
                            final progress = ProgressHUD.of(context);
                            progress!.showWithText("Please wait...");
                          }
                          if (state is WorkHistoryLoaded ||
                              state is WorkHistoryErrorState ||
                              state is AddWorkHistoryState ||
                              state is WorkHistoryAddedState ||
                              state is ShowEditFormErrorState ||
                              state is EditWorkHistoryState ||
                              state is ErrorDeleteWorkHistoryAttachment ||
                              state is ShowAddFormErrorState ||
                              state is AddAttachmentError ||
                              state is ErrorDeleteWorkHistory || state is ErrorAddWorkHistory || state is ErrorUpdateWorkHistory) {
                            final progress = ProgressHUD.of(context);
                            progress!.dismiss();
                          }
                          ////DELETED STATE
                          if (state is DeletedState) {
                            if (state.success) {
                              successAlert(context, "Deletion Successfull",
                                  "Work has been deleted successfully", () {
                                Navigator.of(context).pop();
                                context
                                    .read<WorkHistoryBloc>()
                                    .add(LoadWorkHistories());
                              });
                            } else {
                              errorAlert(context, "Deletion Failed",
                                  "Error deleting Work History", () {
                                Navigator.of(context).pop();
                                context
                                    .read<WorkHistoryBloc>()
                                    .add(LoadWorkHistories());
                              });
                            }
                          }
                          ////ADDED STATE
                          if (state is WorkHistoryAddedState) {
                            if (state.response['success']) {
                              successAlert(context, "Adding Successfull!",
                                  state.response['message'], () {
                                Navigator.of(context).pop();
                                context
                                    .read<WorkHistoryBloc>()
                                    .add(LoadWorkHistories());
                              });
                            } else {
                              errorAlert(context, "Adding Failed",
                                  "Something went wrong. Please try again.",
                                  () {
                                Navigator.of(context).pop();
                                context
                                    .read<WorkHistoryBloc>()
                                    .add(LoadWorkHistories());
                              });
                            }
                          }
                          if (state is WorkHistoryDevAttachmentAddedState) {
                            if (state.response['success']) {
                              successAlert(context, "Adding Successfull!",
                                  state.response['message'], () {
                                Navigator.of(context).pop();
                                context
                                    .read<WorkHistoryBloc>()
                                    .add(LoadWorkHistories());
                              });
                            } else {
                              errorAlert(context, "Adding Failed",
                                  "Something went wrong. Please try again.",
                                  () {
                                Navigator.of(context).pop();
                                context
                                    .read<WorkHistoryBloc>()
                                    .add(LoadWorkHistories());
                              });
                            }
                          }
                          ////ATTACHMENT DELETED STATE
                          if (state is WorkHistoryDevAttachmentDeletedState) {
                            if (state.success) {
                              successAlert(context, "Deletion Successfull",
                                  "Attachment has been deleted successfully",
                                  () {
                                Navigator.of(context).pop();
                                context
                                    .read<WorkHistoryBloc>()
                                    .add(LoadWorkHistories());
                              });
                            } else {
                              errorAlert(context, "Deletion Failed",
                                  "Error deleting Attachment", () {
                                Navigator.of(context).pop();
                                context
                                    .read<WorkHistoryBloc>()
                                    .add(LoadWorkHistories());
                              });
                            }
                          }

                          //// EDITED STATE
                          if (state is WorkHistoryEditedState) {
                            if (state.response['success']) {
                              successAlert(context, "Update Successfull!",
                                  state.response['message'], () {
                                Navigator.of(context).pop();
                                context
                                    .read<WorkHistoryBloc>()
                                    .add(LoadWorkHistories());
                              });
                            } else {
                              errorAlert(context, "Update Failed",
                                  "Something went wrong. Please try again.",
                                  () {
                                Navigator.of(context).pop();
                                context
                                    .read<WorkHistoryBloc>()
                                    .add(LoadWorkHistories());
                              });
                            }
                          }
                        },
                        builder: (context, state) {
                          if (state is WorkHistoryLoaded) {
                            for (var cat in state.attachmentCategory) {
                              if (cat.subclass!.id == 4) {
                                attachmentCategories.add(cat);
                              }
                            }
                            if (state.workExperiences.isNotEmpty) {
                              return ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 10),
                                  itemCount: state.workExperiences.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    String position = state
                                        .workExperiences[index]
                                        .position!
                                        .title!;
                                    String agency = state
                                        .workExperiences[index].agency!.name!;
                                    String from = dteFormat2.format(
                                        state.workExperiences[index].fromDate!);
                                    String? to =
                                        state.workExperiences[index].toDate ==
                                                null
                                            ? present.toUpperCase()
                                            : dteFormat2.format(state
                                                .workExperiences[index]
                                                .toDate!);
                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration: const Duration(milliseconds: 500),
                                      child: FlipAnimation(
                                        child: Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return ZoomIn(
                                                        child: AlertDialog(
                                                          title: const Column(
                                                            children: [
                                                              Icon(
                                                                FontAwesome5
                                                                    .shopping_bag,
                                                                color: primary,
                                                                size: 32,
                                                              ),
                                                              Text(
                                                                "Work History Details",
                                                                style: TextStyle(
                                                                    color: primary,
                                                                    fontSize: 18),
                                                              ),
                                                              Divider(),
                                                            ],
                                                          ),
                                                          content: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize.min,
                                                              children: [
                                                                TitleSubtitle(
                                                                  title: state
                                                                      .workExperiences[
                                                                          index]
                                                                      .position!
                                                                      .title!,
                                                                  sub: "Position",
                                                                ),
                                                                const Gap(3),
                                                                TitleSubtitle(
                                                                  title: state
                                                                      .workExperiences[
                                                                          index]
                                                                      .statusAppointment!,
                                                                  sub:
                                                                      "Appointment Status",
                                                                ),
                                                                const Gap(3),
                                                                TitleSubtitle(
                                                                  title: state
                                                                      .workExperiences[
                                                                          index]
                                                                      .agency!
                                                                      .name!,
                                                                  sub: "Agency",
                                                                ),
                                                                const Gap(3),
                                                                TitleSubtitle(
                                                                  title: state
                                                                      .workExperiences[
                                                                          index]
                                                                      .monthlysalary
                                                                      .toString(),
                                                                  sub:
                                                                      "Monthly Salary",
                                                                ),
                                                                const Gap(3),
                                                                TitleSubtitle(
                                                                    title: state
                                                                                .workExperiences[
                                                                                    index]
                                                                                .toDate ==
                                                                            null
                                                                        ? "YES"
                                                                        : "NO",
                                                                    sub:
                                                                        "Currently Employed"),
                                                                const Gap(3),
                                                                TitleSubtitle(
                                                                    title: dteFormat2
                                                                        .format(state
                                                                            .workExperiences[
                                                                                index]
                                                                            .fromDate!),
                                                                    sub:
                                                                        "Start Date"),
                                                                SizedBox(
                                                                  child: state
                                                                              .workExperiences[
                                                                                  index]
                                                                              .toDate !=
                                                                          null
                                                                      ? Column(
                                                                          children: [
                                                                            const Gap(
                                                                                3),
                                                                            TitleSubtitle(
                                                                                title: dteFormat2.format(state
                                                                                    .workExperiences[index]
                                                                                    .toDate!),
                                                                                sub: "End Date")
                                                                          ],
                                                                        )
                                                                      : const SizedBox(),
                                                                ),
                                                                const Gap(10),
                                                                const Text(
                                                                    "Immediate Supervisor"),
                                                                const Gap(3),
                                                                TitleSubtitle(
                                                                  title:
                                                                      "${state.workExperiences[index].supervisor?.firstname ?? "N/A"} ${state.workExperiences[index].supervisor?.lastname ?? ""}",
                                                                  sub:
                                                                      "Supervisor full name",
                                                                ),
                                                                const Gap(3),
                                                                TitleSubtitle(
                                                                  title: state
                                                                          .workExperiences[
                                                                              index]
                                                                          .supervisor
                                                                          ?.stationName ??
                                                                      "N/A",
                                                                  sub:
                                                                      "Name of office/Unit",
                                                                ),
                                                                const Gap(10),
                                                                const Text(
                                                                    "Work History"),
                                                                const Gap(3),
                                                              ]),
                                                        ),
                                                      );
                                                    });
                                              },
                                              child: Container(
                                                decoration: box1(),
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 12, vertical: 8),
                                                child: Column(
                                                  children: [
                                                    Row(children: [
                                                      Expanded(
                                                          child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            position,
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .titleMedium!
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: primary),
                                                          ),
                                                          const SizedBox(
                                                            height: 8,
                                                          ),
                                                          Text(
                                                            agency,
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .titleSmall!
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            "$from - $to ",
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .labelMedium,
                                                          ),
                                                        ],
                                                      )),
                                                      AppPopupMenu<int>(
                                                        offset:
                                                            const Offset(-10, -10),
                                                        elevation: 3,
                                                        onSelected: (value) {
                                                          ////delete workhistory-= = = = = = = = =>>
                                                          if (value == 2) {
                                                            confirmAlert(context,
                                                                () {
                                                              BlocProvider.of<
                                                                          WorkHistoryBloc>(
                                                                      context)
                                                                  .add(
                                                                      DeleteWorkHistory(
                                                                profileId:
                                                                    profileId!,
                                                                token: token!,
                                                                workHistory: state
                                                                        .workExperiences[
                                                                    index],
                                                              ));
                                                            }, "Delete?",
                                                                "Confirm Delete?");
                                                          }
                                                          if (value == 1) {
                                                            ////edit eligibilty-= = = = = = = = =>>
                                        
                                                            WorkHistory
                                                                workHistory =
                                                                state.workExperiences[
                                                                    index];
                                                            context
                                                                .read<
                                                                    WorkHistoryBloc>()
                                                                .add(ShowEditWorkHistoryForm(
                                                                    workHistory:
                                                                        workHistory));
                                                          }
                                                          ////Attachment
                                                          if (value == 3) {
                                                            results.clear();
                                                            showDialog(
                                                                context: context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return ZoomIn(
                                                                    child: AlertDialog(
                                                                      contentPadding:
                                                                          const EdgeInsets
                                                                              .all(0),
                                                                      backgroundColor:
                                                                          Colors.grey
                                                                              .shade100,
                                                                      icon:
                                                                          const Icon(
                                                                        Icons
                                                                            .file_copy,
                                                                        size: 32,
                                                                        color:
                                                                            primary,
                                                                      ),
                                                                      title: const Text(
                                                                          "File Attachment:"),
                                                                      content: StatefulBuilder(
                                                                          builder:
                                                                              (context,
                                                                                  setState) {
                                                                        return Padding(
                                                                          padding:
                                                                              const EdgeInsets
                                                                                  .all(
                                                                                  16.0),
                                                                          child: Column(
                                                                              mainAxisSize:
                                                                                  MainAxisSize
                                                                                      .min,
                                                                              mainAxisAlignment:
                                                                                  MainAxisAlignment
                                                                                      .start,
                                                                              crossAxisAlignment:
                                                                                  CrossAxisAlignment.start,
                                                                              children: [
                                                                                const Divider(),
                                                                                Text(
                                                                                  position,
                                                                                  style:
                                                                                      Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600, color: primary),
                                                                                ),
                                                                                const SizedBox(
                                                                                  height:
                                                                                      8,
                                                                                ),
                                                                                Text(
                                                                                  agency,
                                                                                  style:
                                                                                      Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w500),
                                                                                ),
                                                                                const SizedBox(
                                                                                  height:
                                                                                      5,
                                                                                ),
                                                                                Text(
                                                                                  "$from - $to ",
                                                                                  style:
                                                                                      Theme.of(context).textTheme.labelMedium,
                                                                                ),
                                                                                const Divider(),
                                                                                FormBuilderDropdown(
                                                                                    autovalidateMode: AutovalidateMode.always,
                                                                                    decoration: normalTextFieldStyle("attachment category", "attachment category"),
                                                                                    name: 'attachments_categorues',
                                                                                    validator: FormBuilderValidators.required(errorText: "This field is required"),
                                                                                    onChanged: (value) {
                                                                                      selectedAttachmentCategory = value;
                                                                                    },
                                                                                    items: attachmentCategories.map((e) {
                                                                                      return DropdownMenuItem(value: e, child: Text(e.description!));
                                                                                    }).toList()),
                                                                                const SizedBox(
                                                                                  height:
                                                                                      8,
                                                                                ),
                                                                                Text(
                                                                                  "You may attach necessary documents such as Transcript of Records (TOR), diploma, and the likes.",
                                                                                  style:
                                                                                      Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black),
                                                                                ),
                                                                                const SizedBox(
                                                                                  height:
                                                                                      5,
                                                                                ),
                                                                                Text(
                                                                                  "Acceptable Files: PDF, JPEG, PNG",
                                                                                  style:
                                                                                      Theme.of(context).textTheme.bodySmall,
                                                                                ),
                                                                                Text(
                                                                                  "Max File Size (per attachment): 1MB",
                                                                                  style:
                                                                                      Theme.of(context).textTheme.bodySmall,
                                                                                ),
                                                                                const Divider(),
                                                                                ElevatedButton(
                                                                                    style: ButtonStyle(
                                                                                      elevation: MaterialStateProperty.all(0),
                                                                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                                                    ),
                                                                                    onPressed: () async {
                                                                                      FilePickerResult? newResult = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.custom, allowedExtensions: [
                                                                                        'jpg',
                                                                                        'png',
                                                                                        'jpeg',
                                                                                        'pdf'
                                                                                      ]);
                                                                                      setState(() {
                                                                                        if (newResult != null) {
                                                                                          for (var element in newResult.files) {
                                                                                            results.add(element);
                                                                                          }
                                                                                        }
                                                                                      });
                                                                                    },
                                                                                    child: const Center(
                                                                                        child: Text(
                                                                                      "Select Files",
                                                                                      textAlign: TextAlign.center,
                                                                                      style: TextStyle(color: Colors.black),
                                                                                    ))),
                                                                                const Divider(),
                                                                                SingleChildScrollView(
                                                                                  child:
                                                                                      SizedBox(
                                                                                    height: 100,
                                                                                    width: double.maxFinite,
                                                                                    child: results.isEmpty
                                                                                        ? const SizedBox()
                                                                                        : ListView.builder(
                                                                                            itemCount: results.length,
                                                                                            itemBuilder: (BuildContext context, index) {
                                                                                              final kb = results[index].size / 1024;
                                                                                              final mb = kb / 1024;
                                                                                              final size = mb >= 1 ? '${mb.toStringAsFixed(2)}MB' : '${kb.toStringAsFixed(2)}KB';
                                                                                              return Column(
                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                children: [
                                                                                                  SizedBox(
                                                                                                      width: double.infinity,
                                                                                                      child: Row(
                                                                                                        children: [
                                                                                                          Flexible(
                                                                                                              child: SizedBox(
                                                                                                                  child: results[index].extension!.toLowerCase() == 'pdf'
                                                                                                                      ? SvgPicture.asset(
                                                                                                                          'assets/svgs/pdf.svg',
                                                                                                                          height: blockSizeVertical * 3,
                                                                                                                          allowDrawingOutsideViewBox: true,
                                                                                                                        )
                                                                                                                      : results[index].extension!.toLowerCase() == 'png'
                                                                                                                          ? SvgPicture.asset(
                                                                                                                              'assets/svgs/png.svg',
                                                                                                                              height: blockSizeVertical * 3,
                                                                                                                              allowDrawingOutsideViewBox: true,
                                                                                                                            )
                                                                                                                          : results[index].extension!.toLowerCase() == 'jpg' || results[index].extension!.toLowerCase() == 'jpeg'
                                                                                                                              ? SvgPicture.asset(
                                                                                                                                  'assets/svgs/jpg.svg',
                                                                                                                                  height: blockSizeVertical * 3,
                                                                                                                                  allowDrawingOutsideViewBox: true,
                                                                                                                                )
                                                                                                                              : const SizedBox())),
                                                                                                          const SizedBox(
                                                                                                            width: 12,
                                                                                                          ),
                                                                                                          Flexible(
                                                                                                            flex: 6,
                                                                                                            child: Text(
                                                                                                              results[index].name,
                                                                                                              overflow: TextOverflow.ellipsis,
                                                                                                              style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: blockSizeVertical * 2),
                                                                                                            ),
                                                                                                          ),
                                                                                                          const SizedBox(
                                                                                                            width: 6,
                                                                                                          ),
                                                                                                          Flexible(
                                                                                                              flex: 2,
                                                                                                              child: Text(
                                                                                                                size,
                                                                                                                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey),
                                                                                                              )),
                                                                                                          Flexible(
                                                                                                              flex: 1,
                                                                                                              child: IconButton(
                                                                                                                icon: const Icon(
                                                                                                                  Icons.close,
                                                                                                                  color: Colors.grey,
                                                                                                                ),
                                                                                                                onPressed: () {
                                                                                                                  setState(() {
                                                                                                                    results.removeAt(index);
                                                                                                                  });
                                                                                                                },
                                                                                                              ))
                                                                                                        ],
                                                                                                      )),
                                                                                                  const Divider()
                                                                                                ],
                                                                                              );
                                                                                            }),
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(
                                                                                  height:
                                                                                      12,
                                                                                ),
                                                                                SizedBox(
                                                                                  width:
                                                                                      double.maxFinite,
                                                                                  height:
                                                                                      50,
                                                                                  child: ElevatedButton(
                                                                                      style: mainBtnStyle(primary, Colors.transparent, second),
                                                                                      onPressed: () {
                                                                                        List<String> paths = [];
                                                                                                            
                                                                                        if (selectedAttachmentCategory != null && results.isNotEmpty) {
                                                                                          for (var res in results) {
                                                                                            paths.add(res.path!);
                                                                                          }
                                                                                          setState(() {
                                                                                            results.clear();
                                                                                          });
                                                                                          Navigator.pop(context);
                                                                                          parent.read<WorkHistoryBloc>().add(AddWorkHistoryAttachment(attachmentModule: state.workExperiences[index].id.toString(), filePaths: paths, categoryId: selectedAttachmentCategory!.id.toString(), token: token!, profileId: profileId.toString()));
                                                                                        }
                                                                                      },
                                                                                      child: const Text("Submit")),
                                                                                )
                                                                              ]),
                                                                        );
                                                                      }),
                                                                    ),
                                                                  );
                                                                });
                                                          }
                                                        },
                                                        menuItems: [
                                                          popMenuItem(
                                                              text: "Update",
                                                              value: 1,
                                                              icon: Icons.edit),
                                                          popMenuItem(
                                                              text: "Remove",
                                                              value: 2,
                                                              icon: Icons.delete),
                                                          popMenuItem(
                                                              text: "Attach",
                                                              value: 3,
                                                              icon: Icons
                                                                  .attach_file),
                                                        ],
                                                        icon: const Icon(
                                                          Icons.more_vert,
                                                          color: Colors.grey,
                                                        ),
                                                        tooltip: "Options",
                                                      )
                                                    ]),
                                        
                                                    ////Show Attachments
                                                    SizedBox(
                                                        child: state
                                                                        .workExperiences[
                                                                            index]
                                                                        .attachments ==
                                                                    null ||
                                                                state
                                                                    .workExperiences[
                                                                        index]
                                                                    .attachments!
                                                                    .isEmpty
                                                            ? const SizedBox()
                                                            : state
                                                                            .workExperiences[
                                                                                index]
                                                                            .attachments !=
                                                                        null &&
                                                                    state
                                                                            .workExperiences[
                                                                                index]
                                                                            .attachments!
                                                                            .length ==
                                                                        1
                                                                ?
                                                                ////Single Attachment view
                                                                SingleAttachment(
                                                                    onpressed: () {
                                                                      confirmAlert(
                                                                          context,
                                                                          () {
                                                                        parent.read<WorkHistoryBloc>().add(DeleteWorkHistoryAttachment(
                                                                            attachment: state
                                                                                .workExperiences[
                                                                                    index]
                                                                                .attachments!
                                                                                .first,
                                                                            moduleId: state
                                                                                .workExperiences[
                                                                                    index]
                                                                                .id!,
                                                                            profileId:
                                                                                profileId!,
                                                                            token:
                                                                                token!));
                                                                      }, "Delete?",
                                                                          "Confirm Delete?");
                                                                    },
                                                                    attachment: state
                                                                        .workExperiences[
                                                                            index]
                                                                        .attachments!
                                                                        .first,
                                                                    view: () {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: ((context) => BlocProvider.value(
                                                                                    value: WorkHistoryBloc()..add(WorkHistoryViewAttachmentEvent(source: state.workExperiences[index].attachments!.first.source!, filename: state.workExperiences[index].attachments!.first.filename!)),
                                                                                    child: const WorkHistoryViewAttachment(),
                                                                                  ))));
                                                                    },
                                                                  )
                                                                ////Multiple Attachments View
                                                                : MultipleAttachments(
                                                                    viewAttachment:
                                                                        (source,
                                                                            filename) {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: ((context) => BlocProvider.value(
                                                                                    value: WorkHistoryBloc()..add(WorkHistoryViewAttachmentEvent(source: source, filename: filename)),
                                                                                    child: const WorkHistoryViewAttachment(),
                                                                                  ))));
                                                                    },
                                                                    profileId:
                                                                        profileId!,
                                                                    token: token!,
                                                                    moduleId: state
                                                                        .workExperiences[
                                                                            index]
                                                                        .id!,
                                                                    educationBloc:
                                                                        null,
                                                                    workHistoryBloc:
                                                                        BlocProvider.of<
                                                                                WorkHistoryBloc>(
                                                                            context),
                                                                    eligibilityBloc:
                                                                        null,
                                                                    learningDevelopmentBloc:
                                                                        null,
                                                                    blocId: 3,
                                                                    eligibilityName: state
                                                                        .workExperiences[
                                                                            index]
                                                                        .position!
                                                                        .title!,
                                                                    attachments: state
                                                                        .workExperiences[
                                                                            index]
                                                                        .attachments!,
                                                                  ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            } else {
                              return const EmptyData(
                                  message:
                                      "You don't have any work experience added. Please click + to add");
                            }
                          }
                          if (state is AddWorkHistoryState) {
                            return AddWorkHistoryScreen(
                              profileId: profileId!,
                              token: token!,
                            );
                          }
                          if (state is EditWorkHistoryState) {
                            return EditWorkHistoryScreen(
                              profileId: profileId!,
                              token: token!,
                            );
                          }
                          if (state is WorkHistoryErrorState) {
                            return SomethingWentWrong(
                                message: state.message,
                                onpressed: () {
                                  context.read<WorkHistoryBloc>().add(
                                      GetWorkHistories(
                                          profileId: profileId!,
                                          token: token!));
                                });
                          }
                          if (state is ShowAddFormErrorState) {
                            return SomethingWentWrong(
                                message:
                                    "Something went wrong. Please try again!",
                                onpressed: () {
                                  context
                                      .read<WorkHistoryBloc>()
                                      .add(ShowAddWorkHistoryForm());
                                });
                          }
                          if (state is ShowEditFormErrorState) {
                            return SomethingWentWrong(
                                message: onError,
                                onpressed: () {
                                  context.read<WorkHistoryBloc>().add(
                                      ShowEditWorkHistoryForm(
                                          workHistory: state.workHistory));
                                });
                          }
                          if (state is ErrorDeleteWorkHistoryAttachment) {
                            return SomethingWentWrong(
                                message: onError,
                                onpressed: () {
                                  parent.read<WorkHistoryBloc>().add(
                                      DeleteWorkHistoryAttachment(
                                          attachment: state.attachment,
                                          moduleId: state.moduleId,
                                          profileId: profileId!,
                                          token: token!));
                                });
                          }
                          if (state is ErrorDeleteWorkHistory) {
                            return SomethingWentWrong(
                                message: onError,
                                onpressed: () {
                                  BlocProvider.of<WorkHistoryBloc>(context).add(
                                      DeleteWorkHistory(
                                          profileId: profileId!,
                                          token: token!,
                                          workHistory: state.workHistory));
                                });
                          }if(state is ErrorAddWorkHistory){
                            return SomethingWentWrong(message: onError, onpressed: (){ 

                              context.read<WorkHistoryBloc>().add(AddWorkHistory(accomplishment: state.accomplishment,workHistory: state.workHistory,isPrivate: state.isPrivate,profileId: profileId!,token: token!,actualDuties: state.actualDuties));
                            });
                          }
                          if (state is AddAttachmentError) {
                            return SomethingWentWrong(
                                message: onError,
                                onpressed: () {
                                  parent.read<WorkHistoryBloc>().add(
                                      AddWorkHistoryAttachment(
                                          attachmentModule:
                                              state.attachmentModule,
                                          filePaths: state.filePaths,
                                          categoryId: state.categoryId,
                                          token: token!,
                                          profileId: profileId.toString()));
                                });
                          }if(state is ErrorUpdateWorkHistory){
                            return SomethingWentWrong(message: onError, onpressed: (){
                              context.read<WorkHistoryBloc>().add(UpdateWorkHistory(isPrivate: state.isPrivate,workHistory: state.workHistory,token: token!,profileId: profileId!));
                            });
                          }
                          return Container();
                        },
                      );
                    }
                    return Container();
                  },
                );
              }
              return Container();
            },
          ),
        ));
  }
}

PopupMenuItem<int> popMenuItem({String? text, int? value, IconData? icon}) {
  return PopupMenuItem(
    value: value,
    child: Row(
      children: [
        Icon(
          icon,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          text!,
        ),
      ],
    ),
  );
}
