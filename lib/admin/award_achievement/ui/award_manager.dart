import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jeetendra_portfolio/admin/award_achievement/provider/award_provider.dart';
import 'package:jeetendra_portfolio/admin/award_achievement/ui/award_dialog.dart';
import 'package:jeetendra_portfolio/admin/award_achievement/ui/award_tile.dart';


class AwardManager extends ConsumerWidget {
  const AwardManager({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final awardAsync = ref.watch(awardStreamProvider);
    final repo = ref.read(awardRepositoryProvider);

    return Column(
      children: [
        Row(
          children: [
            const Text(
              "Awards & Achievements",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            ElevatedButton.icon(
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "Add Award",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent,
              ),
              onPressed: () => showDialog(
                context: context,
                builder: (_) => AwardDialog(
                  onSave: repo.addAward,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: awardAsync.when(
            data: (awards) => ListView.builder(
              itemCount: awards.length,
              itemBuilder: (_, i) => AwardTile(
                award: awards[i],
                onEdit: () => showDialog(
                  context: context,
                  builder: (_) => AwardDialog(
                    award: awards[i],
                    onSave: repo.updateAward,
                  ),
                ),
                onDelete: () => showDialog(
                  context: context,
                  builder: (_) => AwardDeleteDialog(
                    awardTitle: awards[i].title,
                    onConfirm: () =>
                        repo.deleteAward(awards[i].id),
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