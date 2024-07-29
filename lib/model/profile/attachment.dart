
import 'dart:convert';

Attachment attachmentFromJson(String str) =>
    Attachment.fromJson(json.decode(str));

String attachmentToJson(Attachment data) => json.encode(data.toJson());

class Attachment {
  final int? id;
  final String? source;
  final AttachmentCategory? category;
  final String? filename;
  final Subclass? subclass;
  final DateTime? createdAt;

  Attachment({
    required this.id,
    required this.source,
    required this.category,
    required this.filename,
    required this.subclass,
    required this.createdAt,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        id: json["id"],
        source: json["source"],
        category: json['category'] == null
            ? null
            : AttachmentCategory.fromJson(json["category"]),
        filename: json["filename"],
        subclass: json['subclass'] == null
            ? null
            : Subclass.fromJson(json["subclass"]),
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "source": source,
        "category": category?.toJson(),
        "filename": filename,
        "subclass": subclass?.toJson(),
        "created_at": createdAt?.toIso8601String(),
      };
}

class AttachmentCategory {
  final int? id;
  final Subclass? subclass;
  final String? description;

  AttachmentCategory({
    required this.id,
    required this.subclass,
    required this.description,
  });

  factory AttachmentCategory.fromJson(Map<String, dynamic> json) => AttachmentCategory(
        id: json["id"],
        subclass:json['subclass'] == null? null: Subclass.fromJson(json["subclass"]),
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subclass": subclass?.toJson(),
        "description": description,
      };
}

class Subclass {
  final int? id;
  final String? name;
  final AttachmentClass? attachmentClass;

  Subclass({
    required this.id,
    required this.name,
    required this.attachmentClass,
  });

  factory Subclass.fromJson(Map<String, dynamic> json) => Subclass(
        id: json["id"],
        name: json["name"],
        attachmentClass: json['attachment_class'] == null? null: AttachmentClass.fromJson(json["attachment_class"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "attachment_class": attachmentClass?.toJson(),
      };
}

class AttachmentClass {
  final int? id;
  final String? name;

  AttachmentClass({
    required this.id,
    required this.name,
  });

  factory AttachmentClass.fromJson(Map<String, dynamic> json) =>
      AttachmentClass(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
