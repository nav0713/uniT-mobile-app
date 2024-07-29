part of 'organization_membership_bloc.dart';

abstract class OrganizationMembershipState extends Equatable {
  const OrganizationMembershipState();

  @override
  List<Object> get props => [];
}

class OrganizationMembershipInitial extends OrganizationMembershipState {}

class OrganizationMembershipLoaded extends OrganizationMembershipState {
  final List<OrganizationMembership> orgMemberships;
  final List<Agency> agencies;
  final List<Category> agencyCategory;
  const OrganizationMembershipLoaded(
      {required this.orgMemberships,
      required this.agencies,
      required this.agencyCategory});
  @override
  List<Object> get props => [orgMemberships];
}

class OrganizationMembershipErrorState extends OrganizationMembershipState {
  final String message;
  const OrganizationMembershipErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class OrgmembershipLoadingState extends OrganizationMembershipState {}

class OrgMembershipDeletedState extends OrganizationMembershipState {
  final bool success;
  const OrgMembershipDeletedState({required this.success});
  @override
  List<Object> get props => [success];
}

class OrgMembershipAddedState extends OrganizationMembershipState {
  final Map<dynamic, dynamic> response;
  const OrgMembershipAddedState({required this.response});
  @override
  List<Object> get props => [response];
}

class AddOrgMembershipState extends OrganizationMembershipState {
  final List<Agency> agencies;
  final List<Category> agencyCategories;
  const AddOrgMembershipState(
      {required this.agencies, required this.agencyCategories});
}

class AddOrgMembershipError extends OrganizationMembershipState{
    final Agency agency;

  const AddOrgMembershipError({ required this.agency});
  
}

class DeleteOrgMemberShipError extends OrganizationMembershipState{
    final OrganizationMembership org;

  const DeleteOrgMemberShipError({required this.org});

}
