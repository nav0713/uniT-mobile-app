import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unit2/model/location/address_category.dart';
import 'package:unit2/model/location/barangay.dart';
import 'package:unit2/model/location/city.dart';
import 'package:unit2/model/location/country.dart';
import 'package:unit2/model/location/region.dart';
import 'package:unit2/sevices/profile/references_services.dart';
import '../../../model/location/provinces.dart';
import '../../../model/profile/references.dart';
import '../../../utils/location_utilities.dart';

part 'references_event.dart';
part 'references_state.dart';

class ReferencesBloc extends Bloc<ReferencesEvent, ReferencesState> {
  List<PersonalReference> references = [];
  List<Country> globalCountries = [];
  List<Region> globalRegions = [];
  List<AddressCategory> globalCategories = [];

  ReferencesBloc() : super(ReferencesInitial()) {
    on<GetReferences>((event, emit) async {
      emit(ReferencesLoadingState());
      try {
        if (references.isEmpty) {
          List<PersonalReference> refs = await ReferencesServices.instace
              .getRefences(event.profileId, event.token);
          references = refs;
          emit(ReferencesLoadedState(references: references));
        }
        emit(ReferencesLoadedState(references: references));
      } catch (e) {
        emit(ReferencesErrorState(message: e.toString()));
      }
    });
////SHOW FORM FOR ADDING REFERENCES

    on<ShowAddReferenceForm>((event, emit) async {
      emit(ReferencesLoadingState());
      try {
        
        if (globalRegions.isEmpty) {
          List<Region> regions = await LocationUtils.instance.getRegions();
          globalRegions = regions;
        }
        if (globalCountries.isEmpty) {
          List<Country> countries = await LocationUtils.instance.getCountries();
          globalCountries = countries;
        }
        if (globalCategories.isEmpty) {
          List<AddressCategory> categories =
              await LocationUtils.instance.getAddressCategory();
          globalCategories = categories;
        }
        emit(AddReferenceState(
            countries: globalCountries,
            regions: globalRegions,
            categories: globalCategories));
      } catch (e) {
        emit(ShowAddFormErrorState());
      }

    });
          ////SHOW EDIT FORM
    on<ShowEditReferenceForm>((event, emit) async {
      Region? selectedRegion;
      Province? selectedProvince;
      CityMunicipality? selectedCity;
      AddressCategory? selectedCategory;
      Country selectedCountry;
      Barangay? selectedBarangay;
      try {
              emit(ReferencesLoadingState());
        if (globalRegions.isEmpty) {
          List<Region> regions = await LocationUtils.instance.getRegions();
          globalRegions = regions;
        }
        if (globalCountries.isEmpty) {
          List<Country> countries = await LocationUtils.instance.getCountries();
          globalCountries = countries;
        }
        if (globalCategories.isEmpty) {
          List<AddressCategory> categories =
              await LocationUtils.instance.getAddressCategory();
          globalCategories = categories;
        }
//// checck if address is overseas
        bool overseas =
            event.personalReference.address!.country!.id! != 175 ? true : false;
        selectedCategory = globalCategories.firstWhere(
            (AddressCategory element) =>
                event.personalReference.address!.addressCategory!.id ==
                element.id);
        ////if address is not overseas set initial values for address
        if (!overseas) {
          selectedRegion = globalRegions.firstWhere((Region element) =>
              event.personalReference.address!.cityMunicipality!.province!
                  .region!.code ==
              element.code);
          List<Province> provinces = await LocationUtils.instance
              .getProvinces(selectedRegion: selectedRegion);
          selectedProvince = provinces.firstWhere((Province province) =>
              event.personalReference.address!.cityMunicipality!.province!
                  .code ==
              province.code);
          List<CityMunicipality> cities = await LocationUtils.instance
              .getCities(selectedProvince: selectedProvince);
          selectedCity = cities.firstWhere((CityMunicipality city) =>
              event.personalReference.address!.cityMunicipality!.code ==
              city.code);
          List<Barangay> barangays = await LocationUtils.instance
              .getBarangay(cityMunicipality: selectedCity);
          if (event.personalReference.address?.barangay != null) {
            selectedBarangay = barangays.firstWhere((Barangay barangay) =>
                event.personalReference.address?.barangay?.code ==
                barangay.code);
          } else {
            selectedBarangay = null;
          }
          emit(EditReferenceState(
              selectedRegion: selectedRegion,
              ref: event.personalReference,
              countries: globalCountries,
              regions: globalRegions,
              barangays: barangays,
              categories: globalCategories,
              isOverseas: overseas,
              provinces: provinces,
              selectedProvince: selectedProvince,
              cities: cities,
              selectedCity: selectedCity,
              selectedCategory: selectedCategory,
              selectedBarangay: selectedBarangay));
        } else {
          //// if address is overseas set initial value for country
          selectedCountry = globalCountries.firstWhere((Country element) =>
              event.personalReference.address!.country!.id == element.id);
          emit(EditReferenceState(
              selectedCountry: selectedCountry,
              selectedCategory: selectedCategory,
              selectedRegion: null,
              ref: event.personalReference,
              countries: globalCountries,
              regions: globalRegions,
              categories: globalCategories,
              isOverseas: overseas));
        }
      } catch (e) {
        emit(ShowEditFormErrorState(personalReference: event.personalReference));
      }
    });

    //// CALL THE ERROR STATE EVEN T
    on<CallErrorState>((event, emit) async {
      emit(const ReferencesErrorState(
          message: "Something went wrong. Please try again"));
      //// EDIT REFERENCES EVENT
    });
    on<EditReference>((event, emit) async {
      try {
        emit(ReferencesLoadingState());
        Map<dynamic, dynamic> status = await ReferencesServices.instace.update(
            ref: event.reference,
            token: event.token,
            profileId: event.profileId);
        if (status['success']) {
          PersonalReference ref = PersonalReference.fromJson(status['data']);
          references.removeWhere(
              (PersonalReference element) => element.id == event.reference.id);
          references.add(ref);
          emit(ReferenceEditedState(response: status));
        } else {
          emit(ReferenceEditedState(response: status));
        }
      } catch (e) {
        emit(ReferenceUpdatingErrorState(reference: event.reference));
      }
    });

//// add reference event
    on<AddReference>((event, emit) async {
      try {
           emit(ReferencesLoadingState());
        Map<dynamic, dynamic> status = await ReferencesServices.instace
            .addReference(
                ref: event.reference,
                token: event.token,
                profileId: event.profileId);
        if (status['success']) {
          PersonalReference ref = PersonalReference.fromJson(status['data']);
          references.add(ref);
          emit(ReferencesAddedState(response: status));
        } else {
          emit(ReferencesAddedState(response: status));
        }
      } catch (e) {
        emit(ReferencesAddingErrorState(reference: event.reference));
      }
    });
    ////LOAD REFERENCE
    on<LoadReferences>((event, emit) {
      emit(ReferencesLoadingState());
      emit(ReferencesLoadedState(references: references));
    });
    ////DELETE REFERENCE
    on<DeleteReference>((event, emit) async {
      try {
                   emit(ReferencesLoadingState());
        final bool success = await ReferencesServices.instace.delete(
            profileId: event.profileId, token: event.token, id: event.refId);
        if (success) {
          event.references.removeWhere(
              (PersonalReference element) => element.id == event.refId);
          references = event.references;
          emit(DeleteReferenceState(success: success));
        } else {
          emit(DeleteReferenceState(success: success));
        }
      } catch (e) {
        emit(ReferenceDeletingErrorState(refId: event.refId,references: event.references));
      }
    });
  }
}
