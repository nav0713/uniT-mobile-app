part of 'communication_bloc.dart';

 class CommunicationEvent extends Equatable {
  const CommunicationEvent();

  @override
  List<Object> get props => [];
}

class GetAllMessages extends CommunicationEvent{
  final String token;
  final int profileId;
  final int page;
  const GetAllMessages({required this.profileId, required this.token, required this.page});
    @override
  List<Object> get props => [token, profileId];
}
class NextPrev extends CommunicationEvent{
  final int page;
  const NextPrev({required this.page});
      @override
    List<Object> get props => [page];
}

 class ViewMessage extends CommunicationEvent{
  final int currentPage;
  final int id;
  final String token;
  final Message message; 
  const ViewMessage({required this.message,required this.id, required this.token, required this.currentPage});
     @override
  List<Object> get props => [message];
 }

 class AcknowledgeMessage extends CommunicationEvent{
  final int currentpage;
  final String token;
  final int id;
  final int messageId;
  final String dateAcknowledged;
   final String? comments;
  const AcknowledgeMessage({required this.messageId, required this.dateAcknowledged, this.comments, required this.id, required this.token,required this.currentpage}); 
 }