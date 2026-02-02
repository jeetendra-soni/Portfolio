import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jeetendra_portfolio/constants/enums.dart';


class SkillModel {
  final String id;
  final String name;
  final SkillLevel level;
  final SkillCategory category;
  final int experienceYears;
  final String icon;
  final int order;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  SkillModel({
    required this.id,
    required this.name,
    required this.level,
    required this.category,
    required this.experienceYears,
    required this.icon,
    required this.order,
    this.createdAt,
    this.updatedAt,
  });

  static const Map<SkillLevel, int> levelToValue = {
    SkillLevel.beginner: 40,
    SkillLevel.intermediate: 70,
    SkillLevel.expert: 90,
  };

  static SkillLevel valueToLevel(int value) {
    if (value <= 40) return SkillLevel.beginner;
    if (value <= 70) return SkillLevel.intermediate;
    return SkillLevel.expert;
  }

  factory SkillModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SkillModel(
      id: doc.id,
      name: data['name'] ?? '',
      level: valueToLevel(data['level'] ?? 40),
      category: SkillCategory.values.firstWhere((e) => e.name.toString() == data['category'], orElse: () => SkillCategory.devTools),
      experienceYears: data['experienceYears'] ?? 0,
      icon: data['icon'] ?? 'default',
      order: data['order'] ?? 0,
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  Map<String, dynamic> toMap({bool isCreate = false}) {
    return {
      "name": name,
      "level": levelToValue[level],
      "category": category.toString().split('.').last,
      "experienceYears": experienceYears,
      "icon": icon,
      "order": order,
      "updatedAt": FieldValue.serverTimestamp(),
      if (isCreate) "createdAt": FieldValue.serverTimestamp(),
    };
  }

  SkillModel copyWith({
    String? id,
    String? name,
    SkillLevel? level,
    SkillCategory? category,
    int? experienceYears,
    String? icon,
    int? order,
  }) {
    return SkillModel(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      category: category ?? this.category,
      experienceYears: experienceYears ?? this.experienceYears,
      icon: icon ?? this.icon,
      order: order ?? this.order,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
