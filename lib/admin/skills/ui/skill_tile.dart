import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jeetendra_portfolio/constants/enums.dart';
import '../model/skill_model.dart';

class SkillTile extends StatelessWidget {
  final SkillModel skill;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SkillTile({
    super.key,
    required this.skill,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
      leading: CircleAvatar(
      backgroundColor: Colors.white,
        child: ClipOval(
          child: skill.icon.isNotEmpty
              ? Image.memory(
            base64Decode(skill.icon),
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          )
              : Center(
            child: Text(
              "${SkillModel.levelToValue[skill.level]}%",
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
      ),

      title: Text(skill.name, style: const TextStyle(fontSize: 16)),
        subtitle: Text(
          "${skill.experienceYears} Years , ${skill.category.label}",
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
