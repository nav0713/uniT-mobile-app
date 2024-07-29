import 'package:unit2/model/communication/message.dart';

class MessageMeta{
  final int? pages;
  final int? items;
  List<Message> messages=[];
  MessageMeta({required this.items, required this.messages, required this.pages});


}

class MessageUpdateResponse{
  final bool status;
  final Message responseMessage;
  final String message;
  const MessageUpdateResponse({required this.message, required this.responseMessage, required this.status});

}