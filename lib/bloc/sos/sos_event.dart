part of 'sos_bloc.dart';

abstract class SosEvent extends Equatable {
  const SosEvent();

  @override
  List<Object> get props => []; 
}

class LoadUserLocation extends SosEvent {
  @override
  List<Object> get props => [];
}

class SubmitMobile extends SosEvent {
  final String mobile1;
  final String? mobile2;
  const 
  SubmitMobile({required this.mobile1,required this.mobile2});
  @override
  List<Object> get props => [];

}

class SendSOS extends SosEvent {
  final String msg;
  final String requestDate;
  const SendSOS({required this.msg, required this.requestDate});
  @override
  List<Object> get props => [msg, requestDate];
}

class CheckAcknowledgement extends SosEvent {
  final String sessionToken;
  const CheckAcknowledgement({required this.sessionToken});
  @override
  List<Object> get props => [sessionToken];
}

class OnDoneRequest extends SosEvent {
  @override
  List<Object> get props => [];
}