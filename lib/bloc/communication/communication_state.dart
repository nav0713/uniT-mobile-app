part of 'communication_bloc.dart';

class CommunicationState extends Equatable {
  const CommunicationState();

  @override
  List<Object> get props => [];
}

class CommunicationInitial extends CommunicationState {}

class MessagesLoaded extends CommunicationState {
  final MessageMeta messageMeta;
  final int currentPage;
  final int id;
  final String token;
  const MessagesLoaded({required this.messageMeta, required this.currentPage, required this.id, required this.token});
  @override
  List<Object> get props => [messageMeta];
}

class MessageLoadingState extends CommunicationState {}

class SingleMessageLoaded extends CommunicationState {
  final Message message;
  final String token;
  final int id;
  final int currentPage;
  const SingleMessageLoaded({required this.message,required this.id, required this.token, required this.currentPage});
  @override
  List<Object> get props => [message];
}

class MessagesErrorState extends CommunicationState {

  final String message;
  const MessagesErrorState({required this.message,});
  @override
  List<Object> get props => [message];
}
class PaginationNavigationErrorState extends CommunicationState {
    final int currentPage;
  final String message;
  const PaginationNavigationErrorState({required this.message, required this.currentPage});
    @override
  List<Object> get props => [message,currentPage];
}
class MessageAcknowledgeState extends CommunicationState {
  final MessageUpdateResponse messageUpdateResponse;
  final int currentpage;
  final String token;
  final int id;
  const MessageAcknowledgeState({
    required this.messageUpdateResponse,
    required this.currentpage,
    required this.id,
    required this.token
  });
  @override
  List<Object> get props => [messageUpdateResponse];
}

class MessageAcknowledgeErrorState extends CommunicationState{
    final MessageUpdateResponse messageUpdateResponse;
  final int currentpage;
  final String token;
  final int id;
    const MessageAcknowledgeErrorState({
    required this.messageUpdateResponse,
    required this.currentpage,
    required this.id,
    required this.token
  });
}
