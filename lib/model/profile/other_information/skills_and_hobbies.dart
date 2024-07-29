// To parse this JSON data, do
//
//     final skillsHobbies = skillsHobbiesFromJson(jsonString);

import 'dart:convert';

SkillsHobbies skillsHobbiesFromJson(String str) => SkillsHobbies.fromJson(json.decode(str));

String skillsHobbiesToJson(SkillsHobbies data) => json.encode(data.toJson());

class SkillsHobbies {
    SkillsHobbies({
        this.id,
        this.name,
    });

    final int? id;
    final String? name;

    factory SkillsHobbies.fromJson(Map<String, dynamic> json) => SkillsHobbies(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
