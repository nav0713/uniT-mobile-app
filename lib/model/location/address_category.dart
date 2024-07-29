class AddressCategory {
    AddressCategory({
        required this.id,
        required this.name,
        required this.type,
    });

    final int? id;
    final String? name;
    final String? type;

    factory AddressCategory.fromJson(Map<String, dynamic> json) => AddressCategory(
        id: json["id"],
        name: json["name"],
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
    };
}