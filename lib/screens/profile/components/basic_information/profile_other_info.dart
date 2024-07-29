

class ProfileOtherInfo {
    final int? id;
    final String? name;
    final String? description;

    ProfileOtherInfo({
        required this.id,
        required this.name,
        required this.description,
    });

    factory ProfileOtherInfo.fromJson(Map<String, dynamic> json) => ProfileOtherInfo(
        id: json["id"],
        name: json["name"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
    };
}
