import 'package:cloud_firestore/cloud_firestore.dart';

class PersonalInfoModel {
  final String id;
  final String name;
  final String title;
  final String bio;
  final String email;
  final String phone;
  final String location;

  final String github;
  final String linkedin;
  final String twitter;
  final String instagram;
  final String website;

  PersonalInfoModel({
    required this.id,
    required this.name,
    required this.title,
    required this.bio,
    required this.email,
    required this.phone,
    required this.location,
    required this.github,
    required this.linkedin,
    required this.twitter,
    required this.instagram,
    required this.website,
  });

  factory PersonalInfoModel.fromDoc(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return PersonalInfoModel(
      id: doc.id,
      name: data['name'],
      title: data['title'],
      bio: data['bio'],
      email: data['email'],
      phone: data['phone'],
      location: data['location'],
      github: data['github'],
      linkedin: data['linkedin'],
      twitter: data['twitter'],
      instagram: data['instagram'],
      website: data['website'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "title": title,
      "bio": bio,
      "email": email,
      "phone": phone,
      "location": location,
      "github": github,
      "linkedin": linkedin,
      "twitter": twitter,
      "instagram": instagram,
      "website": website,
    };
  }
}
