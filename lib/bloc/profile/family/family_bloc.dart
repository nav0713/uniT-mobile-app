import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unit2/sevices/profile/family_services.dart';

import '../../../model/profile/family_backround.dart';

part 'family_event.dart';
part 'family_state.dart';

class FamilyBloc extends Bloc<FamilyEvent, FamilyState> {
  FamilyBloc() : super(FamilyInitial()) {
    List<FamilyBackground> families = [];
    on<GetFamilies>((event, emit) async {
      emit(FamilyLoadingState());
      try {
 
        if (families.isEmpty) {
          List<FamilyBackground> family = await FamilyService.instance
              .getFamilies(event.profileId, event.token);
          families = family;
        }
        emit(FamilyLoaded(families: families));
      } catch (e) {
        emit(FamilyErrorState(message: e.toString()));
      }
    

    });
      ////Load
      on<LoadFamily>((event, emit) {
        emit(FamilyLoaded(families: families));
      });
            ////Add Family
    on<AddFamily>((event, emit) async {
      try {
        emit(FamilyLoadingState());
        Map<dynamic, dynamic> status = await FamilyService.instance.add(
            family: event.familyBackground,
            relationshipId: event.relationshipId,
            profileId: event.profileId,
            token: event.token);
        if (status['success']) {
          FamilyBackground familyBackground =
              FamilyBackground.fromJson(status['data']);
          families.add(familyBackground);
          emit(FamilyAddedState(response: status));
        } else {
          emit(FamilyAddedState(response: status));
        }
      } catch (e) {
        emit(FamilyErrorAddingState(familyBackground: event.familyBackground,relationshipId: event.relationshipId));
      }
    });
    //// Add Emergency
    on<AddEmergencyEvent>((event, emit) async {
      try {
        emit(FamilyLoadingState());
        Map<dynamic, dynamic> status = await FamilyService.instance
            .addEmergency(
                requestType: event.requestType,
                relatedPersonId: event.relatedPersonId,
                numberMail: event.numberMail,
                contactInfoId: event.contactInfoId,
                profileId: event.profileId,
                token: event.token);
        if (status['success']) {
          families.removeWhere(
              (element) => element.relatedPerson!.id == event.relatedPersonId);
          FamilyBackground familyBackground =
              FamilyBackground.fromJson(status['data']);
          families.add(familyBackground);
          emit(EmergencyContactEditedState(response: status));
        } else {
          emit(EmergencyContactEditedState(response: status));
        }
      } catch (e) {
        emit(FamilyErrorState(message: e.toString()));
      }
    });
    ////update
    on<Updatefamily>((event, emit) async {
      try {
        emit(FamilyLoadingState());
        Map<dynamic, dynamic> status = await FamilyService.instance.update(
            family: event.familyBackground,
            relationshipId: event.relationshipId,
            profileId: event.profileId,
            token: event.token);
        if (status['success']) {
          families.removeWhere((element) =>
              element.relatedPerson!.id ==
              event.familyBackground.relatedPerson!.id);
          FamilyBackground familyBackground =
              FamilyBackground.fromJson(status['data']);
          families.add(familyBackground);
          emit(FamilyEditedState(response: status));
        } else {
          emit(FamilyEditedState(response: status));
        }
      } catch (e) {
             emit(FamilyErrorUpdatingState(familyBackground: event.familyBackground,relationshipId: event.relationshipId));
      }
    });

    ////Delete
    on<DeleteFamily>((event, emit) async {
      try {
                emit(FamilyLoadingState());
        final bool success = await FamilyService.instance.delete(
            personRelatedId: event.id,
            profileId: event.profileId,
            token: event.token);
        if (success) {
          families
              .removeWhere((element) => element.relatedPerson!.id == event.id);
          emit(DeletedState(success: success));
        } else {
          emit(DeletedState(success: success));
        }
      } catch (e) {
        emit(FamilyErrorDeletingState(id: event.id));
      }
    });
    on<CallErrorState>((event,emit){
              emit(FamilyErrorState(message: state.toString()));
    });
  }
}
