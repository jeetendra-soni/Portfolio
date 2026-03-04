import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jeetendra_portfolio/admin/award_achievement/model/award_model.dart';

class AwardTile extends StatelessWidget {
  final AwardModel award;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AwardTile({
    super.key,
    required this.award,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: award.iconUrl != null
            ? Image.network(
          award.iconUrl!,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
        )
            : const Icon(Icons.emoji_events),

        title: Text(award.title),
        subtitle: Text(
          "${award.organization} • ${award.date.year}",
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