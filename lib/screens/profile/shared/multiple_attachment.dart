import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:unit2/bloc/profile/education/education_bloc.dart';
import 'package:unit2/bloc/profile/eligibility/eligibility_bloc.dart';
import 'package:unit2/bloc/profile/learningDevelopment/learning_development_bloc.dart';
import 'package:unit2/bloc/profile/workHistory/workHistory_bloc.dart';
import 'package:unit2/utils/global_context.dart';

import '../../../model/profile/attachment.dart';
import '../../../theme-data.dart/box_shadow.dart';
import '../../../theme-data.dart/colors.dart';
import '../../../utils/alerts.dart';
import '../../../utils/global.dart';

class MultipleAttachments extends StatelessWidget {
  final Function(String source, String fileName) viewAttachment;
  final List<Attachment> attachments;
  final String eligibilityName;
  final EducationBloc? educationBloc;
  final EligibilityBloc? eligibilityBloc;
  final LearningDevelopmentBloc? learningDevelopmentBloc;
  final WorkHistoryBloc? workHistoryBloc;
  final int blocId;
  final int moduleId;
  final int profileId;
  final String token;
  const MultipleAttachments(
      {super.key,
      required this.viewAttachment,
      required this.blocId,
      required this.educationBloc,
      required this.eligibilityBloc,
      required this.learningDevelopmentBloc,
      required this.workHistoryBloc,
      required this.attachments,
      required this.eligibilityName,
      required this.moduleId,
      required this.profileId,
      required this.token});

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      child: Row(
        children: [
          Flexible(
              flex: 3,
              child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration:
                      box1().copyWith(color: Colors.grey.shade300, boxShadow: []),
                  child: AutoSizeText(
                 
                    attachments.first.filename??"",
                    wrapWords: false,
                   maxLines: 1,
                  ))),
          const SizedBox(
            width: 8,
          ),
          Flexible(
              child: FittedBox(
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration:
                  box1().copyWith(color: Colors.grey.shade300, boxShadow: []),
              child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return FadeInDown(
                          child: AlertDialog(
                              title: Text(
                                "$eligibilityName  Attachments",
                                textAlign: TextAlign.center,
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: attachments.map((e) {
                                  String ext = e.filename!
                                      .substring(e.filename!.lastIndexOf("."));
                                
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: SizedBox(
                                              child: ext == '.pdf'
                                                  ? SvgPicture.asset(
                                                      'assets/svgs/pdf.svg',
                                                      height: blockSizeVertical * 5,
                                                      allowDrawingOutsideViewBox:
                                                          true,
                                                    )
                                                  : ext == '.png'
                                                      ? SvgPicture.asset(
                                                          'assets/svgs/png.svg',
                                                          height:
                                                              blockSizeVertical *
                                                                  5.5,
                                                          allowDrawingOutsideViewBox:
                                                              true,
                                                        )
                                                      : ext == '.jpg'
                                                          ? SvgPicture.asset(
                                                              'assets/svgs/jpg.svg',
                                                              height:
                                                                  blockSizeVertical *
                                                                      5,
                                                              allowDrawingOutsideViewBox:
                                                                  true,
                                                            )
                                                          : SvgPicture.asset(
                                                              'assets/svgs/jpg.svg',
                                                              height:
                                                                  blockSizeVertical *
                                                                      5,
                                                              allowDrawingOutsideViewBox:
                                                                  true,
                                                            ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Flexible(
                                            flex: 4,
                                            child: Tooltip(
                                                message: e.filename,
                                                child: GestureDetector(
                                                  onTap: (){
                                                    viewAttachment(e.source!,e.filename!);
                                                  },
                                                  child: Text(
                                                    e.filename!,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                )),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Flexible(
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  child: IconButton(
                                                      icon: const Icon(
                                                        Icons.delete,
                                                        color: primary,
                                                      ),
                                                      onPressed: () {
                                                        confirmAlert(context, () {
                                                          if (blocId == 1) {
                                                            Navigator.pop(
                                                                NavigationService
                                                                    .navigatorKey
                                                                    .currentContext!);
                                                            educationBloc!.add(
                                                                DeleteEducationAttachment(
                                                                    attachment: e,
                                                                    moduleId:
                                                                        moduleId,
                                                                    profileId:
                                                                        profileId,
                                                                    token: token));
                                                          } else if (blocId == 2) {
                                                            Navigator.pop(
                                                                NavigationService
                                                                    .navigatorKey
                                                                    .currentContext!);
                                                            eligibilityBloc!.add(
                                                                DeleteEligibyAttachment(
                                                                    attachment: e,
                                                                    moduleId: moduleId
                                                                        .toString(),
                                                                    profileId: profileId
                                                                        .toString(),
                                                                    token: token));
                                                          } else if (blocId == 3) {
                                                            Navigator.pop(
                                                                NavigationService
                                                                    .navigatorKey
                                                                    .currentContext!);
                                                            workHistoryBloc!.add(
                                                                DeleteWorkHistoryAttachment(
                                                                    attachment: e,
                                                                    moduleId:
                                                                        moduleId,
                                                                    profileId:
                                                                        profileId,
                                                                    token: token));
                                                          } else {
                                                            Navigator.pop(
                                                                NavigationService
                                                                    .navigatorKey
                                                                    .currentContext!);
                                                            learningDevelopmentBloc!.add(
                                                                DeleteLearningDevAttachment(
                                                                    attachment: e,
                                                                    moduleId:
                                                                        moduleId,
                                                                    profileId:
                                                                        profileId,
                                                                    token: token));
                                                          }
                                                        }, "Delete?",
                                                            "Confirm Delete?");
                                                      }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider()
                                    ],
                                  );
                                }).toList(),
                              )),
                        );
                      });
                },
                child: const Row(
                  children: [
                    Text("  See more.."),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
