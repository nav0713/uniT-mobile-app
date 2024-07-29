import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unit2/model/location/country.dart';
import 'package:unit2/model/profile/basic_information/citizenship.dart';
import 'package:unit2/sevices/profile/citizenship_services.dart';
import 'package:unit2/utils/location_utilities.dart';

part 'citizenship_event.dart';
part 'citizenship_state.dart';

class CitizenshipBloc extends Bloc<CitizenshipEvent, CitizenshipState> {
  List<Citizenship> citizenships = [];
  List<Country> countries = [];
  CitizenshipBloc() : super(CitizenshipInitial()) {
    on<GetCitizenship>((event, emit) async {
      emit(CitizenshipLoadingState());
      try {
        countries = await LocationUtils.instance.getCountries();
        citizenships = event.citizenship;
        emit(CitizenshipLoaded(
            citizenships: event.citizenship, countries: countries));
      } catch (e) {
        emit(CitizenshipErrorState(message: e.toString()));
      }
    });
    on<LoadCitizenship>((event, emit) {
      emit(CitizenshipLoaded(citizenships: citizenships, countries: countries));
    });
    on<AddCitizenship>((event, emit) async {
      try {
        emit(CitizenshipLoadingState());
        Map<dynamic, dynamic> responseStatus =
            await CitizenshipServices.instance.add(
                profileId: event.profileId,
                token: event.token,
                countryId: event.coiuntryId,
                naturalBorn: event.naturalBorn);
        if (responseStatus['success']) {
          Country newCountry =
              Country.fromJson(responseStatus['data']['country']);
          Citizenship citizenship = Citizenship(
              country: newCountry,
              naturalBorn: responseStatus['data']['natural_born']);
          citizenships.add(citizenship);
          emit(CitizenshipAddedState(
              responseStatus: responseStatus, citizenships: citizenships));
        } else {
          emit(CitizenshipAddedState(
              responseStatus: responseStatus, citizenships: citizenships));
        }
      } catch (e) {
        emit(CitizenshipErrorState(message: e.toString()));
      }
    });

    on<EditCitizenship>((event, emit) async {
      try {
        emit(CitizenshipLoadingState());
        Map<dynamic, dynamic> responseStatus =
            await CitizenshipServices.instance.update(
                profileId: event.profileId,
                token: event.token,
                citizenship: event.citizenship,
                oldCountry: event.oldCountryId);
        if (responseStatus['success'] != null && responseStatus['success']) {
          citizenships.removeWhere((element) =>
              element.country!.id == event.citizenship.country!.id &&
              element.naturalBorn == event.citizenship.naturalBorn);
          Country newCountry =
              Country.fromJson(responseStatus['data']['country']);
          Citizenship citizenship = Citizenship(
              country: newCountry,
              naturalBorn: responseStatus['data']['natural_born']);
          citizenships.add(citizenship);
          emit(CitizenshipEditedState(
              responseStatus: responseStatus, citizenships: citizenships));
        } else {
          emit(CitizenshipEditedState(
              responseStatus: responseStatus, citizenships: citizenships));
        }
      } catch (e) {
        emit(CitizenshipErrorState(message: e.toString()));
      }
    });
    on<DeleteCitizenship>((event, emit) async {
      emit(CitizenshipLoadingState());
      try {
        final bool success = await CitizenshipServices.instance.delete(
            profileId: event.profileId,
            token: event.token,
            countryId: event.coiuntryId,
            naturalBorn: event.naturalBorn);
        if (success) {
          citizenships.removeWhere((element) =>
              element.country!.id == event.coiuntryId &&
              element.naturalBorn == event.naturalBorn);
          emit(CitizenshipDeleltedState(succcess: success));
        } else {
          emit(CitizenshipDeleltedState(succcess: success));
        }
      } catch (e) {
        emit(CitizenshipErrorState(message: e.toString()));
      }
    });
  }
}
