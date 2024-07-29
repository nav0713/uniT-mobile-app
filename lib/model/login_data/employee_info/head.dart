
class Head {
  Head({
    this.id,
    this.title,
    this.classid,
    this.fullName,
    this.personId,
    this.employeeid,
    this.officeposid,
    this.lastFullName,
  });

  int? id;
  String? title;
  String? classid;
  String? fullName;
  int? personId;
  String? employeeid;
  int? officeposid;
  String? lastFullName;

  factory Head.fromJson(Map<String, dynamic> json) => Head(
        id: json["id"],
        title: json["title"],
        classid: json["classid"],
        fullName: json["full_name"],
        personId: json["person_id"],
        employeeid: json["employeeid"],
        officeposid: json["officeposid"],
        lastFullName: json["last_full_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "classid": classid,
        "full_name": fullName,
        "person_id": personId,
        "employeeid": employeeid,
        "officeposid": officeposid,
        "last_full_name": lastFullName,
      };
}