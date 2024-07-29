import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unit2/model/location/barangay.dart';
import 'package:unit2/model/location/subdivision.dart';
import 'package:unit2/sevices/profile/address_service.dart';

import '../../../../model/location/city.dart';
import '../../../../model/location/country.dart';
import '../../../../model/location/provinces.dart';
import '../../../../model/location/region.dart';
import '../../../../model/profile/basic_information/adress.dart';
import '../../../../utils/location_utilities.dart';

part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressBloc() : super(AddressInitial()) {
    List<Country> globalCountries = [];
    List<Region> globalRegions = [];
    List<MainAdress> addresses = [];
    List<Province> provinces = [];
    List<CityMunicipality> cities = [];
    List<Barangay> barangays = [];
    Region? currentRegion;
    Country currentCountry;
    Province? currentProvince;
    CityMunicipality? currentCity;
    Barangay? currentBarangay;
    on<GetAddress>((event, emit) {
      emit(AddressLoadingState());
      try {
        addresses = event.addresses;
        emit(AddressLoadedState(addresses: addresses));
      } catch (e) {
        emit(AddressErrorState(message: e.toString()));
      }
    });
    ////Load
    on<LoadAddress>((event, emit) {
      emit(AddressLoadedState(addresses: addresses));
    });

    //// show add form
    on<ShowAddAddressForm>((event, emit) async {
      emit(AddressLoadingState());
      try {
        if (globalRegions.isEmpty) {
          List<Region> regions = await LocationUtils.instance.getRegions();
          globalRegions = regions;
        }
        if (globalCountries.isEmpty) {
          List<Country> countries = await LocationUtils.instance.getCountries();
          globalCountries = countries;
        }

        emit(AddAddressState(
            countries: globalCountries, regions: globalRegions));
      } catch (e) {
        emit(ShowAddFormErrorState());
      }
    });

    //// Show Edit Form
    on<ShowEditAddressForm>((event, emit) async {
      try {
        emit(AddressLoadingState());
        if (globalRegions.isEmpty) {
          List<Region> regions = await LocationUtils.instance.getRegions();
          globalRegions = regions;
        }
        if (globalCountries.isEmpty) {
          List<Country> countries = await LocationUtils.instance.getCountries();
          globalCountries = countries;
        }
        currentCountry = globalCountries.firstWhere((Country country) =>
            event.address.address!.country!.code == country.code);

        if (!event.overseas) {
          //// if not overseas
          currentRegion = globalRegions.firstWhere((Region region) =>
              event.address.address!.cityMunicipality!.province!.region!.code ==
              region.code);
          provinces = await LocationUtils.instance
              .getProvinces(selectedRegion: currentRegion!);
          currentProvince = provinces.firstWhere((Province province) =>
              event.address.address!.cityMunicipality!.province!.code ==
              province.code);

          cities = await LocationUtils.instance
              .getCities(selectedProvince: currentProvince!);

          currentCity = cities.firstWhere((CityMunicipality cityMunicipality) =>
              event.address.address!.cityMunicipality!.code ==
              cityMunicipality.code);
          barangays = await LocationUtils.instance
              .getBarangay(cityMunicipality: currentCity!);
          if (event.address.address?.barangay != null) {
            currentBarangay = barangays.firstWhere((Barangay barangay) =>
                event.address.address?.barangay?.code == barangay.code);
          } else {
            currentBarangay = null;
          }
        }

        emit(EditAddressState(
            countries: globalCountries,
            regions: globalRegions,
            address: event.address,
            baragays: barangays,
            cities: cities,
            currentCity: currentCity,
            currentCountry: currentCountry,
            currentProvince: currentProvince,
            currentRegion: currentRegion,
            overseas: event.overseas,
            provinces: provinces,
            currentBarangay: currentBarangay));
      } catch (e) {
        emit(ShowEditFormErrorState(
            isOverSeas: event.overseas, address: event.address));
      }
    });
    ////Add
    on<AddAddress>(
      (event, emit) async {
        emit(AddressLoadingState());
        try {
          Map<String, dynamic> status = await AddressService.instance.add(
              address: event.address,
              categoryId: event.categoryId,
              token: event.token,
              details: event.details,
              blockNumber: event.blockNumber,
              lotNumber: event.lotNumber,
              profileId: event.profileId);
          if (status['success']) {
            AddressClass addressClass =
                AddressClass.fromJson(status['data']['address']);
            Subdivision? subdivision = status['data']['subdivision'] != null
                ? Subdivision.fromJson(status['data']['subdivision'])
                : null;
            MainAdress address = MainAdress(
                address: addressClass,
                subdivision: subdivision,
                id: status['data']['id'],
                details: status['data']['details']);
            addresses.add(address);
            emit(AddressAddedState(response: status));
          } else {
            emit(AddressAddedState(response: status));
          }
        } catch (e) {
          emit(AddAdressErrorState(
              address: event.address,
              categoryId: event.categoryId,
              details: event.details,
              blockNumber: event.blockNumber,
              lotNumber: event.lotNumber));
        }
      },
    );
    ////update
    on<UpdateAddress>(
      (event, emit) async {
        try {
                  emit(AddressLoadingState());
          Map<String, dynamic> status = await AddressService.instance.update(
              address: event.address,
              categoryId: event.categoryId,
              token: event.token,
              details: event.details,
              blockNumber: event.blockNumber,
              lotNumber: event.lotNumber,
              profileId: event.profileId);
          if (status['success']) {
            AddressClass addressClass =
                AddressClass.fromJson(status['data']['address']);
            Subdivision? subdivision = status['data']['subdivision'] != null
                ? Subdivision.fromJson(status['data']['subdivision'])
                : null;
            MainAdress address = MainAdress(
                address: addressClass,
                subdivision: subdivision,
                id: status['data']['id'],
                details: status['data']['details']);
            addresses.add(address);

            addresses.removeWhere((address) => address.id == event.address.id);
            addresses.add(address);

            emit(AddressUpdatedState(response: status));
          } else {
            emit(AddressUpdatedState(response: status));
          }
        } catch (e) {
          emit(UpdateErrorState(address: event.address,categoryId: event.categoryId,details: event.details,blockNumber: event.blockNumber,lotNumber: event.lotNumber));
        }
      },
    );

////Delete
    on<DeleteAddress>((event, emit) async {
      try {
        emit(AddressLoadingState());
        final bool success = await AddressService.instance.delete(
            addressId: event.id,
            profileId: int.parse(event.profileId),
            token: event.token);
        if (success) {
          addresses
              .removeWhere(((MainAdress element) => element.id == event.id));
          emit(AddressDeletedState(
            success: success,
          ));
        } else {
          emit(AddressDeletedState(success: success));
        }
      } catch (e) {
        emit(AddressErrorDelete(id: event.id));
      }
    });
    ////call error state
    on<CallErrorState>((event, emit) {
      emit(const AddressErrorState(
          message: "Something went wrong. Please try again"));
    });
  }
}
