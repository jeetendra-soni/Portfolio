import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jeetendra_portfolio/configs/app_fonts.dart';
import 'package:jeetendra_portfolio/constants/assets_const.dart';
import 'package:jeetendra_portfolio/utils/animated_container.dart';
import 'package:jeetendra_portfolio/utils/utils.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 900;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: 'About Me'),
            const SizedBox(height: 60),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const _AboutImage(isMobile: true),
        const SizedBox(height: 60),
        const _AboutText(),
        const SizedBox(height: 40),
        const _AboutHighlights(isMobile: true),
      ],
    );
  }
}

class _DesktopAboutLayout extends StatelessWidget {
  const _DesktopAboutLayout();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AboutText(),
              SizedBox(height: 40),
              _AboutHighlights(isMobile: false),
            ],
          ),
        ),
        const SizedBox(width: 80),
        const Expanded(
          flex: 4,
          child: _AboutImage(isMobile: false),
        ),
      ],
    );
  }
}

class _AboutImage extends StatelessWidget {
  final bool isMobile;
  const _AboutImage({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Decorative background element
          Container(
            width: isMobile ? 260 : 380,
            height: isMobile ? 260 : 380,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.orange.withOpacity(0.25), width: 2),
            ),
          ),
          Transform.rotate(
            angle: 0.1,
            child: Container(
              width: isMobile ? 260 : 380,
              height: isMobile ? 260 : 380,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.orange.withOpacity(0.1),
              ),
            ),
          ),
          CustomContainer(
            color: Colors.transparent,
            child: Container(
              width: isMobile ? 250 : 360,
              height: isMobile ? 250 : 360,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  AssetsConst.aboutProfile,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.person, size: 100, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutText extends StatelessWidget {
  const _AboutText();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bridging the gap between design and high-performance engineering.',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: Colors.orange,
                height: 1.3,
            fontFamily: AppFonts.josefinSansFamily,
              ),
        ),
        const SizedBox(height: 24),
        Text(
          'I am a Senior Flutter Developer with 3+ years of experience dedicated to crafting exceptional mobile and web experiences. My journey is defined by a passion for clean architecture, seamless animations, and building products that actually solve user problems.',
          style: TextStyle(
            fontSize: 16,
            height: 1.8,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: AppFonts.josefinSansFamily
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Specializing in building scalable, production-ready applications, I have worked across e-commerce, healthcare, and fintech domains, always pushing the boundaries of what is possible with Flutter.',
          style: TextStyle(
            fontSize: 16,
            height: 1.8,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            fontFamily: AppFonts.josefinSansFamily
          ),
        ),
      ],
    );
  }
}

class _AboutHighlights extends StatelessWidget {
  final bool isMobile;
  const _AboutHighlights({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 24,
      runSpacing: 24,
      alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
      children: const [
        _HighlightCard(
          title: '3+',
          subtitle: 'Years of\nExperience',
          icon: Icons.timer_outlined,
          color: Colors.blue,
        ),
        _HighlightCard(
          title: '15+',
          subtitle: 'Projects\nDelivered',
          icon: Icons.rocket_launch_outlined,
          color: Colors.purple,
        ),
        _HighlightCard(
          title: '10+',
          subtitle: 'Global\nClients',
          icon: Icons.public_outlined,
          color: Colors.orange,
        ),
      ],
    );
  }
}

class _HighlightCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _HighlightCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  State<_HighlightCard> createState() => _HighlightCardState();
}

class _HighlightCardState extends State<_HighlightCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 160,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _hovered ? widget.color.withOpacity(0.5) : Colors.grey.withOpacity(0.1),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: _hovered ? widget.color.withOpacity(0.1) : Colors.black.withOpacity(0.02),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(widget.icon, color: widget.color, size: 32),
            const SizedBox(height: 16),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: widget.color,
                fontFamily: AppFonts.rowdiesFamily
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                height: 1.2,
                fontFamily: AppFonts.crimsonProFamily
              ),
            ),
          ],
        ),
      ),
    );
  }
}