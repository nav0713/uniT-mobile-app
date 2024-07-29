import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:unit2/model/profile/educational_background.dart';
import 'package:unit2/sevices/profile/education_services.dart';
import 'package:unit2/utils/request_permission.dart';
import '../../../model/profile/attachment.dart';
import '../../../utils/attachment_services.dart';
import '../../../utils/urls.dart';
part 'education_event.dart';
part 'education_state.dart';

class EducationBloc extends Bloc<EducationEvent, EducationState> {
  List<EducationalBackground> educationalBackgrounds = [];
  List<School> schools = [];
  List<Course> programs = [];
  List<Honor> honors = [];
  int? profileId;
  String? token;
  List<AttachmentCategory> attachmentCategories = [];
  EducationBloc() : super(EducationInitial()) {
    on<GetEducationalBackground>((event, emit) async {
      profileId = event.profileId;
      token = event.token;
      emit(EducationalBackgroundLoadingState());
      try {
        if (attachmentCategories.isEmpty) {
          attachmentCategories =
              await AttachmentServices.instance.getCategories();
        }
        if (educationalBackgrounds.isEmpty) {
          List<EducationalBackground> educations = await EducationService
              .instace
              .getEducationalBackground(event.profileId, event.token);
          educationalBackgrounds = educations;
          emit(EducationalBackgroundLoadedState(
              educationalBackground: educationalBackgrounds,
              attachmentCategory: attachmentCategories));
        } else {
          emit(EducationalBackgroundLoadedState(
              educationalBackground: educationalBackgrounds,
              attachmentCategory: attachmentCategories));
        }
      } catch (e) {
        emit(EducationalBackgroundErrorState(message: e.toString()));
      }
    });
    //// SHOW ADD FORM
    on<ShowAddEducationForm>((event, emit) async {
      emit(EducationalBackgroundLoadingState());
      try {
        if (schools.isEmpty) {
          List<School> newSchools = await EducationService.instace.getSchools();
          schools = newSchools;
        }
        if (programs.isEmpty) {
          List<Course> newPrograms =
              await EducationService.instace.getPrograms();
          programs = newPrograms;
        }
        if (honors.isEmpty) {
          List<Honor> newHonors = await EducationService.instace.getHonors();
          honors = newHonors;
        }
        emit(AddEducationState(
            schools: schools, programs: programs, honors: honors));
      } catch (e) {
        emit(ShowAddFormErrorState());
      }
    });
    ////Add
    on<AddEducation>((event, emit) async {
      try {
        emit(EducationalBackgroundLoadingState());
        Map<dynamic, dynamic> status = await EducationService.instace.add(
            honors: event.honors,
            educationalBackground: event.educationalBackground,
            token: event.token,
            profileId: event.profileId);
        if (status['success']) {
          EducationalBackground educationalBackground =
              EducationalBackground.fromJson(status['data']);
          educationalBackgrounds.add(educationalBackground);
          emit(EducationAddedState(response: status));
        } else {
          emit(EducationAddedState(response: status));
        }
      } catch (e) {
        emit(EducationAddingErrorState(
            educationalBackground: event.educationalBackground,
            honors: event.honors));
      }
    });
    ////Update
    on<UpdateEducation>((event, emit) async {
      try {
        emit(EducationalBackgroundLoadingState());
        Map<dynamic, dynamic> status = await EducationService.instace.edit(
            honors: event.honors,
            educationalBackground: event.educationalBackground,
            token: event.token,
            profileId: event.profileId);
        if (status['success']) {
          educationalBackgrounds.removeWhere(
              (element) => event.educationalBackground.id == element.id);
          EducationalBackground educationalBackground =
              EducationalBackground.fromJson(status['data']);
          educationalBackgrounds.add(educationalBackground);
          emit(EditedEducationState(response: status));
        } else {
          emit(EditedEducationState(response: status));
        }
      } catch (e) {
        emit(EducationUpdatingErrorState(
            educationalBackground: event.educationalBackground,
            honors: event.honors));
      }
    });
    ////LOAD
    on<LoadEducations>((event, emit) {
      emit(EducationalBackgroundLoadedState(
          educationalBackground: educationalBackgrounds,
          attachmentCategory: attachmentCategories));
    });
    //// SHOW EDIT FORM
    on<ShowEditEducationForm>((event, emit) async {
      try {
        emit(EducationalBackgroundLoadingState());
        if (schools.isEmpty) {
          List<School> newSchools = await EducationService.instace.getSchools();
          schools = newSchools;
        }
        if (programs.isEmpty) {
          List<Course> newPrograms =
              await EducationService.instace.getPrograms();
          programs = newPrograms;
        }
        if (honors.isEmpty) {
          List<Honor> newHonors = await EducationService.instace.getHonors();
          honors = newHonors;
        }
        emit(EditEducationState(
            schools: schools,
            programs: programs,
            honors: honors,
            educationalBackground: event.educationalBackground));
      } catch (e) {
        emit(ShowEditFormErrorState(
            educationalBackground: event.educationalBackground));
      }
    });
    ////delete
    on<DeleteEducation>((event, emit) async {
      try {
        emit(EducationalBackgroundLoadingState());
        final bool success = await EducationService.instace.delete(
            profileId: event.profileId,
            token: event.token,
            educationalBackground: event.educationalBackground);
        if (success) {
          educationalBackgrounds.removeWhere(
              (element) => element.id == event.educationalBackground.id);
          emit(EducationDeletedState(success: success));
        } else {
          emit(EducationDeletedState(success: success));
        }
      } catch (e) {
        emit(EducationDeletingErrorState(
            educationalBackground: event.educationalBackground));
      }
    });
    ////Add attachment
    on<AddEducationAttachment>((event, emit) async {
      emit(EducationalBackgroundLoadingState());
      EducationalBackground educationalBackground =
          educationalBackgrounds.firstWhere(
              (element) => element.id.toString() == event.attachmentModule);
      List<Attachment> attachments = [];
      try {
        Map<dynamic, dynamic> status = await AttachmentServices.instance
            .attachment(
                categoryId: event.categoryId,
                module: event.attachmentModule,
                paths: event.filePaths,
                token: event.token,
                profileId: event.profileId);

        if (status['success']) {
          status['data'].forEach((element) {
            Attachment newAttachment = Attachment.fromJson(element);
            attachments.add(newAttachment);
          });
          educationalBackground.attachments == null
              ? educationalBackground.attachments = attachments
              : educationalBackground.attachments = [
                  ...educationalBackground.attachments!,
                  ...attachments
                ];
          emit(EducationAddedState(response: status));
        } else {
          emit(EducationAddedState(response: status));
        }
      } catch (e) {
        emit(AddAttachmentError(attachmentModule: event.attachmentModule,filePaths: event.filePaths,categoryId: event.categoryId));
      }
    });
    on<DeleteEducationAttachment>((event, emit) async {
      emit(EducationalBackgroundLoadingState());
      try {
        final bool success = await AttachmentServices.instance.deleteAttachment(
            attachment: event.attachment,
            moduleId: event.moduleId,
            profileId: event.profileId.toString(),
            token: event.token);
        if (success) {
          final EducationalBackground educationalBackground =
              educationalBackgrounds
                  .firstWhere((element) => element.id == event.moduleId);
          educationalBackground.attachments
              ?.removeWhere((element) => element.id == event.attachment.id);
          educationalBackgrounds
              .removeWhere((element) => element.id == event.moduleId);
          educationalBackgrounds.add(educationalBackground);
          emit(EducationAttachmentDeletedState(success: success));
        } else {
          emit(EducationAttachmentDeletedState(success: success));
        }
      } catch (e) {
        emit(ErrorDeleteEducationAttachmentState(
            attachment: event.attachment,
            moduleId: event.moduleId.toString(),
            profileId: event.profileId.toString(),
            token: event.token));
      }
    });
    on<EducationViewAttachment>((event, emit) {
      String fileUrl =
          '${Url.instance.prefixHost()}${Url.instance.host()}/media/${event.source}';
      emit(EducationAttachmentViewState(
          fileUrl: fileUrl, fileName: event.fileName));
    });

    on<ShareAttachment>((event, emit) async {
      emit(EducationalBackgroundLoadingState());
      Directory directory;
      String? appDocumentPath;
      directory = await getApplicationDocumentsDirectory();
      appDocumentPath = directory.path;
      if (appDocumentPath.isEmpty) {
        if (await requestPermission(Permission.storage)) {
          directory = await getApplicationDocumentsDirectory();
          appDocumentPath = directory.path;
        }
      }
      try {
        final bool success = await AttachmentServices.instance
            .downloadAttachment(
                filename: event.fileName,
                source: event.source,
                downLoadDir: appDocumentPath);
        if (success) {
          final result = await Share.shareXFiles(
              [XFile("$appDocumentPath/${event.fileName}")]);
          if (result.status == ShareResultStatus.success) {
            Fluttertoast.showToast(msg: "Attachment shared successful");
            emit(EducationAttachmentViewState(
                fileUrl: event.source, fileName: event.fileName));
          } else {
            Fluttertoast.showToast(msg: "Attachment shared unsuccessful");
            emit(EducationAttachmentViewState(
                fileUrl: event.source, fileName: event.fileName));
          }
        } else {
          emit(EducationAttachmentViewState(
              fileUrl: event.source, fileName: event.fileName));
        }
      } catch (e) {
        emit(EducationalBackgroundErrorState(message: e.toString()));
      }
    });
  }
}
