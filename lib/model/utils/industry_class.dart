class IndustryClass {
    IndustryClass({
        this.id,
        this.name,
        this.description,
    });

    final int? id;
    final String? name;
    final String? description;

    factory IndustryClass.fromJson(Map<String, dynamic> json) => IndustryClass(
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