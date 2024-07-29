class PositionTitle {
    PositionTitle({
        this.id,
        this.title,
    });

    final int? id;
    final String? title;

    factory PositionTitle.fromJson(Map<String, dynamic> json) => PositionTitle(
        id: json["id"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
    };
}