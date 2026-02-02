import 'package:flutter/material.dart';
import 'package:jeetendra_portfolio/utils/utils.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width < 700
        ? 1
        : width < 1000
            ? 2
            : 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Projects'),
        const SizedBox(height: 40),
        GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 32,
          crossAxisSpacing: 32,
          childAspectRatio: width < 700
              ? .82
              : width < 1000
                  ? .65
                  : .80,
          children: const [
            ProjectCard(
              title: 'Ride Booking Platform',
              description: 'Real-time ride booking app with live tracking, payments and route optimization. Real-time ride booking app with live tracking, payments and route optimization.',
              tech: ['Flutter', 'Firebase', 'Maps API', 'Payment'],
            ),
            ProjectCard(
              title: 'E-Commerce Application',
              description: 'High-performance shopping app with secure checkout and admin dashboard.',
              tech: ['Flutter', 'REST API', 'Stripe', 'In-app purchase'],
            ),
            ProjectCard(
              title: 'Healthcare Management System',
              description: 'Appointment booking, video consultation and medical record management.',
              tech: ['Flutter Web', 'Firebase', 'Cloud Functions'],
            ),
          ],
        ),
      ],
    );
  }
}

class ProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final List<String> tech;

  const ProjectCard({
    super.key,
    required this.title,
    required this.description,
    required this.tech,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: _hovered ? (Matrix4.identity()..translate(0, -8)) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: _hovered ? 30 : 18,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Image / Placeholder
            Container(
              height: 160,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.apps,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 10),
                  Text(
                    widget.description,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 14),

                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: widget.tech
                          .map(
                            (t) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Chip(
                                label: Text(
                                  t,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                backgroundColor: Colors.blue.withOpacity(.08),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Actions
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.link),
                        label: const Text('Live'),
                      ),
                      const SizedBox(width: 10),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.code),
                        label: const Text('GitHub'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
