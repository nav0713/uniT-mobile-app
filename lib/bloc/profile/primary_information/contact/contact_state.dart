part of 'contact_bloc.dart';

abstract class ContactState extends Equatable {
  const ContactState();
  
  @override
  List<Object> get props => [];
}

class ContactInitial extends ContactState {}

////loaded state
class ContactLoadedState extends ContactState{
  final  List<ContactInfo> contactInformation;
  const ContactLoadedState({required this.contactInformation});
    @override
  List<Object> get props => [];
}
////loading state
class ContactLoadingState extends ContactState{

}
//// adding state
class ContactAddingState extends ContactState{
  final List<ServiceType> serviceTypes;
  const ContactAddingState({ required this.serviceTypes});
      @override
  List<Object> get props => [serviceTypes];
}
//// Editing state
class ContactEditingState extends ContactState{
  final List<ServiceType> serviceTypes;
  final List<CommService> commServiceProviders;
  final CommService selectedProvider;
  final ServiceType selectedServiceType;
  final ContactInfo contactInfo;
  const ContactEditingState({ required this.serviceTypes, required this.selectedServiceType, required this.selectedProvider, required this.commServiceProviders, required this.contactInfo});
      @override
  List<Object> get props => [serviceTypes];
}


//// added state
class ContactAddedState extends ContactState{
 
    final Map<dynamic,dynamic> response;
    const ContactAddedState({ required this.response});
        @override
  List<Object> get props => [response];
}
//// edited state
class ContactEditedState extends ContactState{

    final Map<dynamic,dynamic> response;
    const ContactEditedState({ required this.response});
        @override
  List<Object> get props => [response];
}
////deleted state
class ContactDeletedState extends ContactState{
      final bool succcess;
      const ContactDeletedState({required this.succcess});
              @override
  List<Object> get props => [succcess];
}

////error state
class ContactErrorState extends ContactState{
  final String message;
  const ContactErrorState({required this.message});
      @override
  List<Object> get props => [message];
}
class ContactAddingErrorState extends ContactState{
    final ContactInfo contactInfo;
   const ContactAddingErrorState({required this.contactInfo});
}
class ContactEditingErrorState extends ContactState{
    final ContactInfo contactInfo;
   const ContactEditingErrorState({required this.contactInfo});
}
class ContactDeletingErrorState extends ContactState{
    final ContactInfo contactInfo;
   const ContactDeletingErrorState({required this.contactInfo});
}

class ShowAddFormErrorState extends ContactState{
  
}
class ShowEditFormErrorState extends ContactState{
    final ContactInfo contactInfo;
    const ShowEditFormErrorState({required this.contactInfo});
  

}




