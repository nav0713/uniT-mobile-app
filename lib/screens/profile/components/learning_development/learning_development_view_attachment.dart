import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:unit2/bloc/profile/learningDevelopment/learning_development_bloc.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/utils/url_launcher_file_downloader.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';

class LearningDevelopmentViewAttachment extends StatefulWidget {
  const LearningDevelopmentViewAttachment({super.key});

  @override
  State<LearningDevelopmentViewAttachment> createState() =>
      _LearningDevelopmentViewAttachmentState();
}

class _LearningDevelopmentViewAttachmentState
    extends State<LearningDevelopmentViewAttachment> {
  @override
  Widget build(BuildContext context) {
    String? fileUrl;
    String? filename;
     
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: primary,
          onPressed: () async {
            await launchInBrowser(fileUrl!);
          },
          child: const Icon(Icons.file_download,color: Colors.white,),
        ),
        appBar: AppBar(
          backgroundColor: primary,
          title: const Text("Attachment"),
          centerTitle: true,
          actions: context.watch<LearningDevelopmentBloc>().state is LearningAndDevelopmentAttachmentViewState ? [
            IconButton(onPressed: () {
              context.read<LearningDevelopmentBloc>().add(ShareAttachment(fileName: filename!, source: fileUrl!));
            }, icon: const Icon(Icons.share)),
          ]:[]
        ),
        body: LoadingProgress(

          child:
              BlocConsumer<LearningDevelopmentBloc, LearningDevelopmentState>(
            builder: (context, state) {
              if (state is LearningAndDevelopmentAttachmentViewState) {
                fileUrl = state.fileUrl;
                filename = state.filename;
                bool isPDF = state.fileUrl[state.fileUrl.length - 1] == 'f'
                    ? true
                    : false;
                return SizedBox(
                  child: isPDF
                      ? SfPdfViewer.network(
                        
                          state.fileUrl,
                         onDocumentLoadFailed: (details) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AlertDialog(
                                        title: const Text(
                                            "Error opening document. Please check your internet connection!"),
                                        content: Container(),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                               Navigator.pop(context);
                                              },
                                              child: const Text("Try again"))
                                        ],
                                      ),
                                    ],
                                  );
                                });
                          },
                          
                        )
                      : Center(
                          child: CachedNetworkImage(
                            progressIndicatorBuilder: (context, url, progress) {
                              return const SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: CircularProgressIndicator(
                                    color: primary,
                                  ));
                            },
                                 errorWidget: ((context, url, error) => Expanded(
                              child: SomethingWentWrong(message: "Please check your internet connection.", onpressed: (){
          
                                 return       Navigator.pop(context);
                              }),
                            )),
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.fill)),
                            ),
                            imageUrl: state.fileUrl,
                            width: double.infinity,
                            height: 400,
                            fit: BoxFit.cover,
                          ),
                        ),
                );
              }
              return Container();
            },
            listener: (context, state) {
             
              if (state is LearningDevelopmentLoadingState) {
                final progress = ProgressHUD.of(context);
                progress!.showWithText("Please wait...");
              }
              if (state is LearningAndDevelopmentAttachmentViewState ||
                  state is LearningDevelopmentErrorState) {
                final progress = ProgressHUD.of(context);
                progress!.dismiss();
              }
            },
          ),
        ));
  }
}
