import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unit2/model/communication/message.dart';
import 'package:unit2/model/communication/message_meta.dart';
import 'package:unit2/sevices/communication/message_service.dart';

part 'communication_event.dart';
part 'communication_state.dart';

class CommunicationBloc extends Bloc<CommunicationEvent, CommunicationState> {
  CommunicationBloc() : super(CommunicationInitial()) {
    MessageMeta messageMeta =
        MessageMeta(items: null, messages: [], pages: null);
    String? token;
    int? profileId;
    on<GetAllMessages>((event, emit) async {
      token = event.token;
      profileId = event.profileId;
      emit(MessageLoadingState());
      try {
        messageMeta = await MessagesService.instance.getAllMessages(
            authToken: event.token,
            profileId: event.profileId,
            pages: event.page);
        emit(MessagesLoaded(
            messageMeta: messageMeta,
            currentPage: 0,
            id: profileId!,
            token: token!));
      } catch (e) {
        emit(MessagesErrorState(message: e.toString()));
      }
    });
    on<NextPrev>((event, emit) async {
      try {
        emit(MessageLoadingState());
        messageMeta = await MessagesService.instance.getAllMessages(
            authToken: token!, profileId: profileId!, pages: event.page + 1);
        emit(MessagesLoaded(
            messageMeta: messageMeta,
            currentPage: event.page,
            id: profileId!,
            token: token!));
      } catch (e) {
        emit(PaginationNavigationErrorState(
            message: e.toString(), currentPage: event.page));
      }
    });
    on<ViewMessage>((event, emit) {
      emit(SingleMessageLoaded(
          message: event.message,
          token: event.token,
          id: event.id,
          currentPage: event.currentPage));
    });
    on<AcknowledgeMessage>((event, emit) async {
      emit(MessageLoadingState());

      try {
        MessageUpdateResponse? messageUpdateResponse =
            await MessagesService.instance.acknowledgeMessage(
                authToken: event.token,
                profileId: event.id,
                messageId: event.messageId,
                date: event.dateAcknowledged,
                comment: event.comments);
        emit(MessageAcknowledgeState(
            messageUpdateResponse: messageUpdateResponse!,
            currentpage: event.currentpage,
            id: event.id,
            token: event.token));
      } catch (e) {
        emit(MessagesErrorState(message: e.toString()));
      }
    });
  }
}
