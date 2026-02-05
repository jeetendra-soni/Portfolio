import 'package:flutter/material.dart';
import 'package:jeetendra_portfolio/admin/experience/model/experience_model.dart';

class ExperienceTile extends StatelessWidget {
  final ExperienceModel experience;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ExperienceTile({
    super.key,
    required this.experience,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 40,
          child: ClipOval(
            child: Icon(Icons.business_outlined),
            ),
          ),
        title: Expanded(child: Text(experience.role, style: const TextStyle(fontSize: 16))),
        subtitle: Row(
          children: [
            Text(
              "${experience.company} • ${experience.employmentType}",
              style: const TextStyle(fontSize: 12),
            ),
            Text(" • ${experience.startDate.year} - "
                "${experience.currentlyWorking ? "Present" : experience.endDate?.year}", style: const TextStyle(fontSize: 12))
          ],
        ),
        trailing:  Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete, color: Colors.red,), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
