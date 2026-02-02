import 'package:flutter/material.dart';
import 'package:jeetendra_portfolio/utils/utils.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: 'About Me'),
            const SizedBox(height: 40),
            isMobile ? const _MobileAboutLayout() : const _DesktopAboutLayout(),
          ],
        );
      },
    );
  }
}

class _MobileAboutLayout extends StatelessWidget {
  const _MobileAboutLayout();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AboutText(),
        SizedBox(height: 40),
        _AboutHighlights(),
      ],
    );
  }
}

class _DesktopAboutLayout extends StatelessWidget {
  const _DesktopAboutLayout();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: _AboutText(),
        ),
        SizedBox(width: 50),
        Expanded(
          flex: 5,
          child: _AboutHighlights(),
        ),
      ],
    );
  }
}

class _AboutText extends StatelessWidget {
  const _AboutText();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'I am a Senior Flutter Developer specializing in building scalable, '
          'high-performance mobile and web applications using Flutter.',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            height: 1.6,
          ),
        ),
        SizedBox(height: 20),
        Text(
          'With over 3+ years of professional experience, I have delivered '
          'production-ready applications across domains like ride-hailing, '
          'e-commerce, and healthcare. I focus on clean architecture, '
          'performance optimization, and maintainable codebases.',
          style: TextStyle(
            height: 1.7,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 20),
        Text(
          'I enjoy collaborating with designers, backend engineers, and '
          'product teams to build solutions that solve real-world problems.',
          style: TextStyle(
            height: 1.7,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class _AboutHighlights extends StatelessWidget {
  const _AboutHighlights();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _HighlightCard(
          title: '3+',
          subtitle: 'Years Experience',
        ),
        SizedBox(height: 24),
        _HighlightCard(
          title: '15+',
          subtitle: 'Projects Delivered',
        ),
        SizedBox(height: 24),
        _HighlightCard(
          title: '10+',
          subtitle: 'Happy Clients',
        ),
      ],
    );
  }
}

class _HighlightCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _HighlightCard({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
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
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
