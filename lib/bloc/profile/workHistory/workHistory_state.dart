part of 'workHistory_bloc.dart';

abstract class WorkHistoryState extends Equatable {
  const WorkHistoryState();
  
  @override
  List<Object> get props => [];
}

class EducationInitial extends WorkHistoryState {}

class WorkHistoryLoaded extends WorkHistoryState{
  final List<WorkHistory> workExperiences;
  final List< AttachmentCategory> attachmentCategory;
  const WorkHistoryLoaded({required this.workExperiences,required this.attachmentCategory});
    @override
  List<Object> get props => [workExperiences];
}

class WorkHistoryLoadingState extends WorkHistoryState{

}
class WorkHistoryErrorState extends WorkHistoryState{
  final String message;
  const WorkHistoryErrorState({required this.message});
  
      @override
  List<Object> get props => [message];
}

class WorkHistoryyAttachmentViewState extends WorkHistoryState {
  final String fileName;
  final String fileUrl;
  const WorkHistoryyAttachmentViewState({required this.fileUrl, required this.fileName});
}

class AddWorkHistoryState extends WorkHistoryState{
  final List<PositionTitle> agencyPositions;
  final List<Agency> agencies;
  final List<Category> agencyCategory;
  final List<AppoinemtStatus> appointmentStatus;

  const AddWorkHistoryState({required this.agencyPositions, required this.appointmentStatus,required this.agencies,required this.agencyCategory});
      @override
  List<Object> get props => [agencyPositions,appointmentStatus,agencies,agencyCategory];

}

class EditWorkHistoryState extends WorkHistoryState{
  final WorkHistory workHistory;
    final List<PositionTitle> agencyPositions;
  final List<Agency> agencies;
  final List<Category> agencyCategory;
  final List<AppoinemtStatus> appointmentStatus;
  const EditWorkHistoryState({required this.workHistory, required this.agencies,required this.agencyCategory, required this.agencyPositions, required this.appointmentStatus});
  @override
    List<Object> get props => [workHistory, agencyPositions,appointmentStatus,agencies,agencyCategory];
}

class DeletedState extends WorkHistoryState{
  final bool success;
  const DeletedState({required this.success});
        @override
  List<Object> get props => [success];
}

class WorkHistoryEditedState extends WorkHistoryState{
  final Map<dynamic,dynamic> response;
  const WorkHistoryEditedState({required this.response});
          @override
  List<Object> get props => [response];
}

class WorkHistoryAddedState extends WorkHistoryState{
  final Map<dynamic,dynamic> response;
  const WorkHistoryAddedState({required this.response});
          @override
  List<Object> get props => [response];
}


////Attachment AddedState
class WorkHistoryDevAttachmentAddedState extends WorkHistoryState {
  final Map<dynamic, dynamic> response;
  const WorkHistoryDevAttachmentAddedState({required this.response});
  @override
  List<Object> get props => [response];
}



////Attachment Deleted State State
class WorkHistoryDevAttachmentDeletedState extends WorkHistoryState {
  final bool success;
  const WorkHistoryDevAttachmentDeletedState({required this.success});
  @override
  List<Object> 
  
  get props => [success];
}

class ShowAddFormErrorState extends WorkHistoryState{
  
}
class AddAttachmentError extends WorkHistoryState{
    final String categoryId;
  final String attachmentModule;
  final List<String> filePaths;
  const AddAttachmentError({required this.attachmentModule, required this.filePaths, required this.categoryId,});
}

class ShowEditFormErrorState extends WorkHistoryState{
    final WorkHistory workHistory;
    const ShowEditFormErrorState({required this.workHistory});
              @override
  List<Object> get props => [workHistory];
}
class ErrorDeleteWorkHistory extends WorkHistoryState{
  final WorkHistory workHistory;
  const ErrorDeleteWorkHistory({ required this.workHistory,});
}


class ErrorDeleteWorkHistoryAttachment extends WorkHistoryState{
  final int moduleId;
  final Attachment attachment;
  final String token;
  final int profileId;
  const ErrorDeleteWorkHistoryAttachment({required this.attachment, required this.moduleId, required this.profileId, required this.token});
}
class ErrorUpdateWorkHistory extends WorkHistoryState{
  final WorkHistory workHistory;
  final bool isPrivate;

  const ErrorUpdateWorkHistory({required this.workHistory, required this.isPrivate});
  @override
  List<Object> get props => [workHistory,];
}

class ErrorAddWorkHistory extends WorkHistoryState{
  final WorkHistory workHistory;
  final bool isPrivate;
  final String? actualDuties;
  final String? accomplishment;
  const ErrorAddWorkHistory({required this.workHistory, required this.isPrivate, required this.accomplishment, required this.actualDuties});
      @override
  List<Object> get props => [workHistory,isPrivate];
}