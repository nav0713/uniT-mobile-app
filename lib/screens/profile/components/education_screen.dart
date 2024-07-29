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
import 'package:unit2/bloc/profile/profile_bloc.dart';
import 'package:unit2/bloc/user/user_bloc.dart';
import 'package:unit2/model/profile/educational_background.dart';
import 'package:unit2/screens/profile/components/education/add_modal.dart';
import 'package:unit2/theme-data.dart/box_shadow.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/utils/text_container.dart';
import 'package:unit2/widgets/Leadings/add_leading.dart';
import 'package:unit2/widgets/empty_data.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';
import 'package:unit2/widgets/titlesubtitle.dart';
import '../../../bloc/profile/education/education_bloc.dart';
import '../../../model/profile/attachment.dart';
import '../../../theme-data.dart/btn-style.dart';
import '../../../theme-data.dart/form-style.dart';
import '../../../utils/alerts.dart';
import '../../../utils/global.dart';
import '../../../widgets/Leadings/close_leading.dart';
import '../shared/multiple_attachment.dart';
import '../shared/single_attachment.dart';
import 'education/edit_modal.dart';
import 'education/education_view_attachment.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final parent = context;

    List<PlatformFile>? results = [];
    AttachmentCategory? selectedAttachmentCategory;
    List<AttachmentCategory> attachmentCategories = [];
    int profileId;
    String? token;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: context.watch<EducationBloc>().state is AddEducationState
              ? const FittedBox(child: Text("Add Educational Background"))
              : context.watch<EducationBloc>().state is EditEducationState
                  ? const FittedBox(child: Text("Edit Educational Background"))
                  : const Text("Education Background"),
          centerTitle: true,
          backgroundColor: primary,
          actions: context.watch<EducationBloc>().state
                  is EducationalBackgroundLoadedState
              ? [
                  AddLeading(onPressed: () {

                    context.read<EducationBloc>().add(ShowAddEducationForm());
                  })
                ]
              : (context.watch<EducationBloc>().state is AddEducationState ||
                      context.watch<EducationBloc>().state
                          is EditEducationState)
                  ? [
                      CloseLeading(onPressed: () {
                        context.read<EducationBloc>().add(LoadEducations());
                      })
                    ]
                  : [],
        ),
        //userbloc
        body: LoadingProgress(
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoggedIn) {
                token = state.userData!.user!.login!.token;
                profileId = state.userData!.user!.login!.user!.profileId!;
                //profilebloc
                return BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileLoaded) {
                      //education bloc
                      return BlocConsumer<EducationBloc, EducationState>(
                        listener: (context, state) {
                          if (state is EducationalBackgroundLoadingState) {
                            final progress = ProgressHUD.of(context);
                            progress!.showWithText("Please wait...");
                          }
                          if (state is EducationalBackgroundLoadedState ||
                              state is ShowAddFormErrorState ||
                              state is EducationalBackgroundErrorState ||
                              state is AddEducationState ||
                              state is EditEducationState ||
                              state is EducationDeletedState ||
                              state is EditedEducationState ||
                              state is EducationAddingErrorState ||
                              state is EducationUpdatingErrorState ||
                              state is ShowEditFormErrorState ||
                              state is EducationDeletingErrorState ||
                              state is AddAttachmentError ||
                              state is ErrorDeleteEducationAttachmentState) {
                            final progress = ProgressHUD.of(context);
                            progress!.dismiss();
                          }
                          ////ADDED STATE
                          if (state is EducationAddedState) {
                            if (state.response['success']) {
                              successAlert(context, "Adding Successfull!",
                                  state.response['message'], () {
                                Navigator.of(context).pop();
                                context
                                    .read<EducationBloc>()
                                    .add(LoadEducations());
                              });
                            } else {
                              errorAlert(context, "Adding Failed",
                                  "Something went wrong. Please try again.",
                                  () {
                                Navigator.of(context).pop();
                                context
                                    .read<EducationBloc>()
                                    .add(LoadEducations());
                              });
                            }
                          }
                          ////ATTACHMENT ADDED STATE

                          if (state is EducationAttachmentAddedState) {
                            if (state.response['success']) {
                              successAlert(context, "Adding Successfull!",
                                  state.response['message'], () {
                                Navigator.of(context).pop();
                                context
                                    .read<EducationBloc>()
                                    .add(LoadEducations());
                              });
                            } else {
                              errorAlert(context, "Adding Failed",
                                  "Something went wrong. Please try again.",
                                  () {
                                Navigator.of(context).pop();
                                context
                                    .read<EducationBloc>()
                                    .add(LoadEducations());
                              });
                            }
                          }
                          ////EDITED STATE
                          if (state is EditedEducationState) {
                            if (state.response['success']) {
                              successAlert(context, "Update Successfull!",
                                  state.response['message'], () {
                                Navigator.of(context).pop();
                                context
                                    .read<EducationBloc>()
                                    .add(LoadEducations());
                              });
                            } else {
                              errorAlert(context, "Updated Failed",
                                  "Something went wrong. Please try again.",
                                  () {
                                Navigator.of(context).pop();
                                context
                                    .read<EducationBloc>()
                                    .add(LoadEducations());
                              });
                            }
                          }
                          ////DELETED STATE
                          if (state is EducationDeletedState) {
                            if (state.success) {
                              successAlert(context, "Deletion Successfull",
                                  "Educational Background has been deleted successfully",
                                  () {
                                Navigator.of(context).pop();
                                context
                                    .read<EducationBloc>()
                                    .add(LoadEducations());
                              });
                            } else {
                              errorAlert(context, "Deletion Failed",
                                  "Error deleting Education Background", () {
                                Navigator.of(context).pop();
                                context
                                    .read<EducationBloc>()
                                    .add(LoadEducations());
                              });
                            }
                          }
                          ////ATTACHMENT DELETED STATE
                          if (state is EducationAttachmentDeletedState) {
                            if (state.success) {
                              successAlert(context, "Deletion Successfull",
                                  "Attachment has been deleted successfully",
                                  () {
                                Navigator.of(context).pop();
                                context
                                    .read<EducationBloc>()
                                    .add(LoadEducations());
                              });
                            } else {
                              errorAlert(context, "Deletion Failed",
                                  "Error deleting Attachment", () {
                                Navigator.of(context).pop();
                                context
                                    .read<EducationBloc>()
                                    .add(LoadEducations());
                              });
                            }
                          }
                        },
                        builder: (context, state) {
                          if (state is EducationalBackgroundLoadedState) {
                            for (var cat in state.attachmentCategory) {
                              if (cat.subclass!.id == 1) {
                                attachmentCategories.add(cat);
                              }
                            }
                            if (state.educationalBackground.isNotEmpty) {
                              return ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 10),
                                  itemCount: state.educationalBackground.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    String level = state
                                        .educationalBackground[index]
                                        .education!
                                        .level!;
                                    String periodFrom = state
                                        .educationalBackground[index]
                                        .periodFrom!;
                                    String periodTo = state
                                        .educationalBackground[index].periodTo!;
                                    String? program = state
                                                .educationalBackground[index]
                                                .education!
                                                .course ==
                                            null
                                        ? null
                                        : state.educationalBackground[index]
                                            .education!.course!.program!;
                                    List<Honor>? honors = state
                                        .educationalBackground[index].honors!
                                        .toList();
                                    String school = state
                                        .educationalBackground[index]
                                        .education!
                                        .school!
                                        .name!;
                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 300),
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
                                                          backgroundColor:
                                                              Colors.white,
                                                          title: const Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                FontAwesome5
                                                                    .user_graduate,
                                                                color: primary,
                                                                size: 32,
                                                              ),
                                                              Text(
                                                                "Educational Background Details",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color:
                                                                        primary,
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
                                                                      .educationalBackground[
                                                                          index]
                                                                      .education!
                                                                      .level!,
                                                                  sub: "Level"),
                                                              SizedBox(
                                                                  child: state.educationalBackground[index].education!.level!.toLowerCase() == 'collegiate' ||
                                                                          state.educationalBackground[index].education!.level!.toLowerCase() ==
                                                                              'vocational' ||
                                                                          state.educationalBackground[index].education!.level!.toLowerCase() ==
                                                                              'masteral' ||
                                                                          state.educationalBackground[index].education!.level!.toLowerCase() ==
                                                                              'doctorate'
                                                                      ? Column(
                                                                          children: [
                                                                            const Gap(
                                                                                3),
                                                                            TitleSubtitle(
                                                                                title: state.educationalBackground[index].education!.course!.program!,
                                                                                sub: "Course/Program"),
                                                                          ],
                                                                        )
                                                                      : const SizedBox()),
                                                              const Gap(3),
                                                              TitleSubtitle(
                                                                  title: state
                                                                      .educationalBackground[
                                                                          index]
                                                                      .education!
                                                                      .school!
                                                                      .name!,
                                                                  sub: "School"),
                                                              const Gap(3),
                                                              TitleSubtitle(
                                                                  title: state
                                                                      .educationalBackground[
                                                                          index]
                                                                      .periodFrom!,
                                                                  sub: "From"),
                                                              const Gap(3),
                                                              TitleSubtitle(
                                                                  title: state
                                                                      .educationalBackground[
                                                                          index]
                                                                      .periodTo!,
                                                                  sub: "To"),
                                                              const Gap(3),
                                                              SizedBox(
                                                                child: state
                                                                            .educationalBackground[
                                                                                index]
                                                                            .yearGraduated !=
                                                                        null
                                                                    ? TitleSubtitle(
                                                                        title: state
                                                                            .educationalBackground[
                                                                                index]
                                                                            .yearGraduated!,
                                                                        sub:
                                                                            "Year Graduated")
                                                                    : TitleSubtitle(
                                                                        title: state
                                                                            .educationalBackground[
                                                                                index]
                                                                            .unitsEarned
                                                                            .toString(),
                                                                        sub:
                                                                            "Units Earned"),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              },
                                              child: Container(
                                                decoration: box1(),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 8),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                        child: Text(
                                                                            level,
                                                                            style:
                                                                                Theme.of(context).textTheme.titleSmall!)),
                                                                    Text(
                                                                      "$periodFrom - $periodTo",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyMedium,
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  school,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .titleMedium!
                                                                      .copyWith(
                                                                          color:
                                                                              primary,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                ),
                                                                Container(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        top: 8),
                                                                    child: honors
                                                                            .isNotEmpty
                                                                        ? Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              const SizedBox(
                                                                                height: 8,
                                                                              ),
                                                                              const Text(
                                                                                " honors: ",
                                                                                style: TextStyle(fontWeight: FontWeight.w600),
                                                                              ),
                                                                              Column(
                                                                                children: honors
                                                                                    .map((Honor honor) => Padding(
                                                                                          padding: const EdgeInsets.all(3.0),
                                                                                          child: Text(
                                                                                            "-${honor.name!.trim()}",
                                                                                            style: Theme.of(context).textTheme.labelSmall,
                                                                                          ),
                                                                                        ))
                                                                                    .toList(),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        : const SizedBox()),
                                                                program == null
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          const SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          Text(
                                                                              program),
                                                                        ],
                                                                      ),
                                                              ]),
                                                        ),
                                                        AppPopupMenu<int>(
                                                          offset: const Offset(
                                                              -10, -10),
                                                          elevation: 3,
                                                          onSelected: (value) {
                                                            ////delete -= = = = = = = = =>>
                                                            if (value == 2) {
                                                              confirmAlert(
                                                                  context, () {
                                                                context.read<EducationBloc>().add(DeleteEducation(
                                                                    educationalBackground:
                                                                        state.educationalBackground[
                                                                            index],
                                                                    profileId:
                                                                        profileId,
                                                                    token:
                                                                        token!));
                                                              }, "Delete?",
                                                                  "Confirm Delete?");
                                                            }
                                                            if (value == 1) {
                                                              ////edit -= = = = = = = = =>>

                                                              context
                                                                  .read<
                                                                      EducationBloc>()
                                                                  .add(ShowEditEducationForm(
                                                                      profileId:
                                                                          profileId,
                                                                      token:
                                                                          token!,
                                                                      educationalBackground:
                                                                          state.educationalBackground[
                                                                              index]));
                                                            }
                                                            if (value == 3) {
                                                              results.clear();
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return ZoomIn(
                                                                      child: AlertDialog(
                                                                        contentPadding:
                                                                            const EdgeInsets
                                                                                .all(
                                                                                0),
                                                                        backgroundColor: Colors
                                                                            .grey
                                                                            .shade100,
                                                                        icon:
                                                                            const Icon(
                                                                          Icons
                                                                              .file_copy,
                                                                          size:
                                                                              32,
                                                                          color:
                                                                              primary,
                                                                        ),
                                                                        title: const Text(
                                                                            "File Attachment:"),
                                                                        content: StatefulBuilder(builder:
                                                                            (context,
                                                                                setState) {
                                                                          return Padding(
                                                                            padding: const EdgeInsets
                                                                                .all(
                                                                                16.0),
                                                                            child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  const Divider(),
                                                                                  Text(
                                                                                    program ?? level,
                                                                                    style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500, color: primary),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    height: 5,
                                                                                  ),
                                                                                  Text(school, style: Theme.of(context).textTheme.titleSmall),
                                                                                  const SizedBox(
                                                                                    height: 3,
                                                                                  ),
                                                                                  Text("$periodFrom - $periodTo", style: Theme.of(context).textTheme.titleSmall),
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
                                                                                    height: 8,
                                                                                  ),
                                                                                  Text(
                                                                                    "You may attach necessary documents such as Transcript of Records (TOR), diploma, and the likes.",
                                                                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    height: 5,
                                                                                  ),
                                                                                  Text(
                                                                                    "Acceptable Files: PDF, JPEG, PNG",
                                                                                    style: Theme.of(context).textTheme.bodySmall,
                                                                                  ),
                                                                                  Text(
                                                                                    "Max File Size (per attachment): 1MB",
                                                                                    style: Theme.of(context).textTheme.bodySmall,
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
                                                                                    child: SizedBox(
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
                                                                                                              width: 12,
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
                                                                                    height: 12,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: double.maxFinite,
                                                                                    height: 50,
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
                                                                                            parent.read<EducationBloc>().add(AddEducationAttachment(attachmentModule: state.educationalBackground[index].id.toString(), filePaths: paths, categoryId: selectedAttachmentCategory!.id.toString(), token: token!, profileId: profileId.toString()));
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
                                                                icon:
                                                                    Icons.edit),
                                                            popMenuItem(
                                                                text: "Remove",
                                                                value: 2,
                                                                icon: Icons
                                                                    .delete),
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
                                                      ],
                                                    ),

                                                    ////Show Attachments
                                                    SizedBox(
                                                        child: state
                                                                        .educationalBackground[
                                                                            index]
                                                                        .attachments ==
                                                                    null ||
                                                                state
                                                                    .educationalBackground[
                                                                        index]
                                                                    .attachments!
                                                                    .isEmpty
                                                            ? const SizedBox()
                                                            : state.educationalBackground[index].attachments !=
                                                                        null &&
                                                                    state
                                                                            .educationalBackground[index]
                                                                            .attachments!
                                                                            .length ==
                                                                        1
                                                                ?
                                                                ////Single Attachment view
                                                                Column(
                                                                    children: [
                                                                      const Divider(),
                                                                      SingleAttachment(
                                                                        view:
                                                                            () {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: ((context) => BlocProvider.value(
                                                                                        value: EducationBloc()..add(EducationViewAttachment(source: state.educationalBackground[index].attachments!.first.source!, fileName: state.educationalBackground[index].attachments!.first.filename!)),
                                                                                        child: const EudcationViewAttachment(),
                                                                                      ))));
                                                                        },
                                                                        onpressed:
                                                                            () {
                                                                          confirmAlert(
                                                                              context,
                                                                              () {
                                                                            parent.read<EducationBloc>().add(DeleteEducationAttachment(
                                                                                attachment: state.educationalBackground[index].attachments!.first,
                                                                                moduleId: state.educationalBackground[index].id!,
                                                                                profileId: profileId,
                                                                                token: token!));
                                                                          }, "Delete?",
                                                                              "Confirm Delete?");
                                                                        },
                                                                        attachment: state
                                                                            .educationalBackground[index]
                                                                            .attachments!
                                                                            .first,
                                                                      ),
                                                                    ],
                                                                  )
                                                                ////Multiple Attachments View
                                                                : MultipleAttachments(
                                                                    viewAttachment:
                                                                        (source,
                                                                            filname) {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: ((context) => BlocProvider.value(
                                                                                    value: EducationBloc()..add(EducationViewAttachment(source: source, fileName: filname)),
                                                                                    child: const EudcationViewAttachment(),
                                                                                  ))));
                                                                    },
                                                                    profileId:
                                                                        profileId,
                                                                    token:
                                                                        token!,
                                                                    eligibilityName: state
                                                                        .educationalBackground[
                                                                            index]
                                                                        .education!
                                                                        .school!
                                                                        .name!,
                                                                    attachments: state
                                                                        .educationalBackground[
                                                                            index]
                                                                        .attachments!,
                                                                    educationBloc:
                                                                        BlocProvider.of<EducationBloc>(
                                                                            parent),
                                                                    eligibilityBloc:
                                                                        null,
                                                                    workHistoryBloc:
                                                                        null,
                                                                    learningDevelopmentBloc:
                                                                        null,
                                                                    blocId: 1,
                                                                    moduleId: state
                                                                        .educationalBackground[
                                                                            index]
                                                                        .id!,
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
                                      "You don't have any Educational Background added. Please click + to add.");
                            }
                          }
                          if (state is EducationAddingErrorState) {
                            return SomethingWentWrong(
                                message:
                                    "Error Adding Educational Background. Please try again!",
                                onpressed: () {
                                  context.read<EducationBloc>().add(
                                      AddEducation(
                                          educationalBackground:
                                              state.educationalBackground,
                                          profileId: profileId,
                                          token: token!,
                                          honors: state.honors));
                                });
                          }
                          if (state is EducationUpdatingErrorState) {
                            return SomethingWentWrong(
                                message:
                                    "Error Updating Educational Background. Please try again!",
                                onpressed: () {
                                  context.read<EducationBloc>().add(
                                      UpdateEducation(
                                          educationalBackground:
                                              state.educationalBackground,
                                          profileId: profileId,
                                          token: token!,
                                          honors: state.honors));
                                });
                          }
                          if (state is EducationDeletingErrorState) {
                            return SomethingWentWrong(
                                message:
                                    "Error Deleting Educational Background. Please try again!",
                                onpressed: () {
                                  context.read<EducationBloc>().add(
                                      DeleteEducation(
                                          educationalBackground:
                                              state.educationalBackground,
                                          profileId: profileId,
                                          token: token!));
                                });
                          }
                          ////Error state
                          if (state is EducationalBackgroundErrorState) {
                            return SomethingWentWrong(
                                message: state.message,
                                onpressed: () {
                                  context.read<EducationBloc>().add(
                                      GetEducationalBackground(
                                          profileId: profileId, token: token!));
                                });
                          }

                          if (state is AddEducationState) {
                            return AddEducationScreen(
                              token: token!,
                              profileId: profileId,
                            );
                          }
                          if (state is EditEducationState) {
                            return EditEducationScreen(
                              token: token!,
                              profileId: profileId,
                            );

                            //// show add form error state
                          }
                          if (state is ShowAddFormErrorState) {
                            return SomethingWentWrong(
                                message:
                                    "Something went wrong. Please try again!",
                                onpressed: () {
                                  context
                                      .read<EducationBloc>()
                                      .add(ShowAddEducationForm());
                                });
                          }
                          if (state is ShowEditFormErrorState) {
                            return SomethingWentWrong(
                                message: onError,
                                onpressed: () {
                                  context.read<EducationBloc>().add(
                                      ShowEditEducationForm(
                                          profileId: profileId,
                                          token: token!,
                                          educationalBackground:
                                              state.educationalBackground));
                                });
                          }
                          if (state is AddAttachmentError) {
                            return SomethingWentWrong(
                                message: onError,
                                onpressed: () {
                                  context.read<EducationBloc>().add(
                                      AddEducationAttachment(
                                          attachmentModule:
                                              state.attachmentModule,
                                          filePaths: state.filePaths,
                                          categoryId: state.categoryId,
                                          token: token!,
                                          profileId: profileId.toString()));
                                });
                          }
                          if (state is ErrorDeleteEducationAttachmentState) {
                            return SomethingWentWrong(
                                message: onError,
                                onpressed: () {
                                  parent.read<EducationBloc>().add(
                                      DeleteEducationAttachment(
                                          attachment: state.attachment,
                                          moduleId: int.parse(state.moduleId),
                                          profileId: profileId,
                                          token: token!));
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
}
