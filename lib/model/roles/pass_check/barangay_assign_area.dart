
class BaragayAssignArea {
    final String? brgycode;
    final String? brgydesc;
    final String? citymuncode;

    BaragayAssignArea({
        required this.brgycode,
        required this.brgydesc,
        required this.citymuncode,
    });

    factory BaragayAssignArea.fromJson(Map<String, dynamic> json) => BaragayAssignArea(
        brgycode: json["brgycode"],
        brgydesc: json["brgydesc"],
        citymuncode: json["citymuncode"],
    );

    Map<String, dynamic> toJson() => {
        "brgycode": brgycode,
        "brgydesc": brgydesc,
        "citymuncode": citymuncode,
    };
}
