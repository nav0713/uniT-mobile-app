part of 'agency_bloc.dart';

abstract class AgencyEvent extends Equatable {
  const AgencyEvent();

  @override
  List<Object> get props => [];
}

class GetAgencies extends AgencyEvent{

}
class AddAgency extends AgencyEvent{
  final Agency agency;
  const AddAgency({required this.agency});
    List<Object> get props => [agency
    ];
}

class GetEstPointPersonAgencies extends AgencyEvent{
  final List<AssignedArea>? assignedAreas;
  const GetEstPointPersonAgencies({required this.assignedAreas});
  
}
