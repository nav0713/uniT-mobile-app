part of 'assign_area_agency_bloc.dart';

abstract class AssignAreaAgencyState extends Equatable {
  const AssignAreaAgencyState();
  
  @override
  List<Object> get props => [];

  get message => null;
}

class AssignAreaAgencyInitial extends AssignAreaAgencyState {}
class EstPointPersonAgenciesLoaded extends AssignAreaAgencyState {
  final List<AssignedArea>? agencies;
  final List<Category> agencyCategory;
  const EstPointPersonAgenciesLoaded({required this.agencies, required this.agencyCategory});
}

class EstPointAgencyErrorState extends AssignAreaAgencyState {
  final String message;
  const EstPointAgencyErrorState({required this.message});
}

class EstPointPersonAgencyLoadingState extends AssignAreaAgencyState {}

class EstPointPersonAgencyAddesState extends AssignAreaAgencyState {
  final Map<dynamic, dynamic> response;
  const EstPointPersonAgencyAddesState({required this.response});
}

class EstPointPersonAgencyDeletedState extends AssignAreaAgencyState {
  final bool success;
  const EstPointPersonAgencyDeletedState({required this.success});
}
