import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jeetendra_portfolio/admin/award_achievement/provider/award_provider.dart';
import 'package:jeetendra_portfolio/utils/utils.dart';
import 'package:jeetendra_portfolio/views/sections/award_achievement/award_card.dart';

class AwardsSection extends ConsumerWidget {
  const AwardsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final awardsAsync = ref.watch(awardStreamProvider);

    return awardsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text("Error: $e"),
      data: (awards) {
        if (awards.isEmpty) return const SizedBox();

        return SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(title: "Awards & Achievements"),
              const SizedBox(height: 40),

              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: awards.map((award) {
                  return AwardCard(award: award);
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}