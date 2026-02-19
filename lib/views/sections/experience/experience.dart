import 'package:flutter/material.dart';
import 'package:jeetendra_portfolio/utils/utils.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Professional Experience'),
        SizedBox(height: 50),
        Column(
          children: [
            ExperienceItem(
              role: 'Senior Flutter Developer',
              company: 'Tech Solutions Pvt Ltd',
              duration: '2023 – Present',
              points: [
                'Led development of scalable Flutter mobile & web apps',
                'Implemented clean architecture and state management',
                'Optimized app performance by 30%',
                'Mentored junior developers',
              ],
            ),
            ExperienceItem(
              role: 'Flutter Developer',
              company: 'Digital Innovations',
              duration: '2021 – 2023',
              points: [
                'Built production-ready Flutter applications',
                'Integrated REST APIs and Firebase services',
                'Worked closely with designers and backend teams',
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class ExperienceItem extends StatelessWidget {
  final String role;
  final String company;
  final String duration;
  final List<String> points;

  const ExperienceItem({
    super.key,
    required this.role,
    required this.company,
    required this.duration,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TIMELINE
          Column(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.purple],
                  ),
                ),
              ),
              Container(
                width: 2,
                height: isMobile ? 120 : 160,
                color: Colors.grey.shade300,
              ),
            ],
          ),

          const SizedBox(width: 30),

          // CONTENT
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    company,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    duration,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: points
                        .map(
                          (point) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                                Expanded(child: Text(point)),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
