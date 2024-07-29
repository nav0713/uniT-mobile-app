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
import 'package:unit2/model/profile/attachment.dart';
import 'package:unit2/model/profile/eligibility.dart';
import 'package:unit2/screens/profile/components/eligibility/add_modal.dart';
import 'package:unit2/screens/profile/components/eligibility/edit_modal.dart';
import 'package:unit2/theme-data.dart/box_shadow.dart';
import 'package:unit2/theme-data.dart/btn-style.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/theme-data.dart/form-style.dart';
import 'package:unit2/utils/global.dart';
import 'package:unit2/utils/text_container.dart';
import 'package:unit2/widgets/Leadings/add_leading.dart';
import 'package:unit2/widgets/Leadings/close_leading.dart';
import 'package:unit2/widgets/empty_data.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';
import 'package:unit2/widgets/titlesubtitle.dart';
import '../../../bloc/profile/eligibility/eligibility_bloc.dart';
import '../../../utils/alerts.dart';
import '../shared/multiple_attachment.dart';
import '../shared/single_attachment.dart';
import 'eligibility/eligibility_view_attachment.dart';

class EligibiltyScreen extends StatelessWidget {
  const EligibiltyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BuildContext parent = context;
    String? token;
    int? profileId;
    List<PlatformFile>? results = [];
    AttachmentCategory? selectedAttachmentCategory;
    List<AttachmentCategory> attachmentCategories = [];

    return PopScope(
      canPop: true,
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: context.watch<EligibilityBloc>().state is AddEligibilityState
                ? const Text("Add Eligiblity")
                : context.watch<EligibilityBloc>().state is EditEligibilityState
                    ? const Text("Edit Eligibilty")
                    : const Text(elibilityScreenTitle),
            centerTitle: true,
            backgroundColor: primary,
            actions:
                (context.watch<EligibilityBloc>().state is EligibilityLoaded)
                    ? [
                        AddLeading(onPressed: () {
                          context
                              .read<EligibilityBloc>()
                              .add(ShowAddEligibilityForm());
                        })
                      ]
                    : (context.watch<EligibilityBloc>().state
                                is AddEligibilityState ||
                            context.watch<EligibilityBloc>().state
                                is EditEligibilityState)
                        ? [
                            CloseLeading(onPressed: () {
                              context
                                  .read<EligibilityBloc>()
                                  .add(const LoadEligibility());
                            })
                          ]
                        : [],
          ),
          body: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoggedIn) {
                token = state.userData!.user!.login!.token;
                profileId = state.userData!.user!.login!.user!.profileId;
                return BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                  if (state is ProfileLoaded) {
                    return LoadingProgress(
                      child: BlocConsumer<EligibilityBloc, EligibilityState>(
                        listener: (context, state) {
                          if (state is EligibilityLoadingState) {
                            final progress = ProgressHUD.of(context);
                            progress!.showWithText("Please wait...");
                          }
                          if (state is EligibilityLoaded ||
                              state is ShowAddFormErrorState ||
                              state is AddEligibilityState ||
                              state is EditEligibilityState ||
                              state is EligibilityDeletedState ||
                              state is EligibilityAddedState ||
                              state is EligibilityEditedState ||
                              state is EligibilityErrorState ||
                              state is EligibilityAddingErrorState ||
                              state is EligibilityUpdatingErrorState ||
                              state is ShowEditFormErrorState ||
                              state is ErrorDeleteEligibyAttachmentState ||
                              state is EligibilityDeletingErrorState ||
                              state is AddAttachmentError) {
                            final progress = ProgressHUD.of(context);
                            progress!.dismiss();
                          }
                          ////DELETED STATE
                          if (state is EligibilityDeletedState) {
                            if (state.success) {
                              successAlert(context, "Deletion Successfull",
                                  "Eligibility has been deleted successfully",
                                  () {
                                Navigator.of(context).pop();
                                context
                                    .read<EligibilityBloc>()
                                    .add(const LoadEligibility());
                              });
                            } else {
                              errorAlert(context, "Deletion Failed",
                                  "Error deleting eligibility", () {
                                Navigator.of(context).pop();
                                context
                                    .read<EligibilityBloc>()
                                    .add(const LoadEligibility());
                              });
                            }
                          }
                          ////ATTACHMENT ADDED STATE

                          if (state is EligibilityAttachmentAddedState) {
                            if (state.response['success']) {
                              successAlert(context, "Adding Successfull!",
                                  state.response['message'], () {
                                Navigator.of(context).pop();
                                context
                                    .read<EligibilityBloc>()
                                    .add(const LoadEligibility());
                              });
                            } else {
                              errorAlert(context, "Adding Failed",
                                  "Something went wrong. Please try again.",
                                  () {
                                Navigator.of(context).pop();
                                context
                                    .read<EligibilityBloc>()
                                    .add(const LoadEligibility());
                              });
                            }
                          }
                          ////ADDED STATE
                          if (state is EligibilityAddedState) {
                            if (state.response['success']) {
                              successAlert(context, "Adding Successfull!",
                                  state.response['message'], () {
                                Navigator.of(context).pop();
                                context
                                    .read<EligibilityBloc>()
                                    .add(const LoadEligibility());
                              });
                            } else {
                              errorAlert(context, "Adding Failed",
                                  "Something went wrong. Please try again.",
                                  () {
                                Navigator.of(context).pop();
                                context
                                    .read<EligibilityBloc>()
                                    .add(const LoadEligibility());
                              });
                            }
                          }
                          ////UPDATED STATE
                          if (state is EligibilityEditedState) {
                            if (state.response['success']) {
                              successAlert(context, "Update Successfull!",
                                  state.response['message'], () {
                                Navigator.of(context).pop();
                                context
                                    .read<EligibilityBloc>()
                                    .add(const LoadEligibility());
                              });
                            } else {
                              errorAlert(context, "Update Failed",
                                  "Something went wrong. Please try again.",
                                  () {
                                Navigator.of(context).pop();
                                context
                                    .read<EligibilityBloc>()
                                    .add(const LoadEligibility());
                              });
                            }
                          }
                          ////ATTACHMENT DELETED STATE
                          if (state is EligibilitytAttachmentDeletedState) {
                            if (state.success) {
                              successAlert(context, "Deletion Successfull",
                                  "Attachment has been deleted successfully",
                                  () {
                                Navigator.of(context).pop();
                                context
                                    .read<EligibilityBloc>()
                                    .add(const LoadEligibility());
                              });
                            } else {
                              errorAlert(context, "Deletion Failed",
                                  "Error deleting Attachment", () {
                                Navigator.of(context).pop();
                                context
                                    .read<EligibilityBloc>()
                                    .add(const LoadEligibility());
                              });
                            }
                          }
                        },
                        builder: (context, state) {
                          return BlocBuilder<EligibilityBloc, EligibilityState>(
                            builder: (context, state) {
                              if (state is EligibilityLoaded) {
                                for (var cat in state.attachmentCategory) {
                                  if (cat.subclass!.id == 3) {
                                    attachmentCategories.add(cat);
                                  }
                                }
                                if (state.eligibilities.isNotEmpty) {
                                  return ListView.builder(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 10),
                                      itemCount: state.eligibilities.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        String title = state
                                            .eligibilities[index]
                                            .eligibility!
                                            .title;
                                        return AnimationConfiguration
                                            .staggeredList(
                                          position: index,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          child: FlipAnimation(
                                            child: Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return ZoomIn(
                                                            child: AlertDialog(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              title:
                                                                  const Column(
                                                                children: [
                                                                  Icon(
                                                                    FontAwesome5
                                                                        .certificate,
                                                                    color:
                                                                        primary,
                                                                    size: 32,
                                                                  ),
                                                                  Text(
                                                                    "Eligibility Details",
                                                                    style: TextStyle(
                                                                        color:
                                                                            primary,
                                                                        fontSize:
                                                                            18),
                                                                  ),
                                                                  Divider(),
                                                                ],
                                                              ),
                                                              content: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  TitleSubtitle(
                                                                      title: state
                                                                          .eligibilities[
                                                                              index]
                                                                          .eligibility!
                                                                          .title,
                                                                      sub:
                                                                          "Eligibility"),
                                                                  const Gap(3),
                                                                  TitleSubtitle(
                                                                      title: state
                                                                          .eligibilities[
                                                                              index]
                                                                          .licenseNumber!,
                                                                      sub:
                                                                          "License Number"),
                                                                  const Gap(3),
                                                                  TitleSubtitle(
                                                                      title: state
                                                                          .eligibilities[
                                                                              index]
                                                                          .rating
                                                                          .toString(),
                                                                      sub:
                                                                          "Rating"),
                                                                  SizedBox(
                                                                    child: state.eligibilities[index].examDate !=
                                                                            null
                                                                        ? Column(
                                                                            children: [
                                                                              const Gap(3),
                                                                              TitleSubtitle(title: dteFormat2.format(state.eligibilities[index].examDate!), sub: "Exam Date"),
                                                                            ],
                                                                          )
                                                                        : const SizedBox(),
                                                                  ),
                                                                  SizedBox(
                                                                    child: state.eligibilities[index].validityDate !=
                                                                            null
                                                                        ? Column(
                                                                            children: [
                                                                              const Gap(3),
                                                                              TitleSubtitle(title: dteFormat2.format(state.eligibilities[index].validityDate!), sub: "Validity Date"),
                                                                            ],
                                                                          )
                                                                        : const SizedBox(),
                                                                  ),
                                                                  const Gap(3),
                                                                  SizedBox(
                                                                    child: state.eligibilities[index].examAddress!.country!.name!.toLowerCase() !=
                                                                            'philippines'
                                                                        ? TitleSubtitle(
                                                                            title:
                                                                                state.eligibilities[index].examAddress!.country!.name!,
                                                                            sub:
                                                                                "Country",
                                                                          )
                                                                        : Column(
                                                                            children: [
                                                                              TitleSubtitle(
                                                                                title: state.eligibilities[index].examAddress!.cityMunicipality!.province!.region!.description!,
                                                                                sub: "Region",
                                                                              ),
                                                                              const Gap(3),
                                                                              TitleSubtitle(
                                                                                title: state.eligibilities[index].examAddress!.cityMunicipality!.province!.description!,
                                                                                sub: "Province",
                                                                              ),
                                                                              const Gap(3),
                                                                              TitleSubtitle(
                                                                                title: state.eligibilities[index].examAddress!.cityMunicipality!.description!,
                                                                                sub: "City/Municipality",
                                                                              ),
                                                                            ],
                                                                          ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12,
                                                        vertical: 8),
                                                    decoration: box1(),
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
                                                                      title,
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleMedium!
                                                                          .copyWith(
                                                                              fontWeight: FontWeight.w500,
                                                                              color: primary),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Text(
                                                                        "$licenseNumber: ${state.eligibilities[index].licenseNumber == null ? 'N/A' : state.eligibilities[index].licenseNumber.toString()}",
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .titleSmall),
                                                                    const SizedBox(
                                                                      height: 3,
                                                                    ),
                                                                    Text(
                                                                        "Rating : ${state.eligibilities[index].rating ?? 'N/A'}",
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .titleSmall),
                                                                  ]),
                                                            ),
                                                            AppPopupMenu<int>(
                                                              offset:
                                                                  const Offset(
                                                                      -10, -10),
                                                              elevation: 3,
                                                              onSelected:
                                                                  (value) {
                                                                ////delete eligibilty-= = = = = = = = =>>
                                                                if (value ==
                                                                    2) {
                                                                  confirmAlert(
                                                                      context,
                                                                      () {
                                                                    BlocProvider.of<EligibilityBloc>(context).add(DeleteEligibility(
                                                                        eligibilityId: state
                                                                            .eligibilities[
                                                                                index]
                                                                            .id!,
                                                                        profileId:
                                                                            profileId
                                                                                .toString(),
                                                                        token:
                                                                            token!));
                                                                  }, "Delete?",
                                                                      "Confirm Delete?");
                                                                }
                                                                if (value ==
                                                                    1) {
                                                                  ////edit eligibilty-= = = = = = = = =>>

                                                                  EligibityCert
                                                                      eligibityCert =
                                                                      state.eligibilities[
                                                                          index];

                                                                  context
                                                                      .read<
                                                                          EligibilityBloc>()
                                                                      .add(ShowEditEligibilityForm(
                                                                          eligibityCert:
                                                                              eligibityCert));
                                                                }
                                                                ////Attachment
                                                                if (value ==
                                                                    3) {
                                                                  results
                                                                      .clear();
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return ZoomIn(
                                                                          child:
                                                                              AlertDialog(
                                                                            contentPadding:
                                                                                const EdgeInsets.all(0),
                                                                            backgroundColor:
                                                                                Colors.grey.shade100,
                                                                            icon:
                                                                                const Icon(
                                                                              Icons.file_copy,
                                                                              size: 32,
                                                                              color: primary,
                                                                            ),
                                                                            title:
                                                                                const Text("File Attachment:"),
                                                                            content:
                                                                                StatefulBuilder(builder: (context, setState) {
                                                                              return Padding(
                                                                                padding: const EdgeInsets.all(16.0),
                                                                                child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                  const Divider(),
                                                                                  Text(
                                                                                    title,
                                                                                    style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500, color: primary),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    height: 5,
                                                                                  ),
                                                                                  Text("$licenseNumber: ${state.eligibilities[index].licenseNumber == null ? 'N/A' : state.eligibilities[index].licenseNumber.toString()}", style: Theme.of(context).textTheme.titleSmall),
                                                                                  const SizedBox(
                                                                                    height: 3,
                                                                                  ),
                                                                                  Text("Rating : ${state.eligibilities[index].rating ?? 'N/A'}", style: Theme.of(context).textTheme.titleSmall),
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
                                                                                          FilePickerResult? x;
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
                                                                                            setState(() {
                                                                                              results.clear();
                                                                                            });
                                                                                            Navigator.pop(context);
                                                                                            parent.read<EligibilityBloc>().add(AddEligibiltyAttachment(attachmentModule: state.eligibilities[index].id.toString(), filePaths: paths, categoryId: selectedAttachmentCategory!.id.toString(), token: token!, profileId: profileId.toString()));
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
                                                                    text:
                                                                        "Update",
                                                                    value: 1,
                                                                    icon: Icons
                                                                        .edit),
                                                                popMenuItem(
                                                                    text:
                                                                        "Remove",
                                                                    value: 2,
                                                                    icon: Icons
                                                                        .delete),
                                                                popMenuItem(
                                                                    text:
                                                                        "Attach",
                                                                    value: 3,
                                                                    icon: Icons
                                                                        .attach_file),
                                                              ],
                                                              icon: const Icon(
                                                                Icons.more_vert,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              tooltip:
                                                                  "Options",
                                                            )
                                                          ],
                                                        ),
                                                        const Divider(),
                                                        ////Show Attachments
                                                        SizedBox(
                                                            width: screenWidth,
                                                            child: state.eligibilities[index].attachments ==
                                                                        null ||
                                                                    state
                                                                        .eligibilities[
                                                                            index]
                                                                        .attachments!
                                                                        .isEmpty
                                                                ? const SizedBox()
                                                                : state.eligibilities[index].attachments !=
                                                                            null &&
                                                                        state.eligibilities[index].attachments!.length ==
                                                                            1
                                                                    ?
                                                                    ////Single Attachment view
                                                                    SingleAttachment(
                                                                        view:
                                                                            () {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: ((context) => BlocProvider.value(
                                                                                        value: EligibilityBloc()..add(EligibiltyViewAttachmentEvent(source: state.eligibilities[index].attachments!.first.source!, filename: state.eligibilities[index].attachments!.first.filename!)),
                                                                                        child: const EligibilityViewAttachment(),
                                                                                      ))));
                                                                        },
                                                                        onpressed:
                                                                            () {
                                                                          confirmAlert(
                                                                              context,
                                                                              () {
                                                                            parent.read<EligibilityBloc>().add(DeleteEligibyAttachment(
                                                                                attachment: state.eligibilities[index].attachments!.first,
                                                                                moduleId: state.eligibilities[index].id.toString(),
                                                                                profileId: profileId.toString(),
                                                                                token: token!));
                                                                          }, "Delete?",
                                                                              "Confirm Delete?");
                                                                        },
                                                                        attachment: state
                                                                            .eligibilities[index]
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
                                                                                        value: EligibilityBloc()..add(EligibiltyViewAttachmentEvent(source: source, filename: filename)),
                                                                                        child: const EligibilityViewAttachment(),
                                                                                      ))));
                                                                        },
                                                                        profileId:
                                                                            profileId!,
                                                                        token:
                                                                            token!,
                                                                        moduleId: state
                                                                            .eligibilities[index]
                                                                            .eligibility!
                                                                            .id,
                                                                        educationBloc:
                                                                            null,
                                                                        learningDevelopmentBloc:
                                                                            null,
                                                                        workHistoryBloc:
                                                                            null,
                                                                        eligibilityBloc:
                                                                            BlocProvider.of<EligibilityBloc>(context),
                                                                        blocId:
                                                                            2,
                                                                        eligibilityName: state
                                                                            .eligibilities[index]
                                                                            .eligibility!
                                                                            .title,
                                                                        attachments: state
                                                                            .eligibilities[index]
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
                                          "You don't have any eligibilities added. Please click + to add");
                                }
                              }
                              if (state is EditEligibilityState) {
                                return EditEligibilityScreen(
                                    profileId: profileId!,
                                    token: token!,
                                    eligibityCert: state.eligibityCert);
                              }
                              if (state is AddEligibilityState) {
                                return AddEligibilityScreen(
                                  token: token!,
                                  profileId: profileId!,
                                );
                              }
                              if (state is EligibilityErrorState) {
                                return SomethingWentWrong(
                                    message: state.message,
                                    onpressed: () {
                                      context.read<EligibilityBloc>().add(
                                          GetEligibilities(
                                              token: token!,
                                              profileId: profileId!));
                                    });
                              }
                              if (state is EligibilityAddingErrorState) {
                                return SomethingWentWrong(
                                    message:
                                        "Error Adding Eligibility. Please try again!",
                                    onpressed: () {
                                      context.read<EligibilityBloc>().add(
                                          AddEligibility(
                                              eligibityCert:
                                                  state.eligibityCert,
                                              profileId: profileId!.toString(),
                                              token: token!));
                                    });
                              }
                              if (state is EligibilityUpdatingErrorState) {
                                return SomethingWentWrong(
                                    message:
                                        "Error Updating Eligibility. Please try again!",
                                    onpressed: () {
                                      context.read<EligibilityBloc>().add(
                                          UpdateEligibility(
                                              eligibityCert:
                                                  state.eligibityCert,
                                              oldEligibility:
                                                  state.intOldEligibilityId,
                                              profileId: profileId!.toString(),
                                              token: token!));
                                    });
                              }
                              if (state is EligibilityDeletingErrorState) {
                                return SomethingWentWrong(
                                    message:
                                        "Error Deleting Eligibility. Please try again",
                                    onpressed: () {
                                      context.read<EligibilityBloc>().add(
                                          DeleteEligibility(
                                              eligibilityId:
                                                  state.eligibilityId,
                                              profileId: profileId!.toString(),
                                              token: token!));
                                    });
                              }
                              if (state is ShowAddFormErrorState) {
                                return SomethingWentWrong(
                                    message:
                                        "Something went wrong. Please try again!",
                                    onpressed: () {
                                      context
                                          .read<EligibilityBloc>()
                                          .add(ShowAddEligibilityForm());
                                    });
                              }
                              if (state is ShowEditFormErrorState) {
                                return SomethingWentWrong(
                                    message: onError,
                                    onpressed: () {
                                      context.read<EligibilityBloc>().add(
                                          ShowEditEligibilityForm(
                                              eligibityCert:
                                                  state.eligibityCert));
                                    });
                              }
                              if (state is ErrorDeleteEligibyAttachmentState) {
                                return SomethingWentWrong(
                                    message: onError,
                                    onpressed: () {
                                      parent.read<EligibilityBloc>().add(
                                          DeleteEligibyAttachment(
                                              attachment: state.attachment,
                                              moduleId: state.moduleId,
                                              profileId: profileId.toString(),
                                              token: token!));
                                    });
                              }
                              if (state is AddAttachmentError) {
                                return SomethingWentWrong(
                                    message: onError,
                                    onpressed: () {
                                      parent.read<EligibilityBloc>().add(
                                          AddEligibiltyAttachment(
                                              attachmentModule:
                                                  state.attachmentModule,
                                              filePaths: state.filePaths,
                                              categoryId: state.categoryId,
                                              token: token!,
                                              profileId: profileId.toString()));
                                    });
                              }
                              return Container(
                                color: Colors.grey.shade200,
                              );
                            },
                          );
                        },
                      ),
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
