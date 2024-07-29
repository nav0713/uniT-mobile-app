import 'package:animate_do/animate_do.dart';
import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:unit2/bloc/profile/profile_bloc.dart';
import 'package:unit2/bloc/user/user_bloc.dart';
import 'package:unit2/screens/profile/components/learning_development/edit_modal.dart';
import 'package:unit2/screens/profile/components/learning_development/learning_development_view_attachment.dart';
import 'package:unit2/theme-data.dart/box_shadow.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/utils/global.dart';
import 'package:unit2/utils/text_container.dart';
import 'package:unit2/widgets/Leadings/add_leading.dart';
import 'package:unit2/widgets/empty_data.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';
import 'package:unit2/widgets/titlesubtitle.dart';
import '../../../bloc/profile/learningDevelopment/learning_development_bloc.dart';
import '../../../model/profile/attachment.dart';
import '../../../theme-data.dart/btn-style.dart';
import '../../../theme-data.dart/form-style.dart';
import '../../../utils/alerts.dart';
import '../../../widgets/Leadings/close_leading.dart';
import '../shared/multiple_attachment.dart';
import '../shared/single_attachment.dart';
import 'learning_development/add_modal.dart';

class LearningAndDevelopmentScreen extends StatelessWidget {
  const LearningAndDevelopmentScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String token;
    int profileId;
    BuildContext parent = context;
    DateFormat dteFormat2 = DateFormat.yMMMMd('en_US');
    List<PlatformFile>? results = [];
    AttachmentCategory? selectedAttachmentCategory;
    List<AttachmentCategory> attachmentCategories = [];
    return Scaffold(
        appBar: AppBar(
            title: context.watch<LearningDevelopmentBloc>().state
                    is LearningDevelopmentAddingState
                ? const FittedBox(
                    child: Text("Add $learningAndDevelopmentScreenTitle"))
                : context.watch<LearningDevelopmentBloc>().state
                        is LearningDevelopmentUpdatingState
                    ? const FittedBox(
                        child: Text("Edit $learningAndDevelopmentScreenTitle"))
                    : const FittedBox(
                        child: Text(learningAndDevelopmentScreenTitle)),
            centerTitle: true,
            backgroundColor: primary,
            actions: (context.watch<LearningDevelopmentBloc>().state
                    is LearningDevelopmentLoadedState)
                ? [
                    AddLeading(onPressed: () {
                      context
                          .read<LearningDevelopmentBloc>()
                          .add(ShowAddLearningDevelopmentForm());
                    })
                  ]
                : (context.watch<LearningDevelopmentBloc>().state
                            is LearningDevelopmentAddingState ||
                        context.watch<LearningDevelopmentBloc>().state
                            is LearningDevelopmentUpdatingState)
                    ? [
                        CloseLeading(onPressed: () {
                          context
                              .read<LearningDevelopmentBloc>()
                              .add(LoadLearniningDevelopment());
                        })
                      ]
                    : []),
        body: LoadingProgress(
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoggedIn) {
                token = state.userData!.user!.login!.token!;
                profileId = state.userData!.user!.login!.user!.profileId!;
                return BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileLoaded) {
                      return BlocConsumer<LearningDevelopmentBloc,
                          LearningDevelopmentState>(
                        listener: (context, state) {
                          if (state is LearningDevelopmentLoadingState) {
                            final progress = ProgressHUD.of(context);
                            progress!.showWithText("Please wait...");
                          }
                          if (state is LearningDevelopmentLoadedState ||
                              state is ShowAddFormErrorState ||
                              state is LearningDevelopmentErrorState ||
                              state is LearningDevelopmentAddingState ||
                              state is LearningDevelopmentAddedState ||
                              state is LearningDevelopmentUpdatingState ||
                              state is LearningDevelopmentUpdatedState ||
                              state is ErrorDeleteLearningDevAttachment ||
                              state is LearningDevelopmentDeletingErrorState ||
                              state is LearningDevelopmentAddingErrorState ||
                              state is ShowEditFormErrorState ||
                              state is LearningDevelopmentUpdatingErrorState ||
                              state is AddAttachmentError) {
                            final progress = ProgressHUD.of(context);
                            progress!.dismiss();
                          }
                          //// Added State
                          if (state is LearningDevelopmentAddedState) {
                            if (state.response['success']) {
                              successAlert(context, "Adding Successfull!",
                                  state.response['message'], () {
                                Navigator.of(context).pop();
                                context
                                    .read<LearningDevelopmentBloc>()
                                    .add(LoadLearniningDevelopment());
                              });
                            } else {
                              errorAlert(context, "Adding Failed",
                                  "Something went wrong. Please try again.",
                                  () {
                                Navigator.of(context).pop();
                                context
                                    .read<LearningDevelopmentBloc>()
                                    .add(LoadLearniningDevelopment());
                              });
                            }
                          }
                          ////Attachment Added State
                          if (state is LearningDevAttachmentAddedState) {
                            if (state.response['success']) {
                              successAlert(context, "Adding Successfull!",
                                  state.response['message'], () {
                                Navigator.of(context).pop();
                                context
                                    .read<LearningDevelopmentBloc>()
                                    .add(LoadLearniningDevelopment());
                              });
                            } else {
                              errorAlert(context, "Adding Failed",
                                  "Something went wrong. Please try again.",
                                  () {
                                Navigator.of(context).pop();
                                context
                                    .read<LearningDevelopmentBloc>()
                                    .add(LoadLearniningDevelopment());
                              });
                            }
                          }
                          ////Updated State
                          if (state is LearningDevelopmentUpdatedState) {
                            if (state.response['success']) {
                              successAlert(context, "Update Successfull!",
                                  state.response['message'], () {
                                Navigator.of(context).pop();
                                context
                                    .read<LearningDevelopmentBloc>()
                                    .add(LoadLearniningDevelopment());
                              });
                            } else {
                              errorAlert(context, "Update Failed",
                                  "Something went wrong. Please try again.",
                                  () {
                                Navigator.of(context).pop();
                                context
                                    .read<LearningDevelopmentBloc>()
                                    .add(LoadLearniningDevelopment());
                              });
                            }
                          }
                          ////Deleted State
                          if (state is DeleteLearningDevelopmentState) {
                            if (state.success) {
                              successAlert(context, "Deletion Successfull!",
                                  "Learning Development Has Been Deleted Successfully",
                                  () {
                                Navigator.of(context).pop();
                                context
                                    .read<LearningDevelopmentBloc>()
                                    .add(LoadLearniningDevelopment());
                              });
                            } else {
                              errorAlert(context, "Deletion Failed",
                                  "Something went wrong. Please try again.",
                                  () {
                                Navigator.of(context).pop();
                                context
                                    .read<LearningDevelopmentBloc>()
                                    .add(LoadLearniningDevelopment());
                              });
                            }
                          }
                          ////ATTACHMENT DELETED STATE
                          if (state is LearningDevAttachmentDeletedState) {
                            if (state.success) {
                              successAlert(context, "Deletion Successfull",
                                  "Attachment has been deleted successfully",
                                  () {
                                Navigator.of(context).pop();
                                context
                                    .read<LearningDevelopmentBloc>()
                                    .add(LoadLearniningDevelopment());
                              });
                            } else {
                              errorAlert(context, "Deletion Failed",
                                  "Error deleting Attachment", () {
                                Navigator.of(context).pop();
                                context
                                    .read<LearningDevelopmentBloc>()
                                    .add(LoadLearniningDevelopment());
                              });
                            }
                          }
                          // TODO: implement listener
                        },
                        builder: (context, state) {
                          if (state is LearningDevelopmentLoadedState) {
                            for (var cat in state.attachmentCategory) {
                              if (cat.subclass!.id == 2) {
                                attachmentCategories.add(cat);
                              }
                            }
                            if (state.learningsAndDevelopment.isNotEmpty) {
                              return ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 10),
                                  itemCount:
                                      state.learningsAndDevelopment.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    String training = state
                                        .learningsAndDevelopment[index]
                                        .conductedTraining!
                                        .title!
                                        .title!;
                                    String provider = state
                                        .learningsAndDevelopment[index]
                                        .conductedTraining!
                                        .conductedBy!
                                        .name!;
                                    String start = dteFormat2.format(state
                                        .learningsAndDevelopment[index]
                                        .conductedTraining!
                                        .fromDate!);
                                    String end = dteFormat2.format(state
                                        .learningsAndDevelopment[index]
                                        .conductedTraining!
                                        .toDate!);
                                    String type = state
                                        .learningsAndDevelopment[index]
                                        .conductedTraining!
                                        .learningDevelopmentType!
                                        .title!;
                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration: const Duration(milliseconds: 500),
                                      child: FlipAnimation(
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: box1(),
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 8),
                                              width: screenWidth,
                                              child: InkWell(
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder:
                                                          (BuildContext context) {
                                                        return ZoomIn(
                                                          child: AlertDialog(
                                                            scrollable: true,
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
                                                                  Elusive.lightbulb,
                                                                  color: primary,
                                                                  size: 32,
                                                                ),
                                                                Text(
                                                                  "Learning and Development Details",
                                                                  textAlign: TextAlign
                                                                      .center,
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
                                                                        .learningsAndDevelopment[
                                                                            index]
                                                                        .conductedTraining!
                                                                        .title!
                                                                        .title!,
                                                                    sub: "Training"),
                                                                const Gap(3),
                                                                TitleSubtitle(
                                                                    title: state
                                                                        .learningsAndDevelopment[
                                                                            index]
                                                                        .conductedTraining!
                                                                        .learningDevelopmentType!
                                                                        .title!,
                                                                    sub:
                                                                        "Learning Development Type"),
                                                                const Gap(3),
                                                                TitleSubtitle(
                                                                    title: state
                                                                        .learningsAndDevelopment[
                                                                            index]
                                                                        .conductedTraining!
                                                                        .topic!
                                                                        .title!,
                                                                    sub: "Topic"),
                                                                const Gap(3),
                                                                TitleSubtitle(
                                                                    title: state
                                                                        .learningsAndDevelopment[
                                                                            index]
                                                                        .conductedTraining!
                                                                        .conductedBy!
                                                                        .name!,
                                                                    sub:
                                                                        "Conducted By"),
                                                                const Gap(3),
                                                                TitleSubtitle(
                                                                    title: dteFormat2
                                                                        .format(state
                                                                            .learningsAndDevelopment[
                                                                                index]
                                                                            .conductedTraining!
                                                                            .fromDate!),
                                                                    sub: "From Date"),
                                                                const Gap(3),
                                                                TitleSubtitle(
                                                                    title: dteFormat2
                                                                        .format(state
                                                                            .learningsAndDevelopment[
                                                                                index]
                                                                            .conductedTraining!
                                                                            .toDate!),
                                                                    sub: "To Date"),
                                                                const Gap(3),
                                                                TitleSubtitle(
                                                                    title: state
                                                                        .learningsAndDevelopment[
                                                                            index]
                                                                        .conductedTraining!
                                                                        .totalHours
                                                                        .toString(),
                                                                    sub:
                                                                        "Total Hours Conducted"),
                                                                const Gap(3),
                                                                TitleSubtitle(
                                                                    title: state
                                                                        .learningsAndDevelopment[
                                                                            index]
                                                                        .conductedTraining!
                                                                        .venue!
                                                                        .cityMunicipality!
                                                                        .province!
                                                                        .region!
                                                                        .description!,
                                                                    sub: "Region"),
                                                                const Gap(3),
                                                                TitleSubtitle(
                                                                    title: state
                                                                        .learningsAndDevelopment[
                                                                            index]
                                                                        .conductedTraining!
                                                                        .venue!
                                                                        .cityMunicipality!
                                                                        .province!
                                                                        .description!,
                                                                    sub: "Province"),
                                                                    const Gap(3),
                                                                        TitleSubtitle(
                                                                    title: state
                                                                        .learningsAndDevelopment[
                                                                            index]
                                                                        .conductedTraining!
                                                                        .venue!
                                                                        .cityMunicipality!
                                                                        .description!
                                                                        ,
                                                                    sub: "City/Municipality"),
                                                                
                                                                    SizedBox(child: state.learningsAndDevelopment[index].sponsoredBy == null?const SizedBox():      Column(
                                                                      children: [
                                                                            const Gap(3),
                                                                        TitleSubtitle(
                                                                        title: state
                                                                            .learningsAndDevelopment[
                                                                                index]
                                                                            .sponsoredBy!.name!,
                                                                        sub:
                                                                            "Sponsor By"),
                                                                      ],
                                                                    ),),const Gap(3),
                                                                              TitleSubtitle(
                                                                    title: state
                                                                        .learningsAndDevelopment[
                                                                            index]
                                                                        .conductedTraining!.totalHours.toString(),
                                                                    sub:
                                                                        "Total Hours Attended"),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                },
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
                                                                Text(
                                                                  training,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .titleMedium!
                                                                      .copyWith(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w600,
                                                                          color:
                                                                              primary),
                                                                ),
                                                                const SizedBox(
                                                                  height: 8,
                                                                ),
                                                                Text(
                                                                  provider,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .titleSmall,
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  "$duration: $start to $end",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .labelMedium,
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
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
                                                              confirmAlert(context,
                                                                  () {
                                                                final progress =
                                                                    ProgressHUD.of(
                                                                        context);
                                                                progress!
                                                                    .showWithText(
                                                                        "Loading...");
                                                                BlocProvider.of<LearningDevelopmentBloc>(context).add(DeleteLearningDevelopment(
                                                                    trainingId: state
                                                                        .learningsAndDevelopment[
                                                                            index]
                                                                        .conductedTraining!
                                                                        .id!,
                                                                    hours: state
                                                                        .learningsAndDevelopment[
                                                                            index]
                                                                        .conductedTraining!
                                                                        .totalHours!,
                                                                    sponsorId: state
                                                                        .learningsAndDevelopment[
                                                                            index]
                                                                        .sponsoredBy
                                                                        ?.id,
                                                                    profileId:
                                                                        profileId,
                                                                    token: token));
                                                              }, "Delete?",
                                                                  "Confirm Delete?");
                                                            }
                                                            if (value == 1) {
                                                              bool isOverseas;
                                                              ////edit  = = = = = = = =>>
                                        
                                                              if (state
                                                                      .learningsAndDevelopment[
                                                                          index]
                                                                      .conductedTraining
                                                                      ?.venue
                                                                      ?.cityMunicipality ==
                                                                  null) {
                                                                isOverseas = true;
                                                              } else {
                                                                isOverseas = false;
                                                              }
                                                              context
                                                                  .read<
                                                                      LearningDevelopmentBloc>()
                                                                  .add(ShowEditLearningDevelopmentForm(
                                                                      profileId:
                                                                          profileId,
                                                                      token: token,
                                                                      learningDevelopment:
                                                                          state.learningsAndDevelopment[
                                                                              index],
                                                                      isOverseas:
                                                                          isOverseas));
                                                            }
                                                            if (value == 3) {
                                                              results.clear();
                                                              showDialog(
                                                                  context: context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      contentPadding:
                                                                          const EdgeInsets
                                                                              .all(
                                                                              0),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .grey
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
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              16.0),
                                                                          child: Column(
                                                                              mainAxisSize: MainAxisSize
                                                                                  .min,
                                                                              mainAxisAlignment: MainAxisAlignment
                                                                                  .start,
                                                                              crossAxisAlignment:
                                                                                  CrossAxisAlignment.start,
                                                                              children: [
                                                                                const Divider(),
                                                                                Text(
                                                                                  training,
                                                                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500, color: primary),
                                                                                ),
                                                                                const SizedBox(
                                                                                  height: 5,
                                                                                ),
                                                                                Text(provider,
                                                                                    style: Theme.of(context).textTheme.titleSmall),
                                                                                const SizedBox(
                                                                                  height: 3,
                                                                                ),
                                                                                Text("$start TO $end",
                                                                                    style: Theme.of(context).textTheme.titleSmall),
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
                                                                                                              flex: 1,
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
                                                                                                            width: 8,
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
                                                                                          results.clear();
                                                                                          Navigator.pop(context);
                                                                                          parent.read<LearningDevelopmentBloc>().add(AddALearningDevttachment(attachmentModule: state.learningsAndDevelopment[index].conductedTraining!.id.toString(), filePaths: paths, categoryId: selectedAttachmentCategory!.id.toString(), token: token, profileId: profileId.toString()));
                                                                                        }
                                                                                      },
                                                                                      child: const Text("Submit")),
                                                                                )
                                                                              ]),
                                                                        );
                                                                      }),
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
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        child: state
                                                                        .learningsAndDevelopment[
                                                                            index]
                                                                        .attachments ==
                                                                    null ||
                                                                state
                                                                    .learningsAndDevelopment[
                                                                        index]
                                                                    .attachments!
                                                                    .isEmpty
                                                            ? const SizedBox()
                                                            : state
                                                                            .learningsAndDevelopment[
                                                                                index]
                                                                            .attachments !=
                                                                        null &&
                                                                    state
                                                                            .learningsAndDevelopment[
                                                                                index]
                                                                            .attachments!
                                                                            .length ==
                                                                        1
                                                                ?
                                                                ////Single Attachment view
                                                                SingleAttachment(
                                                                    view: () {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: ((context) => BlocProvider.value(
                                                                                    value: LearningDevelopmentBloc()..add(LearningDevelopmentViewAttachmentEvent(source: state.learningsAndDevelopment[index].attachments!.first.source!, filename: state.learningsAndDevelopment[index].attachments!.first.filename!)),
                                                                                    child: const LearningDevelopmentViewAttachment(),
                                                                                  ))));
                                                                    },
                                                                    onpressed: () {
                                                                      confirmAlert(
                                                                          context,
                                                                          () {
                                                                        parent.read<LearningDevelopmentBloc>().add(DeleteLearningDevAttachment(
                                                                            attachment: state
                                                                                .learningsAndDevelopment[
                                                                                    index]
                                                                                .attachments!
                                                                                .first,
                                                                            moduleId: state
                                                                                .learningsAndDevelopment[
                                                                                    index]
                                                                                .conductedTraining!
                                                                                .id!,
                                                                            profileId:
                                                                                profileId,
                                                                            token:
                                                                                token));
                                                                      }, "Delete?",
                                                                          "Confirm Delete?");
                                                                    },
                                                                    attachment: state
                                                                        .learningsAndDevelopment[
                                                                            index]
                                                                        .attachments!
                                                                        .first,
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
                                                                                    value: LearningDevelopmentBloc()..add(LearningDevelopmentViewAttachmentEvent(source: source, filename: filename)),
                                                                                    child: const LearningDevelopmentViewAttachment(),
                                                                                  ))));
                                                                    },
                                                                    profileId:
                                                                        profileId,
                                                                    token: token,
                                                                    moduleId: state
                                                                        .learningsAndDevelopment[
                                                                            index]
                                                                        .conductedTraining!
                                                                        .title!
                                                                        .id!,
                                                                    educationBloc:
                                                                        null,
                                                                    eligibilityBloc:
                                                                        null,
                                                                    learningDevelopmentBloc:
                                                                        BlocProvider.of<
                                                                                LearningDevelopmentBloc>(
                                                                            context),
                                                                    workHistoryBloc:
                                                                        null,
                                                                    blocId: 4,
                                                                    eligibilityName: state
                                                                        .learningsAndDevelopment[
                                                                            index]
                                                                        .conductedTraining!
                                                                        .title!
                                                                        .title!,
                                                                    attachments: state
                                                                        .learningsAndDevelopment[
                                                                            index]
                                                                        .attachments!,
                                                                  ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            } else {
                              return const EmptyData(
                                  message:
                                      "You don't have any Learning and Development added. Please click + to add.");
                            }
                          }
                          if (state is LearningDevelopmentErrorState) {
                            return (SomethingWentWrong(
                                message: state.message,
                                onpressed: () {
                                  context.read<LearningDevelopmentBloc>().add(
                                      GetLearningDevelopments(
                                          profileId: profileId, token: token));
                                }));
                          }
                          if (state is LearningDevelopmentAddingState) {
                            return AddLearningAndDevelopmentScreen(
                              token: token,
                              profileId: profileId,
                            );
                          }
                          if (state is LearningDevelopmentUpdatingState) {
                            return EditLearningAndDevelopmentScreen(
                              token: token,
                              profileId: profileId,
                            );
                          }
                          if (state is LearningDevelopmentAddingErrorState) {
                            return SomethingWentWrong(
                                message:
                                    "Error adding learning development. Please try again!",
                                onpressed: () {
                                  context.read<LearningDevelopmentBloc>().add(
                                      AddLearningAndDevelopment(
                                          learningDevelopement:
                                              state.learningDevelopement,
                                          profileId: profileId,
                                          token: token));
                                });
                          }
                          if (state is LearningDevelopmentUpdatingErrorState) {
                            return SomethingWentWrong(
                                message:
                                    "Error updating learning development. Please try again!",
                                onpressed: () {
                                  context.read<LearningDevelopmentBloc>().add(
                                      UpdateLearningDevelopment(
                                          learningDevelopement:
                                              state.learningDevelopement,
                                          profileId: profileId,
                                          token: token));
                                });
                          }
                          if (state is LearningDevelopmentDeletingErrorState) {
                            return SomethingWentWrong(
                                message:
                                    "Error deleting learning development. Please try again!",
                                onpressed: () {
                                  context.read<LearningDevelopmentBloc>().add(
                                      DeleteLearningDevelopment(
                                          hours: state.hours,
                                          trainingId: state.trainingId,
                                          sponsorId: state.sponsorId,
                                          profileId: profileId,
                                          token: token));
                                });
                          }
                          if (state is ShowAddFormErrorState) {
                            return SomethingWentWrong(
                                message: onError,
                                onpressed: () {
                                  context
                                      .read<LearningDevelopmentBloc>()
                                      .add(ShowAddLearningDevelopmentForm());
                                });
                          }
                          if (state is ShowEditFormErrorState) {
                            return SomethingWentWrong(
                                message: onError,
                                onpressed: () {
                                  context.read<LearningDevelopmentBloc>().add(
                                      ShowEditLearningDevelopmentForm(
                                          profileId: profileId,
                                          token: token,
                                          learningDevelopment:
                                              state.learningDevelopment,
                                          isOverseas: state.isOverseas));
                                });
                          }
                          if (state is ErrorDeleteLearningDevAttachment) {
                            return SomethingWentWrong(
                                message: onError,
                                onpressed: () {
                                  parent.read<LearningDevelopmentBloc>().add(
                                      DeleteLearningDevAttachment(
                                          attachment: state.attachment,
                                          moduleId: state.moduleId,
                                          profileId: profileId,
                                          token: token));
                                });
                          }
                          if (state is AddAttachmentError) {
                            return SomethingWentWrong(
                                message: onError,
                                onpressed: () {
                                  parent.read<LearningDevelopmentBloc>().add(
                                      AddALearningDevttachment(
                                          attachmentModule:
                                              state.attachmentModule,
                                          filePaths: state.filePaths,
                                          categoryId: state.categoryId,
                                          profileId: profileId.toString(),
                                          token: token));
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
