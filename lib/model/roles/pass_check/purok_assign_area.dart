

import 'barangay_assign_area.dart';

class PassCheckPurok {
    final String? purokid;
    final String? purokdesc;
    final BaragayAssignArea? brgy;
    final dynamic purokLeader;
    final bool? writelock;
    final dynamic recordsignature;

    PassCheckPurok({
        required this.purokid,
        required this.purokdesc,
        required this.brgy,
        required this.purokLeader,
        required this.writelock,
        required this.recordsignature,
    });

    factory PassCheckPurok.fromJson(Map<String, dynamic> json) => PassCheckPurok(
        purokid: json["purokid"],
        purokdesc: json["purokdesc"],
        brgy: json["brgy"]==null?null:BaragayAssignArea.fromJson(json["brgy"]),
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



