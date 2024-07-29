part of 'organization_membership_bloc.dart';

abstract class OrganizationMembershipEvent extends Equatable {
  const OrganizationMembershipEvent();

  @override
  List<Object> get props => [];
}

class LoadOrganizationMemberships extends OrganizationMembershipEvent{

  @override
  List<Object> get props => [];
}

class GetOrganizationMembership extends OrganizationMembershipEvent{
  final int? profileId;
  final String? token;
  const GetOrganizationMembership({this.profileId,  this.token});

}
class ShowAddOrgMembershipForm extends OrganizationMembershipEvent{
  
}
class AddOrgMembership extends OrganizationMembershipEvent{
  final int profileId;
  final String token;
  final Agency agency;
  const AddOrgMembership({required this.agency, required this.profileId, required this.token});
    @override
  List<Object> get props => [profileId,token,agency];
}

class DeleteOrgMemberShip extends OrganizationMembershipEvent{
  final int profileId;
  final String token;
  final OrganizationMembership org;

  const DeleteOrgMemberShip({required this.profileId, required this.token, required this.org,});
  @override
  List<Object> get props => [profileId,token,org];

}
