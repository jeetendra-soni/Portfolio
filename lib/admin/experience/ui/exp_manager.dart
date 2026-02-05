import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jeetendra_portfolio/admin/experience/provider/exp_procider.dart';
import 'package:jeetendra_portfolio/admin/experience/ui/exp_dialog.dart';
import 'package:jeetendra_portfolio/admin/experience/ui/exp_tile.dart';

class ExperienceManager extends ConsumerWidget {
  const ExperienceManager({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final experienceAsync = ref.watch(experienceStreamProvider);
    final repo = ref.read(experienceRepositoryProvider);

    return Column(
      children: [
        Row(
          children: [
            const Text(
              "Experience",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            ElevatedButton.icon(
              icon: Icon(Icons.add, color: Colors.white),
              label: const Text("Add Experience", style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent,
              ),
              onPressed: () => showDialog(
                context: context,
                builder: (_) => ExperienceDialog(
                  onSave: repo.addExperience,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: experienceAsync.when(
            data: (experiences) => ListView.builder(
              itemCount: experiences.length,
              itemBuilder: (_, i) => ExperienceTile(
                experience: experiences[i],
                onEdit: () => showDialog(
                  context: context,
                  builder: (_) => ExperienceDialog(
                    experience: experiences[i],
                    onSave: repo.updateExperience,
                  ),
                ),
                onDelete: () => showDialog(
                  context: context,
                  builder: (_) => ExpDeleteDialog(
                    expName: experiences[i].company,
                    onConfirm: () =>repo.deleteExperience(experiences[i].id),
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
