
import 'package:cloud_firestore/cloud_firestore.dart';

class AwardModel {
  final String id;
  final String title;
  final String organization;
  final String description;
  final DateTime date;
  final String? certificateUrl;
  final String? iconUrl;
  final bool isActive;
  final bool isFeatured;
  final int order;

  AwardModel({
    required this.id,
    required this.title,
    required this.organization,
    required this.description,
    required this.date,
    this.certificateUrl,
    this.iconUrl,
    required this.isActive,
    required this.isFeatured,
    required this.order,
  });

  factory AwardModel.fromMap(Map<String, dynamic> map, String id) {
    return AwardModel(
      id: id,
      title: map['title'] ?? '',
      organization: map['organization'] ?? '',
      description: map['description'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      certificateUrl: map['certificateUrl'],
      iconUrl: map['iconUrl'],
      isActive: map['isActive'] ?? true,
      isFeatured: map['isFeatured'] ?? false,
      order: map['order'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "organization": organization,
      "description": description,
      "date": date,
      "certificateUrl": certificateUrl,
      "iconUrl": iconUrl,
      "isActive": isActive,
      "isFeatured": isFeatured,
      "order": order,
      "createdAt": FieldValue.serverTimestamp(),
    };
  }
}