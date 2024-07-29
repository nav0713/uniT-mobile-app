import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:unit2/bloc/profile/workHistory/workHistory_bloc.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/utils/url_launcher_file_downloader.dart';
import 'package:unit2/widgets/error_state.dart';
import 'package:unit2/widgets/progress_hud.dart';

class WorkHistoryViewAttachment extends StatefulWidget {
  const WorkHistoryViewAttachment({super.key});

  @override
  State<WorkHistoryViewAttachment> createState() =>
      _WorkHistoryViewAttachmentState();
}

class _WorkHistoryViewAttachmentState extends State<WorkHistoryViewAttachment> {
  @override
  Widget build(BuildContext context) {

    String? filename;
    String? fileUrl;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await launchInBrowser(fileUrl!);
          },
          child: const Icon(Icons.file_download),
        ),
        appBar: AppBar(
          backgroundColor: primary,
          title: const Text("Attachment"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  context.read<WorkHistoryBloc>().add(
                      ShareAttachment(fileName: filename!, source: fileUrl!));
                },
                icon: const Icon(Icons.share)),
          ],
        ),
        body: LoadingProgress(
 
          child: BlocConsumer<WorkHistoryBloc, WorkHistoryState>(
            builder: (context, state) {
              if (state is WorkHistoryyAttachmentViewState) {
                fileUrl = state.fileUrl;
                filename = state.fileName;
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
              if (state is WorkHistoryErrorState) {
                return SomethingWentWrong(
                    message: state.message,
                    onpressed: () {
                      Navigator.pop(context);
                    });
              }
              return Container();
            },
            listener: (context, state) {
              if (state is WorkHistoryLoadingState) {
                final progress = ProgressHUD.of(context);
                progress!.showWithText("Please wait...");
              }
              if (state is WorkHistoryyAttachmentViewState ||
                  state is WorkHistoryErrorState) {
                final progress = ProgressHUD.of(context);
                progress!.dismiss();
              }
            },
          ),
        ));
  }
}
