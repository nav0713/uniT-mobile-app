import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:fluttericon/web_symbols_icons.dart';
import 'package:gap/gap.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:unit2/bloc/communication/communication_bloc.dart';
import 'package:unit2/theme-data.dart/box_shadow.dart';
import 'package:unit2/theme-data.dart/btn-style.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/theme-data.dart/form-style.dart';
import 'package:unit2/utils/alerts.dart';
import 'package:unit2/utils/global.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';
import 'package:unit2/widgets/round_clipper.dart';

class ViewMessageScreen extends StatelessWidget {
  const ViewMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String? comment;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Message details"),
        elevation: 0,
        backgroundColor: primary,
      ),
      body: LoadingProgress(
          child: BlocConsumer<CommunicationBloc, CommunicationState>(
        listener: ((context, state) {
          if (state is MessageLoadingState) {
            final progress = ProgressHUD.of(context);
            progress!.showWithText("Please wait...");
          }
          if (state is SingleMessageLoaded ||
              state is MessageAcknowledgeState ||
              state is MessagesErrorState) {
            final progress = ProgressHUD.of(context);
            progress!.dismiss();
          }
          if (state is MessageAcknowledgeState) {
            if (state.messageUpdateResponse.status) {
              successAlert(context, "Acknowledge Success",
                  state.messageUpdateResponse.message, () {
                Navigator.of(context).pop();
                context.read<CommunicationBloc>().add(ViewMessage(
                    message: state.messageUpdateResponse.responseMessage,
                    id: state.id,
                    token: state.token,
                    currentPage: state.currentpage));

                // Navigator.pushReplacementNamed(context, "/commucation").then((value){
                //   context.read<CommunicationBloc>().add(NextPrev(page: state.currentpage));
                // });
              });
            } else {
              errorAlert(context, "Acknowledge failed!",
                  "Something went wrong. Please try again.", () {
                Navigator.of(context).pop();
                context.read<CommunicationBloc>().add(ViewMessage(
                    message: state.messageUpdateResponse.responseMessage,
                    id: state.id,
                    token: state.token,
                    currentPage: state.currentpage));
              });
            }
          }
        }),
        builder: (context, state) {
          if (state is SingleMessageLoaded) {
            return SizedBox(
              height: screenHeight - 150,
              width: screenWidth,
              child: Stack(
                children: [
                  ClipPath(
                    clipper: RoundShape(),
                    child: Container(
                      color: primary,
                      height: 150,
                    ),
                  ),
                  Positioned(
                    top: 30,
                    left: screenWidth * .05,
                    child: Container(
                      height: state.message.deliveryType!.message!
                                  .contentDetails!.length <
                              150
                          ? screenHeight * .60
                          : screenHeight * .75,
                      padding: const EdgeInsets.all(24),
                      width: screenWidth * .90,
                      decoration: box1(),
                      child: ListView(
                        children: [
                          Align(
                              alignment: Alignment.topLeft,
                              child: Row(
                                children: [
                                  const Icon(
                                    Typicons.comment,
                                    size: 18,
                                  ),
                                  const Gap(10),
                                  Text("Message Content",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.bold))
                                ],
                              )),
                          const Gap(10),
                          Text(
                            state
                                .message.deliveryType!.message!.contentDetails!,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const Divider(),
                          Row(
                            children: [
                              const Icon(
                                Entypo.newspaper,
                                size: 16,
                              ),
                              const Gap(10),
                              Text(
                                "Documents Attachment(s):",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Text("N/A"),
                          const Divider(),
                          const Gap(10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    WebSymbols.clock,
                                    size: 15,
                                  ),
                                  const Gap(10),
                                  Text("Received Date:",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const Gap(10),
                              Text(
                                  GetTimeAgo.parse(
                                      state.message.sentBySystemAt!),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith()),
                            ],
                          ),
                          const Divider(),
                          const Gap(10),
                          SizedBox(
                            child: state.message.dateAcknowledged != null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            WebSymbols.clock,
                                            size: 15,
                                          ),
                                          const Gap(10),
                                          Text("Acknowledged Date:",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                        ],
                                      ),
                                      const Gap(10),
                                      Text(
                                          (dteFormat2.format(DateTime.parse(
                                              state
                                                  .message.dateAcknowledged!))),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge!
                                              .copyWith()),
                                      const Divider(),
                                      Row(
                                        children: [
                                          const Icon(
                                            FontAwesome.comment_empty,
                                            size: 15,
                                          ),
                                          const Gap(10),
                                          Text("Comments:",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                        ],
                                      ),
                                      const Gap(5),
                                      Text(state.message.comments ??= "N/A",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge!
                                              .copyWith()),
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FormBuilderTextField(
                                          onChanged: ((value) =>
                                              comment = value),
                                          maxLines: 5,
                                          decoration: normalTextFieldStyle(
                                              "Comments", "Comments"),
                                          name: "comments"),
                                      const Gap(20),
                                      SizedBox(
                                        height: 40,
                                        child: ElevatedButton(
                                            style: mainBtnStyle(primary,
                                                Colors.transparent, second),
                                            onPressed: () {
                                              context
                                                  .read<CommunicationBloc>()
                                                  .add(AcknowledgeMessage(
                                                      currentpage:
                                                          state.currentPage,
                                                      id: state.id,
                                                      token: state.token,
                                                      messageId:
                                                          state.message.id!,
                                                      dateAcknowledged:
                                                          DateTime.now()
                                                              .toString(),
                                                      comments: comment));
                                            },
                                            child: const Text("Acknowledge")),
                                      )
                                    ],
                                  ),
                          ),
                          const Gap(20),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }
          if (state is MessagesErrorState) {
            return SomethingWentWrong(message: "", onpressed: () {});
          }
          return Container();
        },
      )),
    );
  }
}


