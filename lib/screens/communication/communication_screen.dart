import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:gap/gap.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:unit2/bloc/communication/communication_bloc.dart';
import 'package:unit2/bloc/user/user_bloc.dart';
import 'package:unit2/screens/communication/view_message.dart';
import 'package:unit2/theme-data.dart/box_shadow.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/utils/global.dart';
import 'package:unit2/widgets/empty_data.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';

class CommunicationsScreen extends StatefulWidget {
  const CommunicationsScreen({super.key});

  @override
  State<CommunicationsScreen> createState() => _CommunicationsScreenState();
}

class _CommunicationsScreenState extends State<CommunicationsScreen> {
  @override
  Widget build(BuildContext context) {
    int? profileId;
    String? token;
    return Scaffold(
      backgroundColor: primary,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: primary,
          elevation: 0,
          centerTitle: true,
          title: const Text("Communications"),
        ),
      ),
      body: LoadingProgress(child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoggedIn) {
            token = state.userData!.user!.login!.token;
            profileId = state.userData!.user!.login!.user!.profileId!;
            return BlocConsumer<CommunicationBloc, CommunicationState>(
              listener: (context, state) {
                if (state is MessageLoadingState) {
                  final progress = ProgressHUD.of(context);
                  progress!.showWithText("Please wait...");
                }
                if (state is MessagesLoaded ||
                    state is MessagesErrorState ||
                    state is PaginationNavigationErrorState) {
                  final progress = ProgressHUD.of(context);
                  progress!.dismiss();
                }
              },
              builder: (context, state) {
                if (state is MessagesLoaded) {
    
                   return Container(
                    decoration: box1().copyWith(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25))),
                    child: state.messageMeta.messages.isNotEmpty? Column(
                      children: [
                        const Gap(30),
                        Expanded(child:
                            StatefulBuilder(builder: (context, setState) {
                          return ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const Gap(1),
                              itemCount: state.messageMeta.messages.length,
                              itemBuilder: (BuildContext context, index) {
                                String time = GetTimeAgo.parse(state.messageMeta
                                    .messages[index].sentBySystemAt!);
                                bool isAcknowledge = state.messageMeta
                                            .messages[index].dateAcknowledged !=
                                        null
                                    ? true
                                    : false;
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                  return AnimationConfiguration.staggeredList(
                                    duration: const Duration(milliseconds: 300),
                                    position: index,
                                    child: FlipAnimation(
                                      child: ListTile(
                                          onTap: () {
                                            setState(() {
                                              isAcknowledge = true;
                                            });
                                            Navigator.push(context,
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                              return BlocProvider<
                                                  CommunicationBloc>.value(
                                                value: CommunicationBloc()
                                                  ..add(ViewMessage(
                                                      message: state.messageMeta
                                                          .messages[index],
                                                      token: state.token,
                                                      id: state.id,
                                                      currentPage:
                                                          state.currentPage)),
                                                child: const ViewMessageScreen(),
                                              );
                                            }));
                                          },
                                          minLeadingWidth: 1,
                                          dense: true,
                                          contentPadding: const EdgeInsets.fromLTRB(
                                              10, 0, 50, 0),
                                          leading: !isAcknowledge
                                              ? const CircleAvatar(
                                                  radius: 5,
                                                  backgroundColor: Colors.black26,
                                                )
                                              : const Gap(1),
                                          title: Text(
                                              state
                                                  .messageMeta
                                                  .messages[index]
                                                  .deliveryType!
                                                  .message!
                                                  .contentDetails!,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: !isAcknowledge
                                                  ? const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black87,
                                                      fontSize: 14)
                                                  : const TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 14)),
                                          subtitle: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              const Gap(10),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    time,
                                                    style: !isAcknowledge
                                                        ? const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black87,
                                                            fontSize: 10)
                                                        : const TextStyle(
                                                            color: Colors.black54,
                                                            fontSize: 10),
                                                  ),
                                                  const Gap(5),
                                                  const Icon(
                                                    Entypo.right_open_mini,
                                                    size: 18,
                                                    weight: 10,
                                                  )
                                                ],
                                              ),
                                              const Divider(
                                                thickness: 1.5,
                                              )
                                            ],
                                          )),
                                    ),
                                  );
                                });
                              });
                        })),
                        const Gap(30),
                        SizedBox(
                          width: screenWidth * .90,
                          child: NumberPaginator(
                            config: const NumberPaginatorUIConfig(
                                mainAxisAlignment: MainAxisAlignment.start,
                                buttonSelectedForegroundColor: Colors.white,
                                buttonSelectedBackgroundColor: primary,
                                buttonUnselectedForegroundColor: primary,
                                height: 48,
                                mode: ContentDisplayMode.numbers),
                            initialPage: state.currentPage,
                            // by default, the paginator shows numbers as center content
                            numberPages: state.messageMeta.pages!,
                            onPageChange: (int index) {
                              context
                                  .read<CommunicationBloc>()
                                  .add(NextPrev(page: index));
                            },
                          ),
                        ),
                        const Gap(20)
                      ],
                    ):const EmptyData(message: "No message(s) at the moment")
                  );
             
                }
                if (state is MessagesErrorState) {
                  return Container(
                    height: screenHeight,
                    decoration: box1().copyWith(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25))),
                    child: SomethingWentWrong(
                        message: "Something went wrong. Please try again!",
                        onpressed: () {
                          context.read<CommunicationBloc>().add(GetAllMessages(
                              profileId: profileId!, token: token!, page: 1));
                        }),
                  );
                }
                if (state is PaginationNavigationErrorState) {
                  return Container(
                    height: screenHeight,
                    decoration: box1().copyWith(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25))),
                    child: SomethingWentWrong(
                        message: "Something went wrong. Please try again!",
                        onpressed: () {
                          context
                              .read<CommunicationBloc>()
                              .add(NextPrev(page: state.currentPage));
                        }),
                  );
                }
                if (state is MessageLoadingState) {
                  return Container(
                    decoration: box1().copyWith(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25))),
                    height: screenHeight,
                  );
                }
                return Container();
              },
            );
          }
          return Container();
        },
      )),
    );
  }
}
