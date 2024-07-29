part of 'agency_bloc.dart';

abstract class AgencyState extends Equatable {
  const AgencyState();

  @override
  List<Object> get props => [];
}

class AgenciesLoaded extends AgencyState {
  final List<Agency> agencies;
  final List<Category> agencyCategory;
  const AgenciesLoaded({required this.agencies, required this.agencyCategory});
}

class AgencyErrorState extends AgencyState {
  final String message;
  const AgencyErrorState({required this.message});
}

class AgencyLoadingState extends AgencyState {}

class AgencyAddesState extends AgencyState {
  final Map<dynamic, dynamic> response;
  const AgencyAddesState({required this.response});
}

class AgencyDeletedState extends AgencyState {
  final bool success;
  const AgencyDeletedState({required this.success});
}
class AgencyAddingErrorState extends AgencyState{
    final Agency agency;
    const AgencyAddingErrorState({required this.agency});
}

class AgencyInitial extends AgencyState {}
