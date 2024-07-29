import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:unit2/utils/attachment_services.dart';
import '../../../model/location/city.dart';
import '../../../model/location/country.dart';
import '../../../model/location/provinces.dart';
import '../../../model/location/region.dart';
import '../../../model/profile/attachment.dart';
import '../../../model/profile/eligibility.dart';
import '../../../model/utils/eligibility.dart';
import '../../../sevices/profile/eligibility_services.dart';
import '../../../utils/location_utilities.dart';
import '../../../utils/profile_utilities.dart';
import '../../../utils/request_permission.dart';
import '../../../utils/urls.dart';
part 'eligibility_event.dart';
part 'eligibility_state.dart';

class EligibilityBloc extends Bloc<EligibilityEvent, EligibilityState> {
  EligibilityBloc() : super(EligibilityInitial()) {
    List<Country> globalCountries = [];
    List<Region> globalRegions = [];
    List<Eligibility> globalEligibilities = [];
    List<EligibityCert> eligibilities = [];
    List<AttachmentCategory> attachmentCategories = [];
//// LOAD ELIGIBILTY
    on<LoadEligibility>((event, emit) {
      emit(EligibilityLoadingState());
      emit(EligibilityLoaded(
          eligibilities: eligibilities,
          attachmentCategory: attachmentCategories));
    });

    //// DELETE
    on<DeleteEligibility>((event, emit) async {
      try {
        emit(EligibilityLoadingState());
        final bool success = await EligibilityService.instance.delete(
            eligibilityId: event.eligibilityId,
            profileId: int.parse(event.profileId),
            token: event.token);
        if (success) {
          eligibilities.removeWhere(
              ((EligibityCert element) => element.id == event.eligibilityId));
          emit(EligibilityDeletedState(
            success: success,
          ));
        } else {
          emit(EligibilityDeletedState(success: success));
        }
      } catch (e) {
        emit(EligibilityDeletingErrorState(eligibilityId: event.eligibilityId));
      }
    });

//// GET ELIGIBILITY
    on<GetEligibilities>((event, emit) async {
      emit(EligibilityLoadingState());
      try {
        if (attachmentCategories.isEmpty) {
          attachmentCategories =
              await AttachmentServices.instance.getCategories();
        }
        if (eligibilities.isNotEmpty) {
          emit(EligibilityLoaded(
              eligibilities: eligibilities,
              attachmentCategory: attachmentCategories));
        } else {
          emit(EligibilityLoadingState());
          eligibilities = await EligibilityService.instance
              .getEligibilities(event.profileId, event.token);
          emit(EligibilityLoaded(
              eligibilities: eligibilities,
              attachmentCategory: attachmentCategories));
        }
      } catch (e) {
        emit(EligibilityErrorState(message: e.toString()));
      }
    });
//// SHOW EDIT FORM
    on<ShowEditEligibilityForm>((event, emit) async {
      emit(EligibilityLoadingState());
      try {
        if (globalCountries.isEmpty) {
          List<Country> countries = await LocationUtils.instance.getCountries();
          globalCountries = countries;
        }
        if (globalRegions.isEmpty) {
          List<Region> regions = await LocationUtils.instance.getRegions();
          globalRegions = regions;
        }
        if (globalEligibilities.isEmpty) {
          List<Eligibility> eligibilities =
              await ProfileUtilities.instance.getEligibilities();
          globalEligibilities = eligibilities;
        }
        Eligibility currentEligibility = globalEligibilities.firstWhere(
            (Eligibility eligibility) =>
                event.eligibityCert.eligibility!.id == eligibility.id);
        bool? isOverseas = event.eligibityCert.overseas;
        Country currentCountry = globalCountries.firstWhere((Country country) =>
            event.eligibityCert.examAddress!.country!.code == country.code);
        if (event.eligibityCert.examAddress?.cityMunicipality?.province
                ?.region !=
            null) {
          Region currrentRegion = globalRegions.firstWhere((Region region) =>
              event.eligibityCert.examAddress!.cityMunicipality!.province!
                  .region!.code ==
              region.code);
          List<Province> provinces = await LocationUtils.instance
              .getProvinces(selectedRegion: currrentRegion);
          Province currentProvince = provinces.firstWhere((Province province) =>
              event.eligibityCert.examAddress!.cityMunicipality!.province!
                  .code ==
              province.code);
          List<CityMunicipality> cities = await LocationUtils.instance
              .getCities(selectedProvince: currentProvince);
          CityMunicipality currentCity = cities.firstWhere(
              (CityMunicipality cityMunicipality) =>
                  event.eligibityCert.examAddress!.cityMunicipality!.code ==
                  cityMunicipality.code);

          emit(EditEligibilityState(
              currentCity: currentCity,
              selectedCountry: currentCountry,
              currentProvince: currentProvince,
              currentRegion: currrentRegion,
              currentEligibility: currentEligibility,
              provinces: provinces,
              cities: cities,
              isOverseas: isOverseas ??= false,
              eligibityCert: event.eligibityCert,
              countries: globalCountries,
              regions: globalRegions,
              eligibilities: globalEligibilities));
        } else {
          emit(EditEligibilityState(
              selectedCountry: currentCountry,
              currentCity: null,
              currentProvince: null,
              currentRegion: null,
              provinces: null,
              cities: null,
              currentEligibility: currentEligibility,
              isOverseas: isOverseas!,
              eligibityCert: event.eligibityCert,
              countries: globalCountries,
              regions: globalRegions,
              eligibilities: globalEligibilities));
        }
      } catch (e) {
        emit(ShowEditFormErrorState(eligibityCert: event.eligibityCert));
      }
    });

    //// UPDATE
    on<UpdateEligibility>((event, emit) async {
      try {
        emit(EligibilityLoadingState());
        Map<dynamic, dynamic> status = await EligibilityService.instance.update(
            eligibityCert: event.eligibityCert,
            token: event.token,
            profileId: int.parse(event.profileId),
            oldEligibility: event.oldEligibility);
        if (status['success']) {
          EligibityCert newEligibility = EligibityCert.fromJson(status['data']);
          eligibilities.removeWhere(
              (EligibityCert element) => element.id == event.eligibityCert.id);
          eligibilities.add(newEligibility);
          emit(EligibilityEditedState(response: status));
        } else {
          emit(EligibilityEditedState(response: status));
        }
      } catch (e) {
        emit(EligibilityUpdatingErrorState(
            eligibityCert: event.eligibityCert,
            intOldEligibilityId: event.oldEligibility));
      }
    });
    //// SHOW ADD FORM
    on<ShowAddEligibilityForm>((event, emit) async {
      emit(EligibilityLoadingState());
      try {
        if (globalRegions.isEmpty) {
          List<Region> regions = await LocationUtils.instance.getRegions();
          globalRegions = regions;
        }
        if (globalEligibilities.isEmpty) {
          List<Eligibility> eligibilities =
              await ProfileUtilities.instance.getEligibilities();
          globalEligibilities = eligibilities;
        }
        if (globalCountries.isEmpty) {
          List<Country> countries = await LocationUtils.instance.getCountries();
          globalCountries = countries;
        }

        emit(AddEligibilityState(
            eligibilities: globalEligibilities,
            regions: globalRegions,
            countries: globalCountries));
      } catch (e) {
        emit(ShowAddFormErrorState());
      }
    });

    //// ADD
    on<AddEligibility>(
      (event, emit) async {
        try {
          emit(EligibilityLoadingState());
          Map<dynamic, dynamic> status = await EligibilityService.instance.add(
              eligibityCert: event.eligibityCert,
              token: event.token,
              profileId: int.parse(event.profileId));
          if (status['success']) {
            EligibityCert? eligibityCert =
                EligibityCert.fromJson(status['data']);
            eligibilities.add(eligibityCert);
            emit(EligibilityAddedState(response: status));
          } else {
            emit(EligibilityAddedState(response: status));
          }
        } catch (e) {
          emit(EligibilityAddingErrorState(eligibityCert: event.eligibityCert));
        }
      },
    );
    on<CallErrorState>((event, emit) {
      emit(const EligibilityErrorState(
          message: "Something went wrong. Please try again"));
    });
    ////Add attachment
    on<AddEligibiltyAttachment>((event, emit) async {
      emit(EligibilityLoadingState());
      List<Attachment> attachments = [];
      EligibityCert eligibityCert = eligibilities.firstWhere(
          (element) => element.id.toString() == event.attachmentModule);
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
          eligibityCert.attachments == null
              ? eligibityCert.attachments = attachments
              : eligibityCert.attachments = [
                  ...eligibityCert.attachments!,
                  ...attachments
                ];
          emit(EligibilityAttachmentAddedState(response: status));
        } else {
          emit(EligibilityAttachmentAddedState(response: status));
        }
      } catch (e) {
          emit(AddAttachmentError(attachmentModule: event.attachmentModule,filePaths: event.filePaths,categoryId: event.categoryId));
      }
    });

    on<DeleteEligibyAttachment>((event, emit) async {
      emit(EligibilityLoadingState());
      try {
        final bool success = await AttachmentServices.instance.deleteAttachment(
            attachment: event.attachment,
            moduleId: int.parse(event.moduleId),
            profileId: event.profileId.toString(),
            token: event.token);
        if (success) {
          final EligibityCert eligibityCert = eligibilities
              .firstWhere((element) => element.id.toString() == event.moduleId);
          eligibityCert.attachments
              ?.removeWhere((element) => element.id == event.attachment.id);
          eligibilities.removeWhere(
              (element) => element.id.toString() == event.moduleId);
          eligibilities.add(eligibityCert);
          emit(EligibilitytAttachmentDeletedState(success: success));
        } else {
          emit(EligibilitytAttachmentDeletedState(success: success));
        }
      } catch (e) {
        emit(ErrorDeleteEligibyAttachmentState(
            attachment: event.attachment,
            profileId: event.profileId,
            moduleId: event.moduleId,
            token: event.token));
      }
    });
    on<EligibiltyViewAttachmentEvent>((event, emit) {
      String fileUrl =
          '${Url.instance.prefixHost()}${Url.instance.host()}/media/${event.source}';
      emit(EligibilityAttachmentViewState(
          fileUrl: fileUrl, fileName: event.filename));
    });
    on<ShareAttachment>((event, emit) async {
      emit(EligibilityLoadingState());
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
        directory = await getApplicationDocumentsDirectory();
        appDocumentPath = directory.path;
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
            emit(EligibilityAttachmentViewState(
                fileUrl: event.source, fileName: event.fileName));
          } else {
            Fluttertoast.showToast(msg: "Attachment shared unsuccessful");
            emit(EligibilityAttachmentViewState(
                fileUrl: event.source, fileName: event.fileName));
          }
        } else {
          emit(EligibilityAttachmentViewState(
              fileUrl: event.source, fileName: event.fileName));
        }
      } catch (e) {
        emit(EligibilityErrorState(message: e.toString()));
      }
    });
  }
}
