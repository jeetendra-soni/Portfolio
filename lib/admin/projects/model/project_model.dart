import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jeetendra_portfolio/constants/enums.dart';


class ProjectModel {
  final String id;

  /// Basic Info
  final String title;
  final String? tagline; // (Live on Apple & Play Store)
  final String description; // marketing description
  final String contribution; // your role description

  /// Media
  final String icon; // big top image (base64 or url)
  final String bannerImage; // big top image (base64 or url)
  final List<String> galleryImages; // screenshots

  /// Links
  final String githubUrl;
  final String liveUrl;
  final String playStoreUrl;
  final String appStoreUrl;

  /// QR Codes (optional)
  final String playStoreQr;
  final String appStoreQr;

  /// Features
  final List<String> features;
  final List<String> technologies;

  /// Metadata
  final ProjectStatus status;
  final bool featured;

  final DateTime createdAt;
  final DateTime? updatedAt;

  const ProjectModel({
    required this.id,
    required this.title,
    required this.tagline,
    required this.description,
    required this.contribution,
    required this.icon,
    required this.bannerImage,
    required this.galleryImages,
    required this.githubUrl,
    required this.liveUrl,
    required this.playStoreUrl,
    required this.appStoreUrl,
    required this.playStoreQr,
    required this.appStoreQr,
    required this.features,
    required this.technologies,
    required this.status,
    required this.featured,
    required this.createdAt,
    this.updatedAt,
  });

  /// ---------------- COPY WITH ----------------
  ProjectModel copyWith({
    String? id,
    String? title,
    String? shortTagline,
    String? tagline,
    String? description,
    String? contribution,
    String? icon,
    String? bannerImage,
    List<String>? galleryImages,
    String? githubUrl,
    String? liveUrl,
    String? playStoreUrl,
    String? appStoreUrl,
    String? playStoreQr,
    String? appStoreQr,
    List<String>? features,
    List<String>? technologies,
    ProjectStatus? status,
    bool? featured,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      title: title ?? this.title,
      tagline: tagline ?? this.tagline,
      description: description ?? this.description,
      contribution: contribution ?? this.contribution,
      icon: icon ?? this.icon,
      bannerImage: bannerImage ?? this.bannerImage,
      galleryImages: galleryImages ?? this.galleryImages,
      githubUrl: githubUrl ?? this.githubUrl,
      liveUrl: liveUrl ?? this.liveUrl,
      playStoreUrl: playStoreUrl ?? this.playStoreUrl,
      appStoreUrl: appStoreUrl ?? this.appStoreUrl,
      playStoreQr: playStoreQr ?? this.playStoreQr,
      appStoreQr: appStoreQr ?? this.appStoreQr,
      features: features ?? this.features,
      technologies: technologies ?? this.technologies,
      status: status ?? this.status,
      featured: featured ?? this.featured,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// ---------------- TO MAP ----------------
  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "tagline": tagline,
      "description": description,
      "contribution": contribution,
      "bannerImage": bannerImage,
      "icon": icon,
      "galleryImages": galleryImages,
      "githubUrl": githubUrl,
      "liveUrl": liveUrl,
      "playStoreUrl": playStoreUrl,
      "appStoreUrl": appStoreUrl,
      "playStoreQr": playStoreQr,
      "appStoreQr": appStoreQr,
      "features": features,
      "technologies": technologies,
      "status": status.name,
      "featured": featured,
      "createdAt": Timestamp.fromDate(createdAt),
      "updatedAt":
      updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  /// ---------------- FROM MAP ----------------
  factory ProjectModel.fromMap(
      Map<String, dynamic> map, String docId) {
    return ProjectModel(
      id: docId,
      title: map["title"] ?? '',
      tagline: map["tagline"] ?? '',
      description: map["description"] ?? '',
      contribution: map["contribution"] ?? '',
      icon: map["icon"] ?? '',
      bannerImage: map["bannerImage"] ?? '',
      galleryImages:
      List<String>.from(map["galleryImages"] ?? []),
      githubUrl: map["githubUrl"] ?? '',
      liveUrl: map["liveUrl"] ?? '',
      playStoreUrl: map["playStoreUrl"] ?? '',
      appStoreUrl: map["appStoreUrl"] ?? '',
      playStoreQr: map["playStoreQr"] ?? '',
      appStoreQr: map["appStoreQr"] ?? '',
      features: List<String>.from(map["features"] ?? []),
      technologies:
      List<String>.from(map["technologies"] ?? []),
      status: ProjectStatus.values.firstWhere(
            (e) => e.name == map["status"],
        orElse: () => ProjectStatus.inProgress,
      ),
      featured: map["featured"] ?? false,
      createdAt:
      (map["createdAt"] as Timestamp).toDate(),
      updatedAt: map["updatedAt"] != null
          ? (map["updatedAt"] as Timestamp).toDate()
          : null,
    );
  }
}
