
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unit2/sevices/profile/non_academic_services.dart';

import '../../../../model/profile/other_information/non_acedimic_recognition.dart';
import '../../../../model/utils/agency.dart';
import '../../../../model/utils/category.dart';
import '../../../../utils/profile_utilities.dart';

part 'non_academic_recognition_event.dart';
part 'non_academic_recognition_state.dart';

class NonAcademicRecognitionBloc
    extends Bloc<NonAcademicRecognitionEvent, NonAcademicRecognitionState> {
  NonAcademicRecognitionBloc() : super(NonAcademicRecognitionInitial()) {
    List<NonAcademicRecognition> nonAcademicRecognitions = [];
    List<Agency> agencies = [];
    List<Category> agencyCategory = [];
    ////GET
    on<GetNonAcademicRecognition>((event, emit) async {
      emit(NonAcademicRecognitionLoadingState());
      try {
        if (nonAcademicRecognitions.isEmpty) {
          List<NonAcademicRecognition> recognitions =
              await NonAcademicRecognitionServices.instance
                  .getNonAcademicRecognition(event.profileId!, event.token!);
          nonAcademicRecognitions = recognitions;
        }

          emit(NonAcademicRecognitionLoadedState(
              nonAcademicRecognition: nonAcademicRecognitions));
      } catch (e) {
        emit(NonAcademicRecognitionErrorState(message: e.toString()));
      }
    });

    ////LOAD 
    on<LoadNonAcademeRecognition>((event,emit){

      emit(NonAcademicRecognitionLoadedState(nonAcademicRecognition: nonAcademicRecognitions));
    });
////SHOW ADD FORM
    on<ShowAddNonAcademeRecognitionForm>(
      (event, emit) async {
        emit(NonAcademicRecognitionLoadingState());
        try {
          if (agencies.isEmpty) {
            List<Agency> newAgencies =
                await ProfileUtilities.instance.getAgecies();
            agencies = newAgencies;
          }
          if (agencyCategory.isEmpty) {
            List<Category> newAgencyCategories =
                await ProfileUtilities.instance.agencyCategory();
            agencyCategory = newAgencyCategories;
          }
          emit(AddNonAcademeRecognitionState(
              agencies: agencies, agencyCategories: agencyCategory));
        } catch (e) {
          emit(NonAcademicRecognitionErrorState(message: e.toString()));
        }
      },
    );
    ////SHOW EDIT FORM
    on<ShowEditNonAcademicRecognitionForm>((event, emit) async {
      emit(NonAcademicRecognitionLoadingState());
      try {
        if (agencies.isEmpty) {
          List<Agency> newAgencies =
              await ProfileUtilities.instance.getAgecies();
          agencies = newAgencies;
        }
        if (agencyCategory.isEmpty) {
          List<Category> newAgencyCategories =
              await ProfileUtilities.instance.agencyCategory();
          agencyCategory = newAgencyCategories;
        }
        emit(EditNonAcademeRecognitionState(
            agencies: agencies,
            agencyCategories: agencyCategory,
            nonAcademicRecognition: event.nonAcademicRecognition));
      } catch (e) {
        emit(NonAcademicRecognitionErrorState(message: e.toString()));
      }
    });
    ////ADD
    on<AddNonAcademeRecognition>((event, emit) async {
      emit(NonAcademicRecognitionLoadingState());
      try {
        Map<dynamic, dynamic> status =
            await NonAcademicRecognitionServices.instance.add(
                token: event.token,
                profileId: event.profileId,
                nonAcademicRecognition: event.nonAcademicRecognition);
        if (status['success']) {
          NonAcademicRecognition nonAcademicRecognition =
              NonAcademicRecognition.fromJson(status['data']);
          nonAcademicRecognitions.add(nonAcademicRecognition);
          emit(NonAcademeRecognitionAddedState(
              response: status,
              nonAcademicRecognition: nonAcademicRecognitions));
        } else {
          emit(NonAcademeRecognitionAddedState(
              response: status,
              nonAcademicRecognition: nonAcademicRecognitions));
        }
      } catch (e) {
        emit(AddNonAcademeRecognitionError(nonAcademicRecognition: event.nonAcademicRecognition));
      }
    });
////EDIT
    on<EditNonAcademeRecognition>((event, emit) async {
      emit(NonAcademicRecognitionLoadingState());
      try {
        Map<dynamic, dynamic> status =
            await NonAcademicRecognitionServices.instance.update(
                nonAcademicRecognition: event.nonAcademicRecognition,
                profileId: event.profileId,
                token: event.token);
        if (status['success']) {
          NonAcademicRecognition newNonAcademeRecognition =
              NonAcademicRecognition.fromJson(status['data']);
          nonAcademicRecognitions.removeWhere(
              (element) => element.id == event.nonAcademicRecognition.id);
          nonAcademicRecognitions.add(newNonAcademeRecognition);
          emit(NonAcademeRecognitionEditedState(
              nonAcademicRecognitions: nonAcademicRecognitions,
              response: status));
        }else{
             emit(NonAcademeRecognitionEditedState(
              nonAcademicRecognitions: nonAcademicRecognitions,
              response: status));
        }
      } catch (e) {
        emit(NonAcademicRecognitionErrorState(message: e.toString()));
      }
    });

    ////DELETE
    on<DeleteNonAcademeRecognition>((event, emit) async {
      emit(NonAcademicRecognitionLoadingState());
      try {
        final bool success = await NonAcademicRecognitionServices.instance
            .delete(
                title: event.nonAcademicRecognition.title!,
                id: event.nonAcademicRecognition.id!,
                token: event.token,
                profileId: event.profileId);
        if (success) {
          event.nonAcademicRecognitions.removeWhere(
              (element) => element.id == event.nonAcademicRecognition.id);
          nonAcademicRecognitions = event.nonAcademicRecognitions;
          emit(NonAcademeRecognitionDeletedState(
              nonAcademicRecognitions: nonAcademicRecognitions,
              success: success));
        } else {
          emit(NonAcademeRecognitionDeletedState(
              nonAcademicRecognitions: nonAcademicRecognitions,
              success: success));
        }
      } catch (e) {
        emit(DeleteNonAcademeRecognitionError(nonAcademicRecognition: event.nonAcademicRecognition,nonAcademicRecognitions: event.nonAcademicRecognitions));
      }
    });
  }
}
