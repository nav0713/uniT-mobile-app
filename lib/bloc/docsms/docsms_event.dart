part of 'docsms_bloc.dart';

abstract class DocsmsEvent extends Equatable {
  const DocsmsEvent();

  @override
  List<Object> get props => [];
}

class LoadDocument extends DocsmsEvent{
final String documentId;
const LoadDocument({required this.documentId});
  @override
  List<Object> get props => [];
}
