import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:unit2/bloc/sos/sos_bloc.dart';
import 'package:unit2/screens/sos/components/acknnowledge.dart';
import 'package:unit2/screens/sos/components/add_mobile.dart';
import 'package:unit2/screens/sos/components/request_sos.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';

import '../../utils/global.dart';
import '../../widgets/wave.dart';
import 'components/sos_received.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  Timer? timer;

  @override
  void dispose() {
    timer != null ? timer!.cancel() : timer = null;
    super.dispose();
  }

  @override
  void initState() {
    timer = Timer(Duration.zero, () {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(title:const Text("SOS"),backgroundColor: primary,centerTitle: true,),
      resizeToAvoidBottomInset: true,
      body: LoadingProgress(
        child: BlocConsumer<SosBloc, SosState>(
          listener: (context, state) {
            if (state is ErrorState) {
              final progress = ProgressHUD.of(context);
              progress!.dismiss();
            }
            ////loading state
            if (state is LoadingState) {
              final progress = ProgressHUD.of(context);
              progress!.showWithText(state.message);
            }
            //// dismiss progress
            if (state is ErrorState || state is SOSReceivedState || state is RequestSosState || state is UserLocationLoaded || state is SoSAcknowledgementConfirm) {
              final progress = ProgressHUD.of(context);
              progress!.dismiss();
            }
          },
          builder: (context, state) {
            //// error state
            if (state is ErrorState) {
              timer!.cancel();
              return SomethingWentWrong(
                  message: state.message,
                  onpressed: () {
                    context.read<SosBloc>().add(LoadUserLocation());
                  });
            } //// user location loaded
            if (state is UserLocationLoaded) {
              return AddMobile();

              //// request sos state
            }
            if (state is RequestSosState) {
              return const RequestSOS();
            }
            //// received sos state
            if (state is SOSReceivedState) {
              timer = Timer.periodic(const Duration(seconds: 10), (timer) {
              context.read<SosBloc>().add(
                    CheckAcknowledgement(sessionToken: state.sessionToken));
              });
              return SOSreceived(onpressed: () async {
                timer!.cancel();
                await SOS!.delete('session_token');
               Navigator.pop(context);
              });
            }
            ///// sos acknowledge and confirm
            if (state is SoSAcknowledgementConfirm) {
              return SosAcknowledged(
                  onpressed: () async {
                    timer!.cancel();
                    await SOS!.delete('session_token');
                  Navigator.pop(context);
                  },
                  sessionData: state.sessionData);
            }
            return SizedBox(
              height: screenHeight,
              child: Stack(children: [
       
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: WaveReverse(height: blockSizeVertical * 8))
              ]),
            );
          },
        ),
      ),
    ));
  }
}
