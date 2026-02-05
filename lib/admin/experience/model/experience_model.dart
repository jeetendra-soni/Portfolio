import 'package:cloud_firestore/cloud_firestore.dart';

class ExperienceModel {
  final String id;
  final String role;
  final String company;
  final String employmentType;
  final String location;
  final DateTime startDate;
  final DateTime? endDate;
  final bool currentlyWorking;
  final String description;
  final int order;

  ExperienceModel({
    required this.id,
    required this.role,
    required this.company,
    required this.employmentType,
    required this.location,
    required this.startDate,
    this.endDate,
    required this.currentlyWorking,
    required this.description,
    required this.order,
  });

  factory ExperienceModel.fromDoc(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();

    return ExperienceModel(
      id: doc.id,
      role: data['role'],
      company: data['company'],
      employmentType: data['employmentType'],
      location: data['location'],
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate:
      data['endDate'] != null ? (data['endDate'] as Timestamp).toDate() : null,
      currentlyWorking: data['currentlyWorking'],
      description: data['description'],
      order: data['order'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "role": role,
      "company": company,
      "employmentType": employmentType,
      "location": location,
      "startDate": Timestamp.fromDate(startDate),
      "endDate": endDate != null ? Timestamp.fromDate(endDate!) : null,
      "currentlyWorking": currentlyWorking,
      "description": description,
      "order": order,
    };
  }
}
