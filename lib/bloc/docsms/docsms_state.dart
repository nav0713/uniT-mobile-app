part of 'docsms_bloc.dart';

abstract class DocsmsState extends Equatable {
  const DocsmsState();
  
  @override
  List<Object> get props => [];
}

class DocsmsInitial extends DocsmsState {}

class DocSmsLoadingState extends DocsmsState{

}
class DocumentLoaded extends DocsmsState{
  final Document document;
  const DocumentLoaded({required this.document});
      @override
  List<Object> get props => [document];

}

class DocSmsErrorState extends DocsmsState{
  final String message;
  const DocSmsErrorState({required this.message});
    @override
  List<Object> get props => [message];
}
