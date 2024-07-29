part of 'assign_area_agency_bloc.dart';

abstract class AssignAreaAgencyEvent extends Equatable {
  const AssignAreaAgencyEvent();

  @override
  List<Object> get props => [];
}

class EstPointPersonGetAgencies extends AssignAreaAgencyEvent {
  final List<AssignedArea>? assignedAreas;
  const EstPointPersonGetAgencies({required this.assignedAreas});
}

class EstPointPersonAddAgency extends AssignAreaAgencyEvent {
  final Agency agency;
  const EstPointPersonAddAgency({required this.agency});
}
