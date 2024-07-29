import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:unit2/model/location/country.dart';
import 'package:unit2/model/location/region.dart';
import 'package:unit2/sevices/profile/learningDevelopment_service.dart';
import '../../../model/location/barangay.dart';
import '../../../model/location/city.dart';
import '../../../model/location/provinces.dart';
import '../../../model/profile/attachment.dart';
import '../../../model/profile/learning_development.dart';
import '../../../model/utils/agency.dart';
import '../../../model/utils/category.dart';
import '../../../utils/attachment_services.dart';
import '../../../utils/location_utilities.dart';
import '../../../utils/profile_utilities.dart';
import '../../../utils/request_permission.dart';
import '../../../utils/urls.dart';
part 'learning_development_event.dart';
part 'learning_development_state.dart';

class LearningDevelopmentBloc
    extends Bloc<LearningDevelopmentEvent, LearningDevelopmentState> {
  LearningDevelopmentBloc() : super(LearningDevelopmentInitial()) {
    List<LearningDevelopement> learningsAndDevelopments = [];
    List<LearningDevelopmentType> types = [];
    List<LearningDevelopmentType> topics = [];
    List<Country> globalCountries = [];
    List<Region> globalRegions = [];
    List<Province> globalProvinces = [];
    List<CityMunicipality> globalCities = [];
    List<Barangay> globalBarangay = [];
    List<Agency> agencies = [];
    List<Category> agencyCategory = [];
    List<AttachmentCategory> attachmentCategories = [];
    Region? currentRegion;
    Country? currentCountry;
    Province? currentProvince;
    CityMunicipality? currentCity;
    Barangay? currentBarangay;

    on<GetLearningDevelopments>((event, emit) async {
      emit(LearningDevelopmentLoadingState());
      try {
        if (attachmentCategories.isEmpty) {
          attachmentCategories =
              await AttachmentServices.instance.getCategories();
        }
        if (learningsAndDevelopments.isEmpty) {
          List<LearningDevelopement> learnings =
              await LearningDevelopmentServices.instance
                  .getLearningDevelopments(event.profileId, event.token);
          learningsAndDevelopments = learnings;
        }

        emit(LearningDevelopmentLoadedState(
            learningsAndDevelopment: learningsAndDevelopments,
            attachmentCategory: attachmentCategories));
      } catch (e) {
        emit(LearningDevelopmentErrorState(message: e.toString()));
      }
    });
    ////load
    on<LoadLearniningDevelopment>((event, emit) {
      emit(LearningDevelopmentLoadedState(
          learningsAndDevelopment: learningsAndDevelopments,
          attachmentCategory: attachmentCategories));
    });
    //// show add form
    on<ShowAddLearningDevelopmentForm>((event, emit) async {
      emit(LearningDevelopmentLoadingState());
      try {
        if (types.isEmpty) {
          List<LearningDevelopmentType> newTypes =
              await LearningDevelopmentServices.instance
                  .getLearningDevelopmentType();
          types = newTypes;
        }
        if (topics.isEmpty) {
          List<LearningDevelopmentType> newTopics =
              await LearningDevelopmentServices.instance.getTrainingTopics();
          topics = newTopics;
        }
        if (globalRegions.isEmpty) {
          List<Region> regions = await LocationUtils.instance.getRegions();
          globalRegions = regions;
        }
        if (globalCountries.isEmpty) {
          List<Country> countries = await LocationUtils.instance.getCountries();
          globalCountries = countries;
        }
        if (agencies.isEmpty) {
          List<Agency> newAgencies =
              await ProfileUtilities.instance.getAgecies();
          agencies = newAgencies;
        }
        if (agencyCategory.isEmpty) {
          List<Category> categoryAgencies =
              await ProfileUtilities.instance.agencyCategory();
          agencyCategory = categoryAgencies;
        }
        emit(LearningDevelopmentAddingState(
            types: types,
            topics: topics,
            countries: globalCountries,
            regions: globalRegions,
            conductedBy: agencies,
            sponsorAgencies: agencies,
            agencyCategory: agencyCategory));
      } catch (e) {
        emit(ShowAddFormErrorState());
      }
    });
    ////Show edit form
    on<ShowEditLearningDevelopmentForm>((event, emit) async {
      try {
        emit(LearningDevelopmentLoadingState());
        if (globalRegions.isEmpty) {
          List<Region> regions = await LocationUtils.instance.getRegions();
          globalRegions = regions;
        }
        if (globalCountries.isEmpty) {
          List<Country> countries = await LocationUtils.instance.getCountries();
          globalCountries = countries;
        }
        currentCountry = globalCountries.firstWhere((Country country) =>
            event.learningDevelopment.conductedTraining!.venue!.country!.code ==
            country.code);
        if (!event.isOverseas) {
          //// if not overseas
          currentRegion = globalRegions.firstWhere((Region region) =>
              event.learningDevelopment.conductedTraining!.venue!
                  .cityMunicipality!.province!.region!.code ==
              region.code);

          globalProvinces = await LocationUtils.instance
              .getProvinces(selectedRegion: currentRegion!);
          currentProvince = globalProvinces.firstWhere((Province province) =>
              event.learningDevelopment.conductedTraining!.venue!
                  .cityMunicipality!.province!.code ==
              province.code);

          globalCities = await LocationUtils.instance
              .getCities(selectedProvince: currentProvince!);

          currentCity = globalCities.firstWhere(
              (CityMunicipality cityMunicipality) =>
                  event.learningDevelopment.conductedTraining!.venue!
                      .cityMunicipality!.code ==
                  cityMunicipality.code);
          globalBarangay = await LocationUtils.instance
              .getBarangay(cityMunicipality: currentCity!);

          if (event.learningDevelopment.conductedTraining?.venue?.barangay
                  ?.cityMunicipality !=
              null) {
            currentBarangay = globalBarangay.firstWhere((Barangay barangay) =>
                event.learningDevelopment.conductedTraining!.venue!.barangay!
                    .code ==
                barangay.code);
          } else {
            currentBarangay = null;
          }
        }
        if (topics.isEmpty) {
          List<LearningDevelopmentType> newTopics =
              await LearningDevelopmentServices.instance.getTrainingTopics();
          topics = newTopics;
        }
        if (types.isEmpty) {
          List<LearningDevelopmentType> newTypes =
              await LearningDevelopmentServices.instance
                  .getLearningDevelopmentType();
          types = newTypes;
        }
        if (agencyCategory.isEmpty) {
          List<Category> categoryAgencies =
              await ProfileUtilities.instance.agencyCategory();
          agencyCategory = categoryAgencies;
        }
        emit(LearningDevelopmentUpdatingState(
            cities: globalCities,
            currentBarangay: currentBarangay,
            barangay: globalBarangay,
            provinces: globalProvinces,
            types: types,
            topics: topics,
            training: event.learningDevelopment.conductedTraining!.title!,
            learningDevelopement: event.learningDevelopment,
            currentConductedBy:
                event.learningDevelopment.conductedTraining!.conductedBy!,
            currentSponsor: event.learningDevelopment.sponsoredBy,
            conductedBy: agencies,
            sponsorAgencies: agencies,
            agencyCategory: agencyCategory,
            countries: globalCountries,
            regions: globalRegions,
            currentRegion: currentRegion,
            currentCountry: currentCountry!,
            currentProvince: currentProvince,
            currentCity: currentCity,
            overseas: event.isOverseas));
      } catch (e) {
        emit(ShowEditFormErrorState(
            isOverseas: event.isOverseas,
            learningDevelopment: event.learningDevelopment));
      }
    });

    ////Add
    on<AddLearningAndDevelopment>((event, emit) async {
      try {
        emit(LearningDevelopmentLoadingState());
        Map<dynamic, dynamic> status =
            await LearningDevelopmentServices.instance.add(
                learningDevelopement: event.learningDevelopement,
                token: event.token,
                profileId: event.profileId);
        if (status['success']) {
          LearningDevelopement learningDevelopement =
              LearningDevelopement.fromJson(status['data']);
          learningsAndDevelopments.add(learningDevelopement);
          emit(LearningDevelopmentAddedState(response: status));
        } else {
          emit(LearningDevelopmentAddedState(response: status));
        }
      } catch (e) {
        emit(LearningDevelopmentAddingErrorState(
            learningDevelopement: event.learningDevelopement));
      }
    });

    ////Update
    on<UpdateLearningDevelopment>((event, emit) async {
      try {
        emit(LearningDevelopmentLoadingState());
        Map<dynamic, dynamic> status =
            await LearningDevelopmentServices.instance.update(
                learningDevelopement: event.learningDevelopement,
                token: event.token,
                profileId: event.profileId);
        if (status['success']) {
          learningsAndDevelopments.removeWhere((LearningDevelopement element) =>
              element.conductedTraining!.id ==
                  event.learningDevelopement.conductedTraining!.id &&
              element.conductedTraining!.totalHours ==
                  event.learningDevelopement.conductedTraining!.totalHours);
          LearningDevelopement learningDevelopement =
              LearningDevelopement.fromJson(status['data']);
          learningsAndDevelopments.add(learningDevelopement);
          emit(LearningDevelopmentUpdatedState(response: status));
        } else {
          emit(LearningDevelopmentUpdatedState(response: status));
        }
      } catch (e) {
        emit(LearningDevelopmentUpdatingErrorState(
            learningDevelopement: event.learningDevelopement));
      }
    });
    ////delete
    on<DeleteLearningDevelopment>((event, emit) async {
      emit(LearningDevelopmentLoadingState());
      try {
        final bool success = await LearningDevelopmentServices.instance.delete(
            profileId: event.profileId,
            token: event.token,
            sponsorId: event.sponsorId,
            totalHours: event.hours,
            trainingId: event.trainingId);
        if (success) {
          learningsAndDevelopments.removeWhere((LearningDevelopement element) =>
              element.conductedTraining!.id == event.trainingId &&
              element.conductedTraining!.totalHours == event.hours);
          emit(DeleteLearningDevelopmentState(success: success));
        } else {
          emit(DeleteLearningDevelopmentState(success: success));
        }
      } catch (e) {
        emit(LearningDevelopmentDeletingErrorState(
            hours: event.hours,
            sponsorId: event.sponsorId,
            trainingId: event.trainingId));
      }
    });
    //// call errror
    on<CallErrorState>((event, emit) {
      emit(LearningDevelopmentErrorState(message: event.message));
    });
    ////Add attachment
    on<AddALearningDevttachment>((event, emit) async {
      emit(LearningDevelopmentLoadingState());
      List<Attachment> attachments = [];
      LearningDevelopement learningDevelopement =
          learningsAndDevelopments.firstWhere((element) =>
              element.conductedTraining!.id.toString() ==
              event.attachmentModule);
      try {
        Map<dynamic, dynamic> status = await AttachmentServices.instance
            .attachment(
                categoryId: event.categoryId,
                module: event.attachmentModule,
                paths: event.filePaths,
                token: event.token,
                profileId: event.profileId);
        if (status['success']) {
          status['data'].forEach((element) {
            Attachment newAttachment = Attachment.fromJson(element);
            attachments.add(newAttachment);
          });
          learningDevelopement.attachments == null
              ? learningDevelopement.attachments = attachments
              : learningDevelopement.attachments = [
                  ...learningDevelopement.attachments!,
                  ...attachments
                ];
          emit(LearningDevelopmentAddedState(response: status));
        } else {
          emit(LearningDevelopmentAddedState(response: status));
        }
      } catch (e) {
        emit(AddAttachmentError(attachmentModule: event.attachmentModule,categoryId: event.categoryId,filePaths: event.filePaths));
      }
    });
    ////Delete Attachment
    on<DeleteLearningDevAttachment>((event, emit) async {
      emit(LearningDevelopmentLoadingState());
      try {
        final bool success = await AttachmentServices.instance.deleteAttachment(
            attachment: event.attachment,
            moduleId: event.moduleId,
            profileId: event.profileId.toString(),
            token: event.token);
        if (success) {
          final LearningDevelopement learningDevelopement =
              learningsAndDevelopments.firstWhere(
                  (element) => element.conductedTraining!.id == event.moduleId);
          learningDevelopement.attachments
              ?.removeWhere((element) => element.id == event.attachment.id);
          learningsAndDevelopments.removeWhere(
              (element) => element.conductedTraining!.id == event.moduleId);
          learningsAndDevelopments.add(learningDevelopement);
          emit(LearningDevAttachmentDeletedState(success: success));
        } else {
          emit(LearningDevAttachmentDeletedState(success: success));
        }
      } catch (e) {
        emit(ErrorDeleteLearningDevAttachment(
            attachment: event.attachment,
            moduleId: event.moduleId,
            profileId: event.profileId,
            token: event.token));
      }
    });
    on<LearningDevelopmentViewAttachmentEvent>((event, emit) {
      String fileUrl =
          '${Url.instance.prefixHost()}${Url.instance.host()}/media/${event.source}';
      emit(LearningAndDevelopmentAttachmentViewState(
          fileUrl: fileUrl, filename: event.filename));
    });
    on<ShareAttachment>((event, emit) async {
      emit(LearningDevelopmentLoadingState());
      Directory directory;
      String? appDocumentPath;
      directory = await getApplicationDocumentsDirectory();
      appDocumentPath = directory.path;
      if (appDocumentPath.isEmpty) {
        if (await requestPermission(Permission.storage)) {
          directory = await getApplicationDocumentsDirectory();
          appDocumentPath = directory.path;
        }
      }
      try {
        final bool success = await AttachmentServices.instance
            .downloadAttachment(
                filename: event.fileName,
                source: event.source,
                downLoadDir: appDocumentPath);
        if (success) {
          final result = await Share.shareXFiles(
              [XFile("$appDocumentPath/${event.fileName}")]);
          if (result.status == ShareResultStatus.success) {
            Fluttertoast.showToast(msg: "Attachment shared successful");
            emit(LearningAndDevelopmentAttachmentViewState(
                fileUrl: event.source, filename: event.fileName));
          } else {
            Fluttertoast.showToast(msg: "Attachment shared unsuccessful");
            emit(LearningAndDevelopmentAttachmentViewState(
                fileUrl: event.source, filename: event.fileName));
          }
        } else {
          emit(LearningAndDevelopmentAttachmentViewState(
              fileUrl: event.source, filename: event.fileName));
        }
      } catch (e) {
        emit(LearningDevelopmentErrorState(message: e.toString()));
      }
    });
  }
}
