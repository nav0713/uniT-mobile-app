import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:unit2/sevices/profile/volunatary_services.dart';
import 'package:unit2/utils/profile_utilities.dart';
import '../../../model/location/city.dart';
import '../../../model/location/country.dart';
import '../../../model/location/provinces.dart';
import '../../../model/location/region.dart';
import '../../../model/profile/voluntary_works.dart';
import '../../../model/utils/agency.dart';
import '../../../model/utils/category.dart';
import '../../../model/utils/position.dart';
import '../../../utils/location_utilities.dart';
part 'voluntary_work_event.dart';
part 'voluntary_work_state.dart';

class VoluntaryWorkBloc extends Bloc<VoluntaryWorkEvent, VoluntaryWorkState> {
  VoluntaryWorkBloc() : super(VoluntaryWorkInitial()) {
    List<VoluntaryWork> voluntaryWorks = [];
    List<Country> globalCountries = [];
    List<Category> agencyCategory = [];
    List<Region> globalRegions = [];
    List<PositionTitle> agencyPositions = [];
    List<Agency> agencies = [];
    List<Province> provinces = [];
    List<CityMunicipality> cities = [];
    ///// current
    PositionTitle currentPosition;
    Agency currentAgency;
    Region? currentRegion;
    Country currentCountry;
    Province? currentProvince;
    CityMunicipality? currentCity;
    ////Get Voluntary Works
    on<GetVoluntarWorks>((event, emit) async {
      emit(VoluntaryWorkLoadingState());
      try {
        if(voluntaryWorks.isEmpty){
        List<VoluntaryWork> works = await VoluntaryService.instance
            .getVoluntaryWorks(event.profileId, event.token);
        voluntaryWorks = works;
        }
        emit(VoluntaryWorkLoadedState(voluntaryWorks: voluntaryWorks));
      } catch (e) {
        emit(VoluntaryWorkErrorState(message: e.toString()));
      }
    });
    //// Load
    on<LoadVoluntaryWorks>((event, emit) {
      emit(VoluntaryWorkLoadedState(voluntaryWorks: voluntaryWorks));
    });
    //// Show Add form Event
    on<ShowAddVoluntaryWorks>((event, emit) async {
      try {
        emit(VoluntaryWorkLoadingState());
        //// POSITIONS
        if (agencyPositions.isEmpty) {
          List<PositionTitle> positions =
              await ProfileUtilities.instance.getAgencyPosition();
          agencyPositions = positions;
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

        emit(AddVoluntaryWorkState(
            agencies: agencies,
            positions: agencyPositions,
            agencyCategory: agencyCategory,
            regions: globalRegions,
            countries: globalCountries));
      } catch (e) {
        emit(ShowAddFormErrorState());
      }
    });
    on<ShowErrorState>((event, emit) {
      emit(VoluntaryWorkErrorState(message: event.message));
    });
    //// Add Voluntary Work
    on<AddVoluntaryWork>((event, emit) async {
       emit(VoluntaryWorkLoadingState());
      try {
        Map<dynamic, dynamic> status = await VoluntaryService.instance.add(
            voluntaryWork: event.work,
            profileId: event.profileId,
            token: event.token);
        if (status['success']) {
          VoluntaryWork work = VoluntaryWork.fromJson(status['data']);
          voluntaryWorks.add(work);
          emit(VoluntaryWorkAddedState(response: status));
        } else {
          emit(VoluntaryWorkAddedState(response: status));
        }
      } catch (e) {
        emit(VolunataryWorkHistoryAddingErrorState(work: event.work));
      }
    });
    ////Update
    on<UpdateVolunataryWork>((event, emit) async {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      try{
         emit(VoluntaryWorkLoadingState());
      Map<dynamic, dynamic> status = await VoluntaryService.instance.update(
          voluntaryWork: event.work,
          profileId: event.profileId,
          token: event.token,
          oldPosId: event.oldPosId,
          oldAgencyId: event.oldAgencyId,
          oldFromDate: formatter.format(DateTime.parse(event.oldFromDate)));
      if (status['success']) {
        VoluntaryWork work = VoluntaryWork.fromJson(status['data']);
        voluntaryWorks.removeWhere((VoluntaryWork element) =>
            element.position!.id == event.oldPosId &&
            element.agency!.id == event.oldAgencyId &&
            element.fromDate.toString() == event.oldFromDate.toString());
        voluntaryWorks.add(work);
        emit(VoluntaryWorkEditedState(response: status));
      } else {
        emit(VoluntaryWorkEditedState(response: status));
      }
      }catch(e){
        emit(VolunataryWorkHistoryUpdatingErrorState(oldAgencyId: event.oldAgencyId,oldFromDate: event.oldFromDate,oldPosId: event.oldPosId,work: event.work));
      }
    });
/////SHOW EDIT FORM
    on<ShowEditVoluntaryWorks>((event, emit) async {
      try {
           emit(VoluntaryWorkLoadingState());
        //// POSITIONS
        if (agencyPositions.isEmpty) {
          List<PositionTitle> positions =
              await ProfileUtilities.instance.getAgencyPosition();
          agencyPositions = positions;
        }
        currentPosition = event.work.position!;

        /////AGENCIES------------------------------------------
        if (agencies.isEmpty) {
          List<Agency> newAgencies =
              await ProfileUtilities.instance.getAgecies();
          agencies = newAgencies;
        }
        currentAgency = event.work.agency!;

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
       currentCountry = globalCountries.firstWhere((Country country) =>
            event.work.address!.country!.code == country.code);
        ////If overseas
        if (!event.isOverseas) {
          //// if not overseas
          currentRegion = globalRegions.firstWhere((Region region) =>
              event.work.address!.cityMunicipality!.province!.region!.code ==
              region.code);
          provinces = await LocationUtils.instance
              .getProvinces(selectedRegion: currentRegion!);
          currentProvince = provinces.firstWhere((Province province) =>
              event.work.address!.cityMunicipality!.province!.code ==
              province.code);

          cities = await LocationUtils.instance
              .getCities(selectedProvince: currentProvince!);
              
          currentCity = cities.firstWhere((CityMunicipality cityMunicipality) =>
              event.work.address!.cityMunicipality!.code ==
              cityMunicipality.code);
        }
        emit(EditVoluntaryWorks(
            overseas: event.isOverseas,
            agencies: agencies,
            agencyCategory: agencyCategory,
            cities: cities,
            countries: globalCountries,
            positions: agencyPositions,
            provinces: provinces,
            regions: globalRegions,
            work: event.work,
            currentAgency: currentAgency,
            currentCity: currentCity,
            currentCountry: currentCountry,
            currentPosition: currentPosition,
            currentProvince: currentProvince,
            currentRegion: currentRegion));
      } catch (e) {
        emit(ShowEditFormErrorState(isOverseas: event.isOverseas,work: event.work));
      }
    });
    //// Delete
    on<DeleteVoluntaryWork>((event, emit) async {
      try {
                 emit(VoluntaryWorkLoadingState());
        final DateFormat formatter = DateFormat('yyyy-MM-dd');

        final bool success = await VoluntaryService.instance.delete(
            agencyId: event.work.agency!.id!,
            positionId: event.work.position!.id!,
            fromDate: formatter.format(event.work.fromDate!),
            token: event.token,
            profileId: event.profileId);
        if (success) {
          voluntaryWorks.removeWhere((VoluntaryWork element) =>
              element.position!.id == event.work.position!.id &&
              element.agency!.id == event.work.agency!.id &&
              element.fromDate == event.work.fromDate);
          emit(VoluntaryWorkDeletedState(success: success));
        } else {
          emit(VoluntaryWorkDeletedState(success: success));
        }
      } catch (e) {
        emit(VoluntaryWorkHistoryDeletingErrorState(work: event.work));
      }
    });
  }
}
