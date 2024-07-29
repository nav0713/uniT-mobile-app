part of 'sos_bloc.dart';

abstract class SosState extends Equatable {
  const SosState();
  
  @override
  List<Object> get props => [];
}

class SosInitial extends SosState {}

class UserLocationLoaded extends SosState {
  final LocationData locationData;
  const UserLocationLoaded({required this.locationData});
  @override
  List<Object> get props => [locationData];
}
class ErrorState extends SosState{
  final String message;
  const ErrorState({required this.message});
    @override
  List<Object> get props => [message];
}
class RequestSosState extends SosState{
  final LocationData locationData;
  final String mobile1;
  final String? mobile2;

  const RequestSosState({required this.locationData, required this.mobile1, required this.mobile2});
      @override
  List<Object> get props => [locationData,mobile1];
}

class LoadingState extends SosState{
  final String message;
  const LoadingState({required this.message});
}
class SOSReceivedState extends SosState {
  final String sessionToken;
  const SOSReceivedState({required this.sessionToken});
  @override
  List<Object> get props => [sessionToken];
}

class SoSAcknowledgementConfirm extends SosState{
  final SessionData sessionData;
  const SoSAcknowledgementConfirm({required this.sessionData});
  @override
  List<Object> get props => [sessionData];
}
