import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unit2/sevices/profile/contact_services.dart';
import 'package:unit2/utils/profile_utilities.dart';
import '../../../../model/profile/basic_information/contact_information.dart';
part 'contact_event.dart';
part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  ContactBloc() : super(ContactInitial()) {
    List<ContactInfo> contactInformations = [];
    List<ServiceType> serviceTypes = [];
    //// get all contacts
    on<GetContacts>((event, emit) {
      emit(ContactLoadingState());
      try {
        contactInformations = event.contactInformations;
        emit(ContactLoadedState(contactInformation: contactInformations));
      } catch (e) {
        emit(ContactErrorState(message: e.toString()));
      }
    });
    //// Load Contacts
    on<LoadContacts>((event, emit) {
      emit(ContactLoadedState(contactInformation: contactInformations));
    });
    //// show add form
    on<ShowAddForm>((event, emit) async {
      try {
        emit(ContactLoadingState());
        if (serviceTypes.isEmpty) {
          serviceTypes = await ProfileUtilities.instance.getServiceType();
        }
        emit(ContactAddingState(serviceTypes: serviceTypes));
      } catch (e) {
        emit(ShowAddFormErrorState());
      }
    });
    ///// Show edit form
    on<ShowEditForm>((event, emit) async {
      ServiceType serviceType;
      List<CommService> commServiceProvivers;
      CommService serviceProvider;
      try {
                emit(ContactLoadingState());
        if (serviceTypes.isEmpty) {
          serviceTypes = await ProfileUtilities.instance.getServiceType();
        }
        serviceType = serviceTypes.firstWhere((ServiceType element) {
          return element.id == event.contactInfo.commService!.serviceType!.id;
        });
        commServiceProvivers = await ContactService.instance
            .getServiceProvider(serviceTypeId: serviceType.id!);
        serviceProvider = commServiceProvivers.firstWhere(
            (CommService element) =>
                element.id == event.contactInfo.commService!.id);
        emit(ContactEditingState(
            serviceTypes: serviceTypes,
            selectedServiceType: serviceType,
            commServiceProviders: commServiceProvivers,
            selectedProvider: serviceProvider,
            contactInfo: event.contactInfo));
      } catch (e) {
        emit(ShowEditFormErrorState(contactInfo: event.contactInfo));
      }
    });
    ////edit contact
    on<EditContactInformation>((event, emit) async {
      try {
                emit(ContactLoadingState());
        Map<dynamic, dynamic> responseStatus = await ContactService.instance
            .update(
                profileId: event.profileId,
                token: event.token,
                contactInfo: event.contactInfo);
        if (responseStatus['success']) {
          ContactInfo contactInfo =
              ContactInfo.fromJson(responseStatus['data']['contact_info']);
          contactInformations.removeWhere(
              (ContactInfo element) => element.id == event.contactInfo.id);
          contactInformations.add(contactInfo);
          emit(ContactEditedState(response: responseStatus));
        } else {
          emit(ContactEditedState(response: responseStatus));
        }
      } catch (e) {
        emit(ContactEditingErrorState(contactInfo: event.contactInfo));
      }
    });
    on<CallErrorEvent>((event, emit) {
      emit(ContactErrorState(message: event.message));
    });

    //// add contact

    on<AddContactInformation>((event, emit) async {
        emit(ContactLoadingState());
      try {
        Map<dynamic, dynamic> responseStatus = await ContactService.instance
            .add(
                profileId: event.profileId,
                token: event.token,
                contactInfo: event.contactInfo);
        if (responseStatus['success']) {
          ContactInfo contactInfo =
              ContactInfo.fromJson(responseStatus['data']['contact_info']);
          contactInformations.add(contactInfo);
          emit(ContactAddedState(response: responseStatus));
        } else {
          emit(ContactAddedState(response: responseStatus));
        }
      } catch (e) {
        emit(ContactAddingErrorState(contactInfo: event.contactInfo));
      }
    });
    //// delete contact
    on<DeleteContactInformation>((event, emit) async {
              emit(ContactLoadingState());
      try {
        final bool success = await ContactService.instance.deleteContact(
            profileId: event.profileId,
            token: event.token,
            contactInfo: event.contactInfo);
        if (success) {
          contactInformations
              .removeWhere((element) => element.id == event.contactInfo.id);
          emit(ContactDeletedState(succcess: success));
        } else {
          emit(ContactDeletedState(succcess: success));
        }
      } catch (e) {
        emit(ContactDeletingErrorState(contactInfo: event.contactInfo));
      }
    });
  }
}
