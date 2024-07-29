class PositionClass {
  PositionClass({
    this.level,
    this.classid,
    this.groupcode,
    this.salarygrade,
    this.classSuffix,
    this.classTitleid,
    this.qualificationid,
    this.competencyModelId,
  });

  int? level;
  String? classid;
  String? groupcode;
  int? salarygrade;
  String? classSuffix;
  PositionSpecificrole? classTitleid;
  int? qualificationid;
  int? competencyModelId;

  factory PositionClass.fromJson(Map<String, dynamic> json) => PositionClass(
        level: json["level"],
        classid: json["classid"],
        groupcode: json["groupcode"],
        salarygrade: json["salarygrade"],
        classSuffix: json["class_suffix"],
        classTitleid:json["class_titleid"]==null?null: PositionSpecificrole.fromJson(json["class_titleid"]),
        qualificationid: json["qualificationid"],
        competencyModelId: json["competency_model_id"],
      );

  Map<String, dynamic> toJson() => {
        "level": level,
        "classid": classid,
        "groupcode": groupcode,
        "salarygrade": salarygrade,
        "class_suffix": classSuffix,
        "class_titleid": classTitleid!.toJson(),
        "qualificationid": qualificationid,
        "competency_model_id": competencyModelId,
      };
}


class PositionSpecificrole {
  PositionSpecificrole({
    this.title,
    this.titleid,
  });

  String? title;
  int? titleid;

  factory PositionSpecificrole.fromJson(Map<String, dynamic> json) =>
      PositionSpecificrole(
        title: json["title"],
        titleid: json["titleid"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "titleid": titleid,
      };
}