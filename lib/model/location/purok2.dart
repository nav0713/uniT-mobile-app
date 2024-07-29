

import 'package:unit2/model/location/barangay2.dart';

class Purok2 {
    final String purokid;
    final String purokdesc;
    final Barangay2? brgy;
    final dynamic purokLeader;
    final bool writelock;
    final dynamic recordsignature;

    Purok2({
        required this.purokid,
        required this.purokdesc,
        required this.brgy,
        required this.purokLeader,
        required this.writelock,
        required this.recordsignature,
    });

    factory Purok2.fromJson(Map<String, dynamic> json) => Purok2(
        purokid: json["purokid"],
        purokdesc: json["purokdesc"],
        brgy: json['brgy'] == null?null: Barangay2.fromJson(json["brgy"]),
        purokLeader: json["purok_leader"],
        writelock: json["writelock"],
        recordsignature: json["recordsignature"],
    );

    Map<String, dynamic> toJson() => {
        "purokid": purokid,
        "purokdesc": purokdesc,
        "brgy": brgy?.toJson(),
        "purok_leader": purokLeader,
        "writelock": writelock,
        "recordsignature": recordsignature,
    };
}
