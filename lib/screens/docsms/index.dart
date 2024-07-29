import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:unit2/bloc/docsms/docsms_bloc.dart';
import 'package:unit2/screens/docsms/components/request_receipt.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';

class AutoReceiveDocument extends StatefulWidget {
  const AutoReceiveDocument({super.key});

  @override
  State<AutoReceiveDocument> createState() => _AutoReceiveDocumentState();
}

class _AutoReceiveDocumentState extends State<AutoReceiveDocument> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingProgress(
     
        child: BlocConsumer<DocsmsBloc, DocsmsState>(
          listener: (context, state) {
            if (state is DocSmsLoadingState) {
              final progress = ProgressHUD.of(context);
              progress!.showWithText("Please wait...");
            }
            if (state is DocSmsErrorState || state is DocumentLoaded) {
              final progress = ProgressHUD.of(context);
              progress!.dismiss();
            }
          },
          builder: (context, state) {
            if (state is DocumentLoaded) {
              return const RequetAutoReceipt();
            }if(state is DocSmsErrorState){
              return SomethingWentWrong(message: state.message.toString(), onpressed: (){});
            }
            return Container();
          },
        ),
      ),
    );
  }
}
