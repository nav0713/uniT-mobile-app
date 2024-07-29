import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unit2/sevices/docsms/docsms_service.dart';
import '../../model/docsms/document.dart';
part 'docsms_event.dart';
part 'docsms_state.dart';

class DocsmsBloc extends Bloc<DocsmsEvent, DocsmsState> {
  DocsmsBloc() : super(DocsmsInitial()) {
    Document? document;
    on<LoadDocument>((event, emit)async {
      emit(DocSmsLoadingState());
      try {
      document = await AutoReceiveDocumentServices.instance.getDocument(event.documentId);
     if(document != null){
      emit(DocumentLoaded(document: document!));
     }else{
      emit(const DocSmsErrorState(message: "Invalid Qr code"));
     }
    
} catch (e) {
        emit(DocSmsErrorState(message: e.toString()));
      }
    });
  }
}
