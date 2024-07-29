import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:unit2/model/sos/session.dart';
import 'package:unit2/sevices/sos/sos_service.dart';

import '../../utils/global.dart';

part 'sos_event.dart';
part 'sos_state.dart';

class SosBloc extends Bloc<SosEvent, SosState> {
  SosBloc() : super(SosInitial()) {
    LocationData? locationData;
    String? mobile1;
    String? mobile2;
    String? sessionToken;
    ////get user location
    on<LoadUserLocation>((event, emit) async {
      emit(const LoadingState(message: "Getting Location"));
      mobile1 = await SOS!.get('mobile1');
      mobile2 = await SOS!.get('mobile2');
      sessionToken = await SOS!.get('session_token');
      if (mobile1 != null) {
        if (sessionToken != null) {
          add(CheckAcknowledgement(sessionToken: sessionToken!));
        } else {
          try {
            LocationData? newLocationData =
                await SosService.instance.getUserLocation();
            locationData = newLocationData;

            emit(RequestSosState(
                locationData: locationData!,
                mobile1: mobile1!,
                mobile2: mobile2));
          } catch (e) {
            emit(ErrorState(message: e.toString()));
          }
        }
      } else {
        try {
          LocationData? newLocationData =
              await SosService.instance.getUserLocation();
          locationData = newLocationData;

          emit(UserLocationLoaded(locationData: locationData!));
        } catch (e) {
          emit(ErrorState(message: e.toString()));
        }
      }
    });
    ////submit mobile
    on<SubmitMobile>((event, emit) async {
      emit(const LoadingState(message: ""));
      mobile1 = event.mobile1;
      mobile2 = event.mobile2;
      await SOS!.put('mobile1', event.mobile1);
      await SOS!.put('mobile2', event.mobile2);
      emit(RequestSosState(
          locationData: locationData!,
          mobile1: event.mobile1,
          mobile2: event.mobile2));
    });

    //// send SOS
    on<SendSOS>((event, emit) async {
      SessionData sessionData;
      emit(const LoadingState(message: "Sending emergency response request"));
      try {
        sessionData = await SosService.instance.requestSos(
            location: locationData!,
            mobile1: mobile1!,
            mobile2: mobile2,
            msg: event.msg,
            requestedDate: event.requestDate);
        await SOS!.put('session_token', sessionData.sessionToken);
        emit(SOSReceivedState(sessionToken: sessionData.sessionToken!));
      } catch (e) {
        emit(ErrorState(message: e.toString()));
      }
    });
    //// check acknowledgement
    on<CheckAcknowledgement>((event, emit) async {
      SessionData sessionData;
      try {
        SessionData? newSessionData =
            await SosService.instance.checkAcknowledgement(event.sessionToken);
        if (newSessionData.acknowledgeDate == null) {
          emit(SOSReceivedState(sessionToken: newSessionData.sessionToken!));
        } else {
          sessionData = newSessionData;
          emit(SoSAcknowledgementConfirm(sessionData: sessionData));
        }
      } catch (e) {
        emit(ErrorState(message: e.toString()));
      }
    });
    on<OnDoneRequest>((event, emit) async {
      await SOS!.delete('session_token');
      add(LoadUserLocation());
    });
  }
}
