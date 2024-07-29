part of 'address_bloc.dart';

abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object> get props => [];
}

class AddressInitial extends AddressState {}

//// LOADED STATE
class AddressLoadedState extends AddressState {
  final List<MainAdress> addresses;
  const AddressLoadedState({required this.addresses});
  @override
  List<Object> get props => [addresses];
}

////ERROR STATE
class AddressErrorState extends AddressState {
  final String message;
  const AddressErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

//// LOADING STATE
class AddressLoadingState extends AddressState {}

////ADD ADDRESS STATE
class AddAddressState extends AddressState {
  final List<Country> countries;
  final List<Region> regions;
  const AddAddressState({required this.countries, required this.regions});
  @override
  List<Object> get props => [
        countries,
        regions,
      ];
}

//// DeletedState
class AddressDeletedState extends AddressState {
  final bool success;
  const AddressDeletedState({required this.success});
  @override
  List<Object> get props => [success];
}

////AddedState
class AddressAddedState extends AddressState {
  final Map<dynamic, dynamic> response;
  const AddressAddedState({required this.response});
  @override
  List<Object> get props => [response];
}

////Edited State
class AddressUpdatedState extends AddressState {
  final Map<dynamic, dynamic> response;
  const AddressUpdatedState({required this.response});
  @override
  List<Object> get props => [response];
}

class AddAdressErrorState extends AddressState{
    final AddressClass address;
  final int categoryId;
  final String? details;
  final int? blockNumber;
  final int? lotNumber;

  const AddAdressErrorState({required this.address, required this.categoryId, required this.details, required this.blockNumber, required this.lotNumber});

}

class UpdateErrorState extends AddressState{
   final AddressClass address;
  final int categoryId;
  final String? details;
  final int? blockNumber;
  final int? lotNumber;

  const UpdateErrorState({required this.address, required this.categoryId, required this.details, required this.blockNumber, required this.lotNumber});
}

class EditAddressState extends AddressState {
  final MainAdress address;
  final List<Country> countries;
  final List<Region> regions;
  final List<Province> provinces;
  final List<CityMunicipality> cities;
  final List<Barangay> baragays;
  final Region? currentRegion;
  final Country currentCountry;
  final Province? currentProvince;
  final CityMunicipality? currentCity;
  final Barangay? currentBarangay;
  final bool overseas;

  const EditAddressState(
      {required this.address,
      required this.countries,
      required this.regions,
      required this.baragays,
      required this.cities,
      required this.currentCity,
      required this.currentCountry,
      required this.currentProvince,
      required this.currentRegion,
      required this.overseas,
      required this.provinces,
      required this.currentBarangay
      });
  @override
  List<Object> get props => [countries, regions, address];
}

class ShowAddFormErrorState extends AddressState{

}
class ShowEditFormErrorState extends AddressState{
  final bool isOverSeas;
  final MainAdress address;
  const ShowEditFormErrorState({required this.isOverSeas, required this.address});
    @override
  List<Object> get props => [isOverSeas,address];
}

class AddressErrorDelete extends AddressState {

  final int id;

  const AddressErrorDelete(
      {
      required this.id,
});
  @override
  List<Object> get props => [  id,];
}
