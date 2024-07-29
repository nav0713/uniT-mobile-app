part of 'address_bloc.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object> get props => [];
}

class GetAddress extends AddressEvent {
  final List<MainAdress> addresses;
  const GetAddress({required this.addresses});
  @override
  List<Object> get props => [addresses];
}

class ShowAddAddressForm extends AddressEvent {}

class ShowEditAddressForm extends AddressEvent {
  final bool overseas;
  final MainAdress address;
  const ShowEditAddressForm({required this.address, required this.overseas});
}

class CallErrorState extends AddressEvent {}

class AddAddress extends AddressEvent {
  final AddressClass address;
  final int categoryId;
  final String? details;
  final int? blockNumber;
  final int? lotNumber;
  final String token;
  final int profileId;
  const AddAddress(
      {required this.address,
      required this.profileId,
      required this.token,
      required this.blockNumber,
      required this.categoryId,
      required this.details,
      required this.lotNumber});
  @override
  List<Object> get props => [address, token, profileId,categoryId];
}

class UpdateAddress extends AddressEvent {
  final AddressClass address;
  final int categoryId;
  final String? details;
  final int? blockNumber;
  final int? lotNumber;
  final String token;
  final int profileId;
  const UpdateAddress(
      {required this.address,
      required this.profileId,
      required this.token,
      required this.blockNumber,
      required this.categoryId,
      required this.details,
      required this.lotNumber});
        @override
  List<Object> get props => [address, token, profileId,categoryId];
}
  

class LoadAddress extends AddressEvent{

}

class DeleteAddress extends AddressEvent {
  final String profileId;
  final int id;
  final String token;
  const DeleteAddress(
      {
      required this.id,
      required this.profileId,
      required this.token});
  @override
  List<Object> get props => [ profileId, id, token];
}

