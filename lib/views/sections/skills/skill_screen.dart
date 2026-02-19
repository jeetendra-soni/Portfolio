import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jeetendra_portfolio/admin/skills/model/skill_model.dart';
import 'package:jeetendra_portfolio/admin/skills/provider/skill_providers.dart';
import 'package:jeetendra_portfolio/constants/enums.dart';
import 'package:jeetendra_portfolio/utils/utils.dart';
import 'package:jeetendra_portfolio/views/sections/skills/skill_card.dart';
import 'package:jeetendra_portfolio/views/sections/skills/skill_model.dart';

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

        return Column(
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
        );
      },
    );
  }
}


final skillCategories = [
  const SkillCategory(
    title: 'Development',
    skills: [
      Skill(
        title: 'Flutter',
        icon: Icons.flutter_dash,
        color: Color(0xFF02569B),
      ),
      Skill(
        title: 'Dart',
        icon: Icons.code,
        color: Color(0xFF0175C2),
      ),
      Skill(
        title: 'Flutter Web',
        icon: Icons.web,
        color: Color(0xFF673AB7),
      ),
    ],
  ),
  const SkillCategory(
    title: 'Technical',
    skills: [
      Skill(
        title: 'REST APIs',
        icon: Icons.api,
        color: Color(0xFF4CAF50),
      ),
      Skill(
        title: 'State Management',
        icon: Icons.layers,
        color: Color(0xFF009688),
      ),
      Skill(
        title: 'Clean Architecture',
        icon: Icons.architecture,
        color: Color(0xFF3F51B5),
      ),
      Skill(
        title: 'Performance',
        icon: Icons.speed,
        color: Color(0xFFE91E63),
      ),
    ],
  ),
  const SkillCategory(
    title: 'Deployment & Backend',
    skills: [
      Skill(
        title: 'Firebase',
        icon: Icons.local_fire_department,
        color: Color(0xFFFFCA28),
      ),
      Skill(
        title: 'CI/CD',
        icon: Icons.sync,
        color: Color(0xFF607D8B),
      ),
      Skill(
        title: 'Play Store Release',
        icon: Icons.android,
        color: Color(0xFF3DDC84),
      ),
    ],
  ),
];