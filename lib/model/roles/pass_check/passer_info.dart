
class PasserInfo {
    final int personid;
    final String familyname;
    final String givenname;
    final String? middlename;
    final String sex;
    final DateTime? birthdate;
    final String? extension;
    final String? civilstatus;
    final double? heightM;
    final double weightKg;
    final String? bloodtype;
    final String? photoPath;
    final String? uuid;
    final String? encryptionKey;
    final bool? deceased;
    final dynamic encryptedProfile;
    final String? addedby;
    final DateTime? addedat;
    final String? updateby;
    final DateTime? updatedat;
    final String? deletedby;
    final DateTime? deletedat;
    final String? encryptSignature;
    final String? esigPath;
    final String? titlePrefix;
    final String? titleSuffix;
    final bool? showTitleId;

    PasserInfo({
        required this.personid,
        required this.familyname,
        required this.givenname,
        required this.middlename,
        required this.sex,
        required this.birthdate,
        required this.extension,
        required this.civilstatus,
        required this.heightM,
        required this.weightKg,
        required this.bloodtype,
        required this.photoPath,
        required this.uuid,
        required this.encryptionKey,
        required this.deceased,
        required this.encryptedProfile,
        required this.addedby,
        required this.addedat,
        required this.updateby,
        required this.updatedat,
        required this.deletedby,
        required this.deletedat,
        required this.encryptSignature,
        required this.esigPath,
        required this.titlePrefix,
        required this.titleSuffix,
        required this.showTitleId,
    });

    factory PasserInfo.fromJson(Map<String, dynamic> json) => PasserInfo(
        personid: json["personid"],
        familyname: json["familyname"],
        givenname: json["givenname"],
        middlename: json["middlename"],
        sex: json["sex"],
        birthdate: json['birthdate'] == null?null: DateTime.parse(json["birthdate"]),
        extension: json["extension"],
        civilstatus: json["civilstatus"],
        heightM: json["height_m"]?.toDouble(),
        weightKg: json["weight_kg"]?.toDouble(),
        bloodtype: json["bloodtype"],
        photoPath: json["photo_path"],
        uuid: json["uuid"],
        encryptionKey: json["encryption_key"],
        deceased: json["deceased"],
        encryptedProfile: json["encrypted_profile"],
        addedby: json["addedby"],
        addedat: json["addedat"] == null? null:DateTime.tryParse(json["addedat"]),
        updateby:json["updateby"],
        updatedat:json["updatedat"]==null?null: DateTime.tryParse(json["updatedat"]),
        deletedby: json["deletedby"],
       deletedat: json['deletedat'] == null?null:DateTime.tryParse(json["deletedat"]),
        encryptSignature: json["encrypt_signature"],
        esigPath: json["esig_path"],
        titlePrefix: json["title_prefix"],
        titleSuffix: json["title_suffix"],
        showTitleId: json["show_title_id"],
    );

    Map<String, dynamic> toJson() => {
        "personid": personid,
        "familyname": familyname,
        "givenname": givenname,
        "middlename": middlename,
        "sex": sex,
        "birthdate": "${birthdate?.year.toString().padLeft(4, '0')}-${birthdate?.month.toString().padLeft(2, '0')}-${birthdate?.day.toString().padLeft(2, '0')}",
        "extension": extension,
        "civilstatus": civilstatus,
        "height_m": heightM,
        "weight_kg": weightKg,
        "bloodtype": bloodtype,
        "photo_path": photoPath,
        "uuid": uuid,
        "encryption_key": encryptionKey,
        "deceased": deceased,
        "encrypted_profile": encryptedProfile,
        "addedby": addedby,
        "addedat": addedat?.toIso8601String(),
        "updateby": updateby,
        "updatedat": updatedat?.toIso8601String(),
        "deletedby": deletedby,
        "deletedat": deletedat,
        "encrypt_signature": encryptSignature,
        "esig_path": esigPath,
        "title_prefix": titlePrefix,
        "title_suffix": titleSuffix,
        "show_title_id": showTitleId,
    };
}
