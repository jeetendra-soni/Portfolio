import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jeetendra_portfolio/admin/skills/model/skill_model.dart';
import 'package:jeetendra_portfolio/admin/skills/provider/skill_providers.dart';
import 'package:jeetendra_portfolio/constants/enums.dart';
import 'package:jeetendra_portfolio/utils/utils.dart';
import 'package:jeetendra_portfolio/views/sections/skills/skill_card.dart';

class SkillsSection extends ConsumerWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skillsAsync = ref.watch(skillStreamProvider);

    return skillsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text("Error: $e")),
      data: (skills) {
        // Group skills by category
        final Map<String, List<SkillModel>> grouped = {};

        for (var skill in skills) {
          grouped.putIfAbsent(skill.category.label, () => []).add(skill);
        }

        return SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(title: 'My Skill Set'),
              const SizedBox(height: 40),

              ...grouped.entries.map((entry) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key,
                    style:
                    Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    children: entry.value
                        .map(
                          (skill) => SkillCard(
                        title: skill.name,
                        icon: skill.icon,
                      ),
                    )
                        .toList(),
                  ),

                  const SizedBox(height: 50),
                ],
              )),
            ],
          ),
        );
      },
    );
  }
}