import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unit2/model/utils/agency.dart';
import 'package:unit2/model/utils/category.dart';
import 'package:unit2/sevices/profile/orgmembership_services.dart';
import 'package:unit2/utils/profile_utilities.dart';

import '../../../../model/profile/other_information/organization_memberships.dart';

part 'organization_membership_event.dart';
part 'organization_membership_state.dart';

class OrganizationMembershipBloc
    extends Bloc<OrganizationMembershipEvent, OrganizationMembershipState> {
  List<Agency> agencies = [];
  List<Category> agencyCategory = [];
  OrganizationMembershipBloc() : super(OrganizationMembershipInitial()) {
    List<OrganizationMembership> organizationMemberships = [];
    on<GetOrganizationMembership>((event, emit) async {
      emit(OrgmembershipLoadingState());
      try {
        if (organizationMemberships.isEmpty) {
          List<OrganizationMembership> orgs =
              await OrganizationMembershipServices.instance
                  .getOrgMemberships(event.profileId!, event.token!);
          organizationMemberships = orgs;
        }
        if (agencyCategory.isEmpty) {
          List<Category> newAgencyCategories =
              await ProfileUtilities.instance.agencyCategory();
          agencyCategory = newAgencyCategories;
        }
        emit(OrganizationMembershipLoaded(
            orgMemberships: organizationMemberships,
            agencies: agencies,
            agencyCategory: agencyCategory));
      } catch (e) {
        emit(OrganizationMembershipErrorState(message: e.toString()));
      }
    });
    on<LoadOrganizationMemberships>((event, emit) {
      emit(OrganizationMembershipLoaded(
          orgMemberships: organizationMemberships,
          agencies: agencies,
          agencyCategory: agencyCategory));
    });
    //// ADD ORGMEMBERSHIP
    on<AddOrgMembership>((event, emit) async {
      try {
        emit(OrgmembershipLoadingState());
        Map<dynamic, dynamic> status =
            await OrganizationMembershipServices.instance.add(
                agency: event.agency,
                token: event.token,
                profileId: event.profileId.toString());
        if (status["success"]) {
          OrganizationMembership organizationMembership =
              OrganizationMembership.fromJson(status["data"]);
          organizationMemberships.add(organizationMembership);
          emit(OrgMembershipAddedState(response: status));
        } else {
          emit(OrgMembershipAddedState(response: status));
        }
      } catch (e) {
        emit(AddOrgMembershipError(agency: event.agency));
      }
    });
    ////DELETE ORGMEMBERSHIP
    on<DeleteOrgMemberShip>((event, emit) async {
      emit(OrgmembershipLoadingState());
      try {
        final bool success = await OrganizationMembershipServices.instance
            .delete(
                agency: event.org.agency!,
                profileId: event.profileId,
                token: event.token);
        if (success) {
          organizationMemberships.removeWhere(
              (element) => element.agency!.id == event.org.agency!.id);
          emit(OrgMembershipDeletedState(success: success));
        } else {
          emit(OrgMembershipDeletedState(success: success));
        }
      } catch (e) {
        emit(DeleteOrgMemberShipError(org: event.org));
      }
    });
  }
}
