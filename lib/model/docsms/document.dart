// To parse this JSON data, do
//
//     final document = documentFromJson(jsonString);

class Document {
    Document({
        required this.id,
        required this.sk,
        required this.dsk,
        required this.slug,
        required this.files,
        required this.title,
        required this.agency,
        required this.office,
        required this.subject,
        required this.fileType,
        required this.isPublic,
        required this.createdAt,
        required this.createdBy,
        required this.validatedAt,
        required this.validatedBy,
        required this.documentType,
        required this.documentRoutes,
        required this.alternateMobile,
        required this.attachedDocument,
        required this.enableNotification,
        required this.createdByPersonId,
    });

    final int? id;
    final String? sk;
    final String? dsk;
    final String? slug;
    final List<FileElement>? files;
    final String? title;
    final String? agency;
    final String? office;
    final String? subject;
    final FileType? fileType;
    final bool? isPublic;
    final String? createdAt;
    final String? createdBy;
    final String? validatedAt;
    final String? validatedBy;
    final DocumentType? documentType;
    final dynamic documentRoutes;
    final AlternateMobile? alternateMobile;
    final dynamic attachedDocument;
    final bool? enableNotification;
    final int? createdByPersonId;

    factory Document.fromJson(Map<String, dynamic> json) => Document(
        id: json["id"],
        sk: json["sk"],
        dsk: json["dsk"],
        slug: json["slug"],
        files: List<FileElement>.from(json["files"].map((x) => FileElement.fromJson(x))),
        title: json["title"],
        agency: json["agency"],
        office: json["office"],
        subject: json["subject"],
        fileType: FileType.fromJson(json["file_type"]),
        isPublic: json["is_public"],
        createdAt: json["created_at"],
        createdBy: json["created_by"],
        validatedAt: json["validated_at"],
        validatedBy: json["validated_by"],
        documentType: DocumentType.fromJson(json["document_type"]),
        documentRoutes: json["document_routes"],
        alternateMobile: AlternateMobile.fromJson(json["alternate_mobile"]),
        attachedDocument: json["attached_document"],
        enableNotification: json["enable_notification"],
        createdByPersonId: json["created_by_person_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "sk": sk,
        "dsk": dsk,
        "slug": slug,
        "files": List<dynamic>.from(files!.map((x) => x.toJson())),
        "title": title,
        "agency": agency,
        "office": office,
        "subject": subject,
        "file_type": fileType?.toJson(),
        "is_public": isPublic,
        "created_at": createdAt,
        "created_by": createdBy,
        "validated_at": validatedAt,
        "validated_by": validatedBy,
        "document_type": documentType?.toJson(),
        "document_routes": documentRoutes,
        "alternate_mobile": alternateMobile?.toJson(),
        "attached_document": attachedDocument,
        "enable_notification": enableNotification,
        "created_by_person_id": createdByPersonId,
    };
}

class AlternateMobile {
    AlternateMobile({
        required this.id,
        required this.mobileNo,
        required this.documentId,
    });

    final dynamic id;
    final dynamic mobileNo;
    final dynamic documentId;

    factory AlternateMobile.fromJson(Map<String, dynamic> json) => AlternateMobile(
        id: json["id"],
        mobileNo: json["mobile_no"],
        documentId: json["document_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "mobile_no": mobileNo,
        "document_id": documentId,
    };
}

class DocumentType {
    DocumentType({
        required this.id,
        required this.name,
        required this.slug,
        required this.categoryId,
        required this.priorityNumber,
    });

    final int id;
    final String name;
    final dynamic slug;
    final int categoryId;
    final dynamic priorityNumber;

    factory DocumentType.fromJson(Map<String, dynamic> json) => DocumentType(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        categoryId: json["category_id"],
        priorityNumber: json["priority_number"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "category_id": categoryId,
        "priority_number": priorityNumber,
    };
}

class FileType {
    FileType({
        required this.id,
        required this.name,
        required this.isActive,
        required this.extensions,
    });

    final int id;
    final String name;
    final bool isActive;
    final List<String> extensions;

    factory FileType.fromJson(Map<String, dynamic> json) => FileType(
        id: json["id"],
        name: json["name"],
        isActive: json["is_active"],
        extensions: List<String>.from(json["extensions"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "is_active": isActive,
        "extensions": List<dynamic>.from(extensions.map((x) => x)),
    };
}

class FileElement {
    FileElement({
        required this.path,
        required this.extnsn,
        required this.dateTime,
    });

    final String path;
    final String extnsn;
    final String dateTime;

    factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
        path: json["path"],
        extnsn: json["extnsn"],
        dateTime: json["date_time"],
    );

    Map<String, dynamic> toJson() => {
        "path": path,
        "extnsn": extnsn,
        "date_time": dateTime,
    };
}
