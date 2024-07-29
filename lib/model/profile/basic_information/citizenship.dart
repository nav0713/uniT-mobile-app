
import '../../location/country.dart';

class Citizenship {
    Citizenship({
        required this.country,
        required this.naturalBorn,
    });

    final Country? country;
    final bool? naturalBorn;

    factory Citizenship.fromJson(Map<String, dynamic> json) => Citizenship(
        country: Country.fromJson(json["country"]),
        naturalBorn: json["natural_born"],
    );

    Map<String, dynamic> toJson() => {
        "country": country!.toJson(),
        "natural_born": naturalBorn,
    };
}
