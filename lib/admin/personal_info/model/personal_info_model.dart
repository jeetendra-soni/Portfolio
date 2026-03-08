import 'package:cloud_firestore/cloud_firestore.dart';

class PersonalInfoModel {
  final String id;
  final Contact? contact;
  final String title;
  final Socials? socials;
  final String bio;
  final String name;
  final About? about;
  final String? profileImg2;
  final String? profileImg1;
  List<String>? expertise;

  PersonalInfoModel({
    required this.id,
    required this.contact,
    required this.title,
    required this.socials,
    required this.bio,
    required this.name,
    required this.about,
    required this.profileImg2,
    required this.profileImg1,
    this.expertise,
  });

  factory PersonalInfoModel.fromMap(Map<String, dynamic> json) => PersonalInfoModel(
    contact: Contact.fromMap(json["contact"]),
    title: json["title"]??"",
    socials: Socials.fromMap(json["socials"]),
    bio: json["bio"]??"",
    name: json["name"]??"Jeetendra Soni",
    about: About.fromMap(json["about"]),
    profileImg2: json["profileImg2"]??"",
    profileImg1: json["profileImg1"]??"",
    expertise: json["expertise"]??["Building Digital Products.",
      "Flutter & Dart Enthusiast.",
      "Mobile & Web Developer.",],
    id: json["id"]??"main",
  );
  /// Firestore Document -> Model
  factory PersonalInfoModel.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return PersonalInfoModel.fromMap(data);
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "contact": contact?.toMap(),
    "title": title,
    "socials": socials?.toMap(),
    "bio": bio,
    "name": name,
    "about": about?.toMap(),
    "profileImg2": profileImg2,
    "profileImg1": profileImg1,
    "expertise": expertise,
  };
}

class About {
   String expYears;
   String title;
   String projects;
   String description;
   String clients;

  About({
    required this.expYears,
    required this.title,
    required this.projects,
    required this.description,
    required this.clients,
  });

  factory About.fromMap(Map<String, dynamic> json) => About(
    expYears: json["expYears"]??"",
    title: json["title"]??"",
    projects: json["projects"]??"",
    description: json["description"]??"",
    clients: json["clients"]??"",
  );

  Map<String, dynamic> toMap() => {
    "expYears": expYears,
    "title": title,
    "projects": projects,
    "description": description,
    "clients": clients,
  };
}

class Contact {
  final String address;
  final String mobile;
  final String email;

  Contact({
    required this.address,
    required this.mobile,
    required this.email,
  });

  factory Contact.fromMap(Map<String, dynamic> json) => Contact(
    address: json["address"]??"",
    mobile: json["mobile"]??"",
    email: json["email"]??"",
  );

  Map<String, dynamic> toMap() => {
    "address": address,
    "mobile": mobile,
    "email": email,
  };
}

class Socials {
  final String fiverr;
  final String git;
  final String twitter;
  final List<dynamic> others;
  final String linkedIn;
  final String youtube;
  final String upwork;
  final String instagram;
  final String website;
  final String facebook;

  Socials({
    required this.fiverr,
    required this.git,
    required this.twitter,
    required this.others,
    required this.linkedIn,
    required this.youtube,
    required this.upwork,
    required this.instagram,
    required this.website,
    required this.facebook,
  });

  factory Socials.fromMap(Map<String, dynamic> json) => Socials(
    fiverr: json["fiverr"]??"",
    git: json["git"]??"",
    twitter: json["twitter"]??"",
    others: List<dynamic>.from(json["others"].map((x) => x)),
    linkedIn: json["linkedIn"]??"",
    youtube: json["youtube"]??"",
    upwork: json["upwork"]??"",
    instagram: json["instagram"]??"",
    website: json["website"]??"",
    facebook: json["Facebook"]??"",
  );



  Map<String, dynamic> toMap() => {
    "fiverr": fiverr,
    "git": git,
    "twitter": twitter,
    "others": List<dynamic>.from(others.map((x) => x)),
    "linkedIn": linkedIn,
    "youtube": youtube,
    "upwork": upwork,
    "instagram": instagram,
    "website": website,
    "Facebook": facebook,
  };
}