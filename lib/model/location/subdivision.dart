class Subdivision {
    Subdivision({
        this.id,
        this.lotNo,
        this.blockNo,
    });

    final int? id;
    final int? lotNo;
    final int? blockNo;

    factory Subdivision.fromJson(Map<String, dynamic> json) => Subdivision(
        id: json["id"],
        lotNo: json["lot_no"],
        blockNo: json["block_no"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "lot_no": lotNo,
        "block_no": blockNo,
    };
}