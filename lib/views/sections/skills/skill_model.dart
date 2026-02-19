import 'package:flutter/material.dart';

class Skill {
  final String title;
  final IconData icon;
  final Color color;

  const Skill({
    required this.title,
    required this.icon,
    required this.color,
  });
}

class SkillCategory {
  final String title;
  final List<Skill> skills;

  const SkillCategory({
    required this.title,
    required this.skills,
  });
}