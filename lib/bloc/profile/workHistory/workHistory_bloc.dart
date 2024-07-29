import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:unit2/model/profile/work_history.dart';
import 'package:unit2/model/utils/agency.dart';
import 'package:unit2/model/utils/agency_position.dart';
import 'package:unit2/model/utils/position.dart';
import 'package:unit2/sevices/profile/work_history_services.dart';
import 'package:unit2/utils/profile_utilities.dart';
import '../../../model/profile/attachment.dart';

import '../../../model/utils/category.dart';
import '../../../utils/attachment_services.dart';
import '../../../utils/request_permission.dart';
import '../../../utils/urls.dart';
part 'workHistory_event.dart';
part 'workHistory_state.dart';

class WorkHistoryBloc extends Bloc<WorkHistorytEvent, WorkHistoryState> {
  List<WorkHistory> workExperiences = [];
  List<PositionTitle> agencyPositions = [];
  List<Agency> agencies = [];
  List<AppoinemtStatus> appointmentStatus = [];
  List<Category> agencyCategory = [];
  List<AttachmentCategory> attachmentCategories = [];
  WorkHistoryBloc() : super(EducationInitial()) {
    ////GET WORK HISTORIES
    on<GetWorkHistories>((event, emit) async {
      emit(WorkHistoryLoadingState());
      try {
        if (attachmentCategories.isEmpty) {
          attachmentCategories =
              await AttachmentServices.instance.getCategories();
        }
        if (workExperiences.isEmpty) {
          List<WorkHistory> works = await WorkHistoryService.instance
              .getWorkExperiences(event.profileId, event.token);
          workExperiences = works;
        }
        emit(WorkHistoryLoaded(
            workExperiences: workExperiences,
            attachmentCategory: attachmentCategories));
      } catch (e) {
        emit(WorkHistoryErrorState(message: e.toString()));
      }
    });
///// LOAD WORK HISTORIES
    on<LoadWorkHistories>((event, emit) {
      emit(WorkHistoryLoadingState());
      emit(WorkHistoryLoaded(
          workExperiences: workExperiences,
          attachmentCategory: attachmentCategories));
    });
    ////DELETE
    on<DeleteWorkHistory>((event, emit) async {
      try {
        emit(WorkHistoryLoadingState());
        final bool success = await WorkHistoryService.instance.delete(
            profileId: event.profileId,
            token: event.token,
            work: event.workHistory);
        if (success) {
          workExperiences.removeWhere(
              (WorkHistory element) => element.id == event.workHistory.id);
          emit(DeletedState(success: success));
        } else {
          emit(DeletedState(success: success));
        }
      } catch (e) {
        emit(ErrorDeleteWorkHistory(workHistory: event.workHistory));
      }
    });
    //// ADD WORK HISTORIES
    on<AddWorkHistory>((event, emit) async {
      try {
        emit(WorkHistoryLoadingState());
        Map<dynamic, dynamic> status = await WorkHistoryService.instance.add(
            accomplishment: event.accomplishment,
            actualDuties: event.actualDuties,
            isPrivate: event.isPrivate,
            workHistory: event.workHistory,
            token: event.token,
            profileId: event.profileId);
        if (status['success']) {
          WorkHistory workHistory = WorkHistory.fromJson(status['data']);
          workExperiences.add(workHistory);
          emit(WorkHistoryAddedState(response: status));
        } else {
          emit(WorkHistoryAddedState(response: status));
        }
      } catch (e) {
        emit(ErrorAddWorkHistory(
            workHistory: event.workHistory,
            isPrivate: event.isPrivate,
            accomplishment: event.accomplishment,
            actualDuties: event.actualDuties));
      }
    });

////UPDATE WORK HISTORY
    on<UpdateWorkHistory>((event, emit) async {
      // try {
                emit(WorkHistoryLoadingState());
        Map<dynamic, dynamic> status = await WorkHistoryService.instance.update(
            isPrivate: event.isPrivate,
            workHistory: event.workHistory,
            token: event.token,
            profileId: event.profileId);
        if (status['success']) {
          WorkHistory workHistory = WorkHistory.fromJson(status['data']);
          workExperiences.removeWhere((WorkHistory work) {
            return work.id == event.workHistory.id;
          });
          workExperiences.add(workHistory);
          emit(WorkHistoryEditedState(response: status));
        } else {
          emit(WorkHistoryEditedState(
            response: status,
          ));
        }
      // } catch (e) {
      //   emit(ErrorUpdateWorkHistory(workHistory: event.workHistory,isPrivate: event.isPrivate));
      // }
    });

////SHOW EDIT WORK HISTORIES
    on<ShowEditWorkHistoryForm>((event, emit) async {
      try {
        emit(WorkHistoryLoadingState());
        /////POSITIONS------------------------------------------
        if (agencyPositions.isEmpty) {
          List<PositionTitle> positions =
              await WorkHistoryService.instance.getAgencyPosition();
          agencyPositions = positions;
        }

        /////Category Agency------------------------------------------
        if (agencyCategory.isEmpty) {
          List<Category> categoryAgencies =
              await ProfileUtilities.instance.agencyCategory();
          agencyCategory = categoryAgencies;
        }
        /////////-------------------------------------
        if (appointmentStatus.isEmpty) {
          List<AppoinemtStatus> status =
              WorkHistoryService.instance.getAppointmentStatusList();
          appointmentStatus = status;
        }

        emit(EditWorkHistoryState(
            workHistory: event.workHistory,
            agencyPositions: agencyPositions,
            appointmentStatus: appointmentStatus,
            agencyCategory: agencyCategory,
            agencies: agencies));
      } catch (e) {
        emit(ShowEditFormErrorState(workHistory: event.workHistory));
      }
    });
    ////SHOW ADD FORM WORK HISTORIES
    on<ShowAddWorkHistoryForm>((event, emit) async {
      emit(WorkHistoryLoadingState());
      try {
        /////POSITIONS------------------------------------------
        if (agencyPositions.isEmpty) {
          List<PositionTitle> positions =
              await WorkHistoryService.instance.getAgencyPosition();
          agencyPositions = positions;
        }

        /////Category Agency------------------------------------------
        if (agencyCategory.isEmpty) {
          List<Category> categoryAgencies =
              await ProfileUtilities.instance.agencyCategory();
          agencyCategory = categoryAgencies;
        }
        /////////-------------------------------------
        if (appointmentStatus.isEmpty) {
          List<AppoinemtStatus> status =
              WorkHistoryService.instance.getAppointmentStatusList();
          appointmentStatus = status;
        }

        emit(AddWorkHistoryState(
            agencyPositions: agencyPositions,
            appointmentStatus: appointmentStatus,
            agencyCategory: agencyCategory,
            agencies: agencies));
      } catch (e) {
        emit(ShowAddFormErrorState());
      }
    });
    ////Add Attachment
    on<AddWorkHistoryAttachment>((event, emit) async {
      emit(WorkHistoryLoadingState());
      List<Attachment> attachments = [];
      WorkHistory workHistory = workExperiences.firstWhere(
          (element) => element.id.toString() == event.attachmentModule);
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
          workHistory.attachments == null
              ? workHistory.attachments = attachments
              : workHistory.attachments = [
                  ...workHistory.attachments!,
                  ...attachments
                ];
          emit(WorkHistoryDevAttachmentAddedState(response: status));
        } else {
          emit(WorkHistoryDevAttachmentAddedState(response: status));
        }
      } catch (e) {
        emit(AddAttachmentError(
            attachmentModule: event.attachmentModule,
            filePaths: event.filePaths,
            categoryId: event.categoryId));
      }
    });
    on<ShareAttachment>((event, emit) async {
      emit(WorkHistoryLoadingState());
      Directory directory;
      String? appDocumentPath;
      if (await requestPermission(Permission.storage)) {
        directory = await getApplicationDocumentsDirectory();
        appDocumentPath = directory.path;
      }
      if (appDocumentPath == null) {
        directory = await getApplicationDocumentsDirectory();
        appDocumentPath = directory.path;
      }
      try {
        directory = await getApplicationDocumentsDirectory();
        appDocumentPath = directory.path;
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
            emit(WorkHistoryyAttachmentViewState(
                fileUrl: event.source, fileName: event.fileName));
          } else {
            Fluttertoast.showToast(msg: "Attachment shared unsuccessful");
            emit(WorkHistoryyAttachmentViewState(
                fileUrl: event.source, fileName: event.fileName));
          }
        } else {
          emit(WorkHistoryyAttachmentViewState(
              fileUrl: event.source, fileName: event.fileName));
        }
      } catch (e) {
        emit(WorkHistoryErrorState(message: e.toString()));
      }
    });
    on<WorkHistoryViewAttachmentEvent>((event, emit) {
      String fileUrl =
          '${Url.instance.prefixHost()}${Url.instance.host()}/media/${event.source}';
      emit(WorkHistoryyAttachmentViewState(
          fileUrl: fileUrl, fileName: event.filename));
    });
    //     ////Delete Attachment
    on<DeleteWorkHistoryAttachment>((event, emit) async {
      emit(WorkHistoryLoadingState());
      try {
        final bool success = await AttachmentServices.instance.deleteAttachment(
            attachment: event.attachment,
            moduleId: event.moduleId,
            profileId: event.profileId.toString(),
            token: event.token);
        if (success) {
          final WorkHistory workHistory = workExperiences
              .firstWhere((element) => element.id == event.moduleId);
          workHistory.attachments
              ?.removeWhere((element) => element.id == event.attachment.id);
          workExperiences
              .removeWhere((element) => element.id == event.moduleId);
          workExperiences.add(workHistory);
          emit(WorkHistoryDevAttachmentDeletedState(success: success));
        } else {
          emit(WorkHistoryDevAttachmentDeletedState(success: success));
        }
      } catch (e) {
        emit(ErrorDeleteWorkHistoryAttachment(
            attachment: event.attachment,
            moduleId: event.moduleId,
            profileId: event.profileId,
            token: event.token));
      }
    });
  }
}
