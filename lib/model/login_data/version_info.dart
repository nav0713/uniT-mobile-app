class VersionInfo {
  VersionInfo({
    this.id,
    this.versionInfo,
    this.dateReleased,
    this.development,
    this.production,
    this.downloadUrl,
    this.arm64v8aDownloadUrl,
    this.armeabiv7aDownloadUrl,
    this.x8664DownloadUrl,
  });

  String? id;
  String? versionInfo;
  DateTime? dateReleased;
  bool? development;
  bool? production;
  String? downloadUrl;
  String? arm64v8aDownloadUrl;
  String? armeabiv7aDownloadUrl;
  String? x8664DownloadUrl;

  factory VersionInfo.fromJson(Map<String, dynamic> json) => VersionInfo(
        id: json["id"],
        versionInfo: json["version_info"],
        dateReleased: DateTime.parse(json["date_released"]),
        development: json["development"],
        production: json["production"],
        downloadUrl: json["download_url"],
        arm64v8aDownloadUrl: json["arm64_v8a_download_url"],
        armeabiv7aDownloadUrl: json["armeabi_v7a_download_url"],
        x8664DownloadUrl: json["x86_64_down_download_url"],
      );

  Map<String, dynamic> toJson() => {
        "version": id,
        "version_info": versionInfo,
        "date_released":
            "${dateReleased!.year.toString().padLeft(4, '0')}-${dateReleased!.month.toString().padLeft(2, '0')}-${dateReleased!.day.toString().padLeft(2, '0')}",
        "development": development,
        "production": production,
        "download_url": downloadUrl,
        "arm64_v8a_download_url": arm64v8aDownloadUrl,
        "armeabi_v7a_download_url": armeabiv7aDownloadUrl,
        "x86_64_down_download_url": x8664DownloadUrl,
      };
}
