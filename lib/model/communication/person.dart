class Person {
    int? personid;
    String? familyname;
    String? givenname;
    String? middlename;
    String? extension;

    Person({
        required this.personid,
        required this.familyname,
        required this.givenname,
        required this.middlename,
        required this.extension,
    });

    factory Person.fromJson(Map<String, dynamic> json) => Person(
        personid: json["personid"],
        familyname: json["familyname"],
        givenname: json["givenname"],
        middlename: json["middlename"],
        extension: json["extension"],
    );

    Map<String, dynamic> toJson() => {
        "personid": personid,
        "familyname": familyname,
        "givenname": givenname,
        "middlename": middlename,
        "extension": extension,
    };
}