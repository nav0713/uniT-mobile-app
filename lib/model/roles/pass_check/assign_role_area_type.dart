// To parse this JSON data, do
//
//     final assignRoleAreaType = assignRoleAreaTypeFromJson(jsonString);


class AssignRoleAreaType {
    final String areaTypeName;
    final Details details;

    AssignRoleAreaType({
        required this.areaTypeName,
        required this.details,
    });

    factory AssignRoleAreaType.fromJson(Map<String, dynamic> json) => AssignRoleAreaType(
        areaTypeName: json["area_type_name"],
        details: Details.fromJson(json["details"]),
    );

    Map<String, dynamic> toJson() => {
        "area_type_name": areaTypeName,
        "details": details.toJson(),
    };
}

class Details {
    final String? table;
    final String? schema;
    final String? dataType;
    final String? idColumn;

    Details({
        required this.table,
        required this.schema,
        required this.dataType,
        required this.idColumn,
    });

    factory Details.fromJson(Map<String, dynamic> json) => Details(
        table: json["table"],
        schema: json["schema"],
        dataType: json["data_type"],
        idColumn: json["id_column"],
    );

    Map<String, dynamic> toJson() => {
        "table": table,
        "schema": schema,
        "data_type": dataType,
        "id_column": idColumn,
    };
}
