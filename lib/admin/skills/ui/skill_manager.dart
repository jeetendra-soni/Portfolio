import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jeetendra_portfolio/admin/skills/provider/skill_providers.dart';
import 'package:jeetendra_portfolio/admin/skills/ui/skill_dialog.dart';
import 'package:jeetendra_portfolio/admin/skills/ui/skill_tile.dart';


class SkillManager extends ConsumerWidget {
  const SkillManager({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skillsAsync = ref.watch(skillStreamProvider);
    final repo = ref.read(skillRepositoryProvider);

    return Column(
      children: [
        Row(
          children: [
            const Text("Skills",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Spacer(),
            ElevatedButton.icon(
              icon: const Icon(Icons.add, color: Colors.white,),
              label:  Text("Add Skill", style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent,
              ),
              onPressed: () => showDialog(
                context: context,
                builder: (_) => SkillDialog(
                  onSave: repo.addSkill,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: skillsAsync.when(
            data: (skills) => ListView.builder(
              itemCount: skills.length,
              itemBuilder: (_, i) => SkillTile(
                skill: skills[i],
                onEdit: () => showDialog(
                  context: context,
                  builder: (_) => SkillDialog(
                    skill: skills[i],
                    onSave: repo.updateSkill,
                  ),
                ),
                onDelete: () => showDialog(
                  context: context,
                  builder: (_) => SkillDeleteDialog(
                    skillName: skills[i].name,
                    onConfirm: () => repo.deleteSkill(skills[i].id),
                  ),
                ),

              ),
            ),
            loading: () =>
            const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text(e.toString())),
          ),
        ),
      ],
    );
  }
}
