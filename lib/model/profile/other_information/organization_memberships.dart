// To parse this JSON data, do
//
//     final organizationMembership = organizationMembershipFromJson(jsonString);

import 'dart:convert';

import '../../utils/agency.dart';

OrganizationMembership organizationMembershipFromJson(String str) => OrganizationMembership.fromJson(json.decode(str));

String organizationMembershipToJson(OrganizationMembership data) => json.encode(data.toJson());

class OrganizationMembership {
    OrganizationMembership({
        this.agency,
    });

    final Agency? agency;

    factory OrganizationMembership.fromJson(Map<String, dynamic> json) => OrganizationMembership(
        agency: json["agency"] == null ? null : Agency.fromJson(json["agency"]),
    );

    Map<String, dynamic> toJson() => {
        "agency": agency?.toJson(),
    };
}


