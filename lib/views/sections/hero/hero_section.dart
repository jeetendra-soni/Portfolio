import 'package:flutter/material.dart';
import 'package:jeetendra_portfolio/utils/url_launcher.dart';

import '../../../utils/animated_container.dart';
import '../../../utils/buttons/iconButton.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 500;

        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 40 : 80,
          ),
          child: isMobile ? const _HeroMobile() : _HeroDesktop(),
        );
      },
    );
  }
}

class _HeroMobile extends StatelessWidget {
  const _HeroMobile();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomContainer(
                child: ClipRRect(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset("assets/images/profile.jpeg"),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Er. JEETENDRA SONI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Image.asset(
                    "assets/icons/ind_flag.png",
                    height: 22,
                    width: 22,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.purple],
                  ),
                ),
                child: const Text(
                  'Senior Flutter Developer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        const _HeroText(isMobile: true),
      ],
    );
  }
}

class _HeroDesktop extends StatelessWidget {
  bool hovered = false;
  _HeroDesktop();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomContainer(
                color: Colors.white,
                child: ClipRRect(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset("assets/images/profile.jpeg"),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Er. JEETENDRA SONI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Image.asset(
                    "assets/icons/ind_flag.png",
                    height: 22,
                    width: 22,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.purple],
                  ),
                ),
                child: const Text(
                  'Senior Flutter Developer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 40),
        const Expanded(child: _HeroText(isMobile: true)),
      ],
    );
  }
}

class _HeroText extends StatelessWidget {
  final bool isMobile;
  const _HeroText({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Building Scalable Mobile & Web Apps',
          style: TextStyle(
            fontSize: isMobile ? 32 : 48,
            height: 1.2,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Flutter expert focused on performance, clean architecture, '
          'and beautiful user experiences.'
          'Flutter expert focused on performance, clean architecture, '
          'and beautiful user experiences.',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            height: 1.6,
          ),
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 30),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            CustomButton(
              icon: const Icon(Icons.request_quote),
              title: "Hire Me",
              onTap: () {},
            ),
            _SecondaryCTA(),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Wrap(
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          spacing: 0,
          runSpacing: 12,
          children: [
            CustomButton(
              icon: Image.asset("assets/icons/youtube.png"),
              title: "YouTube",
              onTap: () {
                urlLauncher(
                  url: "https://www.youtube.com/",
                );
              },
              secondary: true,
            ),
            CustomButton(
              icon: Image.asset("assets/icons/linkedin.png"),
              title: "LinkedIn",
              onTap: () {
                urlLauncher(
                  url: "https://www.linkedin.com/",
                );
              },
              secondary: true,
            ),
            CustomButton(
              icon: Image.asset("assets/icons/github.png"),
              title: "Github",
              onTap: () {
                urlLauncher(
                  url: "https://www.github.com/",
                );
              },
              secondary: true,
            ),
            CustomButton(
              icon: Image.asset("assets/icons/twitter.png"),
              title: "Twitter",
              onTap: () {
                urlLauncher(
                  url: "https://www.twitter.com/",
                );
              },
              secondary: true,
            ),
          ],
        ),
      ],
    );
  }
}

class _SecondaryCTA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          side: const BorderSide(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () {
          // Download CV
        },
        child: const Text(
          'Download CV',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _HeroGraphic extends StatelessWidget {
  final bool isMobile;
  const _HeroGraphic({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background gradient circle
          Container(
            width: isMobile ? 220 : 300,
            height: isMobile ? 220 : 300,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
              ),
            ),
          ),

          // Flutter icon
          const Icon(
            Icons.flutter_dash,
            size: 120,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}