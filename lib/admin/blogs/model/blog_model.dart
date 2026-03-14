import 'package:cloud_firestore/cloud_firestore.dart';

class BlogModel {
  final String id;
  final String title;
  final String description;
  final String content;
  final String imageUrl;
  final String link;
  final DateTime date;
  final List<String> tags;
  final bool isPublished;

  BlogModel({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.imageUrl,
    required this.link,
    required this.date,
    required this.tags,
    this.isPublished = true,
  });

  factory BlogModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return BlogModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      content: data['content'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      link: data['link'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      tags: List<String>.from(data['tags'] ?? []),
      isPublished: data['isPublished'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'content': content,
      'imageUrl': imageUrl,
      'link': link,
      'date': Timestamp.fromDate(date),
      'tags': tags,
      'isPublished': isPublished,
    };
  }
}