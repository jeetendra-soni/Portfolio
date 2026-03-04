import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialLinks extends StatelessWidget {
  final bool isMobile;
  const SocialLinks({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
      isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        _SocialIcon(
          assetPath: 'assets/icons/linkedin.png',
          url: 'https://linkedin.com/in/jeetendra-soni-5b1721175/',
          tooltip: 'LinkedIn',
          color: const Color(0xff0077b5),
        ),
        _SocialIcon(
          assetPath: 'assets/icons/github.png',
          url: 'https://github.com/Jeetendra-Soni',
          tooltip: 'GitHub',
          color: const Color(0xff333333),
        ),
        _SocialIcon(
          assetPath: 'assets/icons/instagram.png',
          url: 'https://instagram.com/itsjeetendrasoni',
          tooltip: 'Instagram',
          color: const Color(0xffe1306c),
        ),
        _SocialIcon(
          assetPath: 'assets/icons/facebook.png',
          url: 'https://facebook.com/JEr.JEETENDRA.SONI/',
          tooltip: 'Facebook',
          color: const Color(0xff1877f2),
        ),
      ],
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final String assetPath;
  final String url;
  final String tooltip;
  final Color color;

  const _SocialIcon({
    required this.assetPath,
    required this.url,
    required this.tooltip,
    required this.color,
  });

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: () => launchUrl(Uri.parse(widget.url)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _isHovered ? widget.color : Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
              border: Border.all(
                color: _isHovered ? widget.color : Colors.white10,
              ),
              boxShadow: _isHovered
                  ? [
                BoxShadow(
                  color: widget.color.withOpacity(0.4),
                  blurRadius: 15,
                  spreadRadius: 2,
                )
              ]
                  : [],
            ),
            child: Image.asset(
              widget.assetPath,
              color: _isHovered ? Colors.white : Colors.white70,
              height: 24,
              width: 24,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.link,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}