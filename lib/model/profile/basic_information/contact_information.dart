// To parse this JSON data, do
//
//     final contactInformation = contactInformationFromJson(jsonString);


import '../../utils/agency.dart';

class ContactInfo {
    ContactInfo({
        required this.id,
        required this.active,
        required this.primary,
        required this.numbermail,
        required this.commService,
    });

    int? id;
    bool? active;
    bool? primary;
    String? numbermail;
    CommService? commService;

    factory ContactInfo.fromJson(Map<String, dynamic> json) => ContactInfo(
        id: json["id"],
        active: json["active"],
        primary: json["primary"],
        numbermail: json["numbermail"],
        commService: json["comm_service"]==null?null: CommService.fromJson(json["comm_service"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "active": active,
        "primary": primary,
        "numbermail": numbermail,
        "comm_service": commService!.toJson(),
    };
}

class CommService {
    CommService({
        required this.id,
        required this.serviceType,
        required this.serviceProvider,
    });

    int? id;
    ServiceType? serviceType;
    ServiceProvider? serviceProvider;

    factory CommService.fromJson(Map<String, dynamic> json) => CommService(
        id: json["id"],
        serviceType: json["service_type"]==null?null: ServiceType.fromJson(json["service_type"]),
        serviceProvider: json["service_provider"] == null?null: ServiceProvider.fromJson(json["service_provider"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "service_type": serviceType!.toJson(),
        "service_provider": serviceProvider!.toJson(),
    };
}

class ServiceProvider {
    ServiceProvider({
        required this.id,
        required this.alias,
        required this.agency,
    });

    int? id;
    String? alias;
    Agency? agency;

    factory ServiceProvider.fromJson(Map<String, dynamic> json) => ServiceProvider(
        id: json["id"],
        alias: json["alias"],
        agency: json["agency"] == null? null: Agency.fromJson(json["agency"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "alias": alias,
        "agency": agency!.toJson(),
    };
}


class ServiceType {
    ServiceType({
        required this.id,
        required this.name,
    });

    int? id;
    String? name;

    factory ServiceType.fromJson(Map<String, dynamic> json) => ServiceType(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
