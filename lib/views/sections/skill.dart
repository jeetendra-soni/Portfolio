import 'package:flutter/material.dart';
import 'package:jeetendra_portfolio/utils/utils.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(title: 'Skills'),
              const SizedBox(height: 40),
              ...skillCategories.map((category) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        spacing: 24,
                        runSpacing: 24,
                        children: category.skills
                            .map(
                              (skill) => SkillCard(
                                title: skill.title,
                                icon: skill.icon,
                                color: skill.color,
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 50),
                    ],
                  )),
            ],
          ),
        ),
      ],
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

class SkillCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;

  const SkillCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  State<SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<SkillCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    // final isMobile = context.size!.width < 500;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: _hovered ? (Matrix4.identity()..translate(0, -8)) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(.25),
              blurRadius: _hovered ? 30 : 16,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color.withOpacity(.1),
              ),
              child: Icon(
                widget.icon,
                size: 26,
                color: widget.color,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              // overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
