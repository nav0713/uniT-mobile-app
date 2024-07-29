import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unit2/sevices/profile/identification_services.dart';
import '../../../../model/location/city.dart';
import '../../../../model/location/country.dart';
import '../../../../model/location/provinces.dart';
import '../../../../model/location/region.dart';
import '../../../../model/profile/basic_information/identification_information.dart';
import '../../../../model/utils/agency.dart';
import '../../../../model/utils/category.dart';
import '../../../../utils/location_utilities.dart';
import '../../../../utils/profile_utilities.dart';

part 'identification_event.dart';
part 'identification_state.dart';

class IdentificationBloc
    extends Bloc<IdentificationEvent, IdentificationState> {
  IdentificationBloc() : super(IdentificationInitial()) {
    List<Identification> identificationInformations = [];
    List<Agency> agencies = [];
    List<Agency> addedAgencies = [];
    List<Category> agencyCategory = [];
    List<Country> globalCountries = [];
    List<Region> globalRegions = [];
    List<Province> provinces = [];
    List<CityMunicipality> cities = [];
    Region? currentRegion;
    Country currentCountry;
    Province? currentProvince;
    CityMunicipality? currentCity;
    ////get
    on<GetIdentifications>((event, emit) {
      try {
        identificationInformations = event.identificationInformation;
        emit(IdentificationLoadedState(
            identificationInformation: identificationInformations));
      } catch (e) {
        emit(IdenficationErrorState(message: e.toString()));
      }
    });
    ////load
    on<LoadIdentifications>((event, emit) {
      emit(IdentificationLoadedState(
          identificationInformation: identificationInformations));
    });
    //// show add form
    on<ShowAddIdentificationForm>((event, emit) async {
      addedAgencies.clear();
      try {
        emit(IdentificationLoadingState());
        if (identificationInformations.isNotEmpty) {
          for (var element in identificationInformations) {
            addedAgencies.add(element.agency!);
          }
        }
        /////AGENCIES------------------------------------------
        if (agencies.isEmpty) {
          List<Agency> newAgencies =
              await ProfileUtilities.instance.getAgecies();
          agencies = newAgencies;
        }
        /////Category Agency------------------------------------------
        if (agencyCategory.isEmpty) {
          List<Category> categoryAgencies =
              await ProfileUtilities.instance.agencyCategory();
          agencyCategory = categoryAgencies;
        }
        ////regions
        if (globalRegions.isEmpty) {
          List<Region> regions = await LocationUtils.instance.getRegions();
          globalRegions = regions;
        }
        //// country
        if (globalCountries.isEmpty) {
          List<Country> countries = await LocationUtils.instance.getCountries();
          globalCountries = countries;
        }
        emit(IdentificationAddingState(
            addedAgencies: addedAgencies,
            agencyCategory: agencyCategory,
            agencies: agencies,
            countries: globalCountries,
            regions: globalRegions));
      } catch (e) {
        emit(ShowAddFormErrorState());
      }
    });
    ////show edit form
    on<ShowEditIdentificationForm>((event, emit) async {
      try {
                emit(IdentificationLoadingState());
        ////regions
        if (globalRegions.isEmpty) {
          List<Region> regions = await LocationUtils.instance.getRegions();
          globalRegions = regions;
        }
        //// country
        if (globalCountries.isEmpty) {
          List<Country> countries = await LocationUtils.instance.getCountries();
          globalCountries = countries;
        }
        currentCountry = globalCountries.firstWhere((Country country) =>
            event.identification.issuedAt!.country!.code == country.code);
        if (!event.overseas) {
          currentRegion = globalRegions.firstWhere((Region region) =>
              event.identification.issuedAt!.cityMunicipality!.province!.region!
                  .code ==
              region.code);
          provinces = await LocationUtils.instance
              .getProvinces(selectedRegion: currentRegion!);
          currentProvince = provinces.firstWhere((Province province) =>
              event.identification.issuedAt!.cityMunicipality!.province!.code ==
              province.code);

          cities = await LocationUtils.instance
              .getCities(selectedProvince: currentProvince!);

          currentCity = cities.firstWhere((CityMunicipality cityMunicipality) =>
              event.identification.issuedAt!.cityMunicipality!.code ==
              cityMunicipality.code);
        }
        emit(IdentificationEditingState(
            cities: cities,
            countries: globalCountries,
            currentCity: currentCity,
            currentCountry: currentCountry,
            currentProvince: currentProvince,
            currentRegion: currentRegion,
            identification: event.identification,
            overseas: event.overseas,
            provinces: provinces,
            regions: globalRegions));
      } catch (e) {
        emit(ShowEditFormErrorState(
            identification: event.identification, isOverseas: event.overseas));
      }
    });
    ////add
    on<AddIdentification>((event, emit) async {
      try {
        emit(IdentificationLoadingState());
        Map<dynamic, dynamic> status = await IdentificationServices.instance
            .add(
                identification: event.identification,
                profileId: event.profileId,
                token: event.token);
        if (status['success']) {
          Identification identification =
              Identification.fromJson(status['data']);
          identificationInformations.add(identification);
          emit(IdentificationAddedState(response: status));
        } else {
          emit(IdentificationAddedState(response: status));
        }
      } catch (e) {
        emit(IdentificationAddingErrorState(
          identification: event.identification,
        ));
      }
    });
    ////update
    on<UpdateIdentifaction>((event, emit) async {
      try {
        emit(IdentificationLoadingState());
        Map<dynamic, dynamic> status = await IdentificationServices.instance
            .update(
                identification: event.identification,
                profileId: event.profileId,
                token: event.token);
        if (status['success']) {
          identificationInformations
              .removeWhere((element) => element.id == event.identification.id);
          Identification identification =
              Identification.fromJson(status['data']);
          identificationInformations.add(identification);
          emit(IdentificationEditedState(response: status));
        } else {
          emit(IdentificationEditedState(response: status));
        }
      } catch (e) {
        emit(
            IdentificationEditErrorState(identification: event.identification));
      }
    });
    ////delete
    on<DeleteIdentification>((event, emit) async {
      try {
        emit(IdentificationLoadingState());
        final bool success = await IdentificationServices.instance.delete(
            identificationId: event.identificationId,
            token: event.token,
            profileId: event.profileId);
        if (success) {
          identificationInformations.removeWhere(
              (Identification element) => element.id == event.identificationId);
          emit(IdentificationDeletedState(success: success));
        } else {
          emit(IdentificationDeletedState(success: success));
        }
      } catch (e) {
        emit(IdentificationDeleteErrorState(
            identificationId: event.identificationId));
      }
    });
    ////show error state
    on<ShowErrorState>((event, emit) {
      emit(IdenficationErrorState(message: event.message));
    });
  }
}
