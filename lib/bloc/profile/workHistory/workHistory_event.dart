part of 'workHistory_bloc.dart';

abstract class WorkHistorytEvent extends Equatable {
  const WorkHistorytEvent();

  @override
  List<Object> get props => [];
}

class GetWorkHistories extends WorkHistorytEvent{
  final int profileId;
  final String token;
  const GetWorkHistories({required this.profileId, required this.token});


    @override
  List<Object> get props => [profileId, token];
}

class LoadWorkHistories extends WorkHistorytEvent{
    @override
  List<Object> get props => [];
}

class ShowAddWorkHistoryForm extends WorkHistorytEvent{

}
class ShowEditWorkHistoryForm extends WorkHistorytEvent{
  final WorkHistory workHistory;
  const ShowEditWorkHistoryForm({required this.workHistory});
    @override
  List<Object> get props => [workHistory];

}
class DeleteWorkHistory extends WorkHistorytEvent{
  final String token;
  final int profileId;
  final WorkHistory workHistory;
  const DeleteWorkHistory({required this.profileId, required this.token, required this.workHistory});
      @override
  List<Object> get props => [token, profileId,workHistory];
}

class UpdateWorkHistory extends WorkHistorytEvent{
  final WorkHistory workHistory;
  final bool isPrivate;
  final int profileId;
  final String token;

  const UpdateWorkHistory({required this.profileId, required this.token, required this.workHistory, required this.isPrivate});
  @override
  List<Object> get props => [profileId,token,workHistory,];
}

class AddWorkHistory extends WorkHistorytEvent{
  final WorkHistory workHistory;
  final bool isPrivate;
  final int profileId;
  final String token;
  final String? actualDuties;
  final String? accomplishment;
  const AddWorkHistory({required this.workHistory, required this.isPrivate, required this.profileId, required this.token, required this.accomplishment, required this.actualDuties});
      @override
  List<Object> get props => [workHistory,profileId,token,isPrivate];
}

////Add Attachment
class AddWorkHistoryAttachment extends WorkHistorytEvent{
  final String categoryId;
  final String attachmentModule;
  final List<String> filePaths;
  final String token;
  final String profileId;
  const AddWorkHistoryAttachment({required this.attachmentModule, required this.filePaths, required this.categoryId, required this.profileId, required this.token});
  @override
  List<Object> get props => [categoryId,attachmentModule,filePaths, token,profileId];
}

class WorkHistoryViewAttachmentEvent extends WorkHistorytEvent{
  final String source;
  final String filename;
  const WorkHistoryViewAttachmentEvent({required this.source, required this.filename});
}
class ShareAttachment extends WorkHistorytEvent{
  final String fileName;
  final String source;
  const ShareAttachment({required this.fileName, required this.source});
}

////Delete Attachment
class DeleteWorkHistoryAttachment extends WorkHistorytEvent{
  final int moduleId;
  final Attachment attachment;
  final String token;
  final int profileId;
  const DeleteWorkHistoryAttachment({required this.attachment, required this.moduleId, required this.profileId, required this.token});
}



