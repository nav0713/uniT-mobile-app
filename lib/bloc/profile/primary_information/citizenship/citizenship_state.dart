part of 'citizenship_bloc.dart';

abstract class CitizenshipState extends Equatable {
  const CitizenshipState();
  
  @override
  List<Object> get props => [];
}

class CitizenshipInitial extends CitizenshipState {}

class CitizenshipLoaded extends CitizenshipState{
  final List<Citizenship> citizenships;
  final List<Country> countries;
  const CitizenshipLoaded({required this.citizenships,required this.countries});
}
class CitizenshipAddingState extends CitizenshipState{
  final List<Country> countries;
  const CitizenshipAddingState({required this.countries});
}
class CitizenshipLoadingState extends CitizenshipState{

}
class CitizenshipAddedState extends CitizenshipState{
  final Map<dynamic,dynamic> responseStatus;
  final List<Citizenship> citizenships;
  const CitizenshipAddedState({required this.responseStatus, required this.citizenships});

}

class CitizenshipEditedState extends CitizenshipState{
  final Map<dynamic,dynamic> responseStatus;
  final List<Citizenship> citizenships;
  const CitizenshipEditedState({required this.responseStatus, required this.citizenships});

}
class CitizenshipErrorState extends CitizenshipState{
  final String message;
  const CitizenshipErrorState({required this.message});
}

class CitizenshipDeleltedState extends CitizenshipState{
      final bool succcess;
      const CitizenshipDeleltedState({required this.succcess});
              @override
  List<Object> get props => [succcess];
}