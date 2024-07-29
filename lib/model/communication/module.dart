import 'package:unit2/model/utils/agency.dart';

class Module {
    int? id;
    String? name;
    String? slug;
    String? platform;
    Module? service;
    Provider? provider;

    Module({
        required this.id,
        required this.name,
        required this.slug,
        this.platform,
        this.service,
        this.provider,
    });

    factory Module.fromJson(Map<String, dynamic> json) => Module(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        platform: json["platform"],
        service: json["service"] == null ? null : Module.fromJson(json["service"]),
        provider: json["provider"] == null ? null : Provider.fromJson(json["provider"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "platform": platform,
        "service": service?.toJson(),
        "provider": provider?.toJson(),
    };
}
class Provider {
    int? id;
    String? alias;
    Agency? agency;
    String? slug;

    Provider({
        required this.id,
        required this.alias,
        required this.agency,
        required this.slug,
    });

    factory Provider.fromJson(Map<String, dynamic> json) => Provider(
        id: json["id"],
        alias: json["alias"],
        agency: json["agency"] == null?null:Agency.fromJson(json["agency"]),
        slug: json["slug"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "alias": alias,
        "agency": agency?.toJson(),
        "slug": slug,
    };
}