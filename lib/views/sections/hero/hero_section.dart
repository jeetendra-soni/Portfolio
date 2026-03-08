import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:jeetendra_portfolio/admin/personal_info/model/personal_info_model.dart';
import 'package:jeetendra_portfolio/configs/app_fonts.dart';
import 'package:jeetendra_portfolio/views/widgets/social_links.dart';
import 'package:jeetendra_portfolio/utils/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/buttons/iconButton.dart';
import '../../../utils/animated_container.dart';

class HeroSection extends StatefulWidget {
  final PersonalInfoModel profileInfo;

  const HeroSection({super.key, required this.profileInfo});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  // For looping typewriter animation
  late AnimationController _typewriterController;
  
  final List<String> _expertiseTexts = [
    "Building Digital Products.",
    "Flutter & Dart Enthusiast.",
    "Mobile & Web Developer.",
  ];
  int _currentTextIndex = 0;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Looping controller for typewriter
    _typewriterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
    ));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeInOutBack),
      ),
    );

    _mainController.forward();
    
    // Setup typewriter loop
    _startTypewriterLoop();
  }

  void _startTypewriterLoop() async {
    while (mounted) {
      await _typewriterController.forward();
      await Future.delayed(const Duration(seconds: 2));
      await _typewriterController.reverse();
      if (mounted) {
        setState(() {
          _currentTextIndex = (_currentTextIndex + 1) % _expertiseTexts.length;
        });
      }
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _typewriterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final isMobile = width < 600;
      final isTablet = width >= 600 && width < 1100;

      return Container(
        width: double.infinity,
        alignment: Alignment.topCenter,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // --- Background Blobs ---
            _AnimatedBlob(
              delay: 0,
              alignment: isMobile ? const Alignment(0, -0.8) : isTablet ? const Alignment(-0.8, -0.8) : const Alignment(-1.2, -1.2),
              color: Colors.cyan.withOpacity(0.15),
              size: isMobile ? 300 : isTablet ? 450 : 600,
            ),
            _AnimatedBlob(
              delay: 500,
              alignment: isMobile ? const Alignment(0, 0.8) : isTablet ? const Alignment(0.8, 0.8) : const Alignment(1.2, 1.2),
              color: Colors.blueAccent.withOpacity(0.1),
              size: isMobile ? 250 : isTablet ? 350 : 500,
            ),

            // --- Main Content ---
            Padding(
              padding: EdgeInsets.only(
                top: isMobile ? 20 : isTablet ? 50 : 80,
                bottom: isMobile ? 40 : 120,
                left: isMobile ? 16 : 40,
                right: isMobile ? 16 : 40,
              ),
              child: isMobile
                  ? _HeroMobile(
                      fade: _fadeAnimation,
                      slide: _slideAnimation,
                      scale: _scaleAnimation,
                      typewriterController: _typewriterController,
                      name: widget.profileInfo.name,
                      currentExpertise: _expertiseTexts[_currentTextIndex],
                      isTablet: false,
                    )
                  : isTablet 
                    ? _HeroTablet(
                      fade: _fadeAnimation,
                      slide: _slideAnimation,
                      scale: _scaleAnimation,
                      typewriterController: _typewriterController,
                      name: widget.profileInfo.name,
                      currentExpertise: _expertiseTexts[_currentTextIndex],
                    )
                    : _HeroDesktop(
                      fade: _fadeAnimation,
                      slide: _slideAnimation,
                      scale: _scaleAnimation,
                      typewriterController: _typewriterController,
                      name: widget.profileInfo.name,
                      currentExpertise: _expertiseTexts[_currentTextIndex],
                    ),
            ),

            if (!isMobile)
              Positioned(
                bottom: isTablet ? 15 : 30,
                child: FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _mainController,
                    curve: const Interval(0.8, 1.0, curve: Curves.easeIn),
                  ),
                  child: const _ScrollIndicator(),
                ),
              ),
          ],
        ),
      );
    });
  }
}

class _HeroDesktop extends StatelessWidget {
  final Animation<double> fade;
  final Animation<Offset> slide;
  final Animation<double> scale;
  final AnimationController typewriterController;
  final String name;
  final String currentExpertise;

  const _HeroDesktop({
    required this.fade,
    required this.slide,
    required this.scale,
    required this.typewriterController,
    required this.name,
    required this.currentExpertise,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: _HeroTextContent(
            isMobile: false, 
            isTablet: false, 
            typewriterController: typewriterController,
            name: name,
            currentExpertise: currentExpertise,
          ),
        ),
        const SizedBox(width: 40),
        FadeTransition(
          opacity: fade,
          child: ScaleTransition(
            scale: scale,
            child: const _AnimatedProfile(isMobile: false, isTablet: false),
          ),
        ),
      ],
    );
  }
}

class _HeroTablet extends StatelessWidget {
  final Animation<double> fade;
  final Animation<Offset> slide;
  final Animation<double> scale;
  final AnimationController typewriterController;
  final String name;
  final String currentExpertise;

  const _HeroTablet({
    required this.fade,
    required this.slide,
    required this.scale,
    required this.typewriterController,
    required this.name,
    required this.currentExpertise,
  });

  @override
  Widget build(BuildContext context) {
    return _HeroMobile(
      fade: fade,
      slide: slide,
      scale: scale,
      typewriterController: typewriterController,
      name: name,
      currentExpertise: currentExpertise,
      isTablet: true,
    );
  }
}

class _HeroMobile extends StatelessWidget {
  final Animation<double> fade;
  final Animation<Offset> slide;
  final Animation<double> scale;
  final AnimationController typewriterController;
  final String name;
  final String currentExpertise;
  final bool isTablet;

  const _HeroMobile({
    required this.fade,
    required this.slide,
    required this.scale,
    required this.typewriterController,
    required this.name,
    required this.currentExpertise,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FadeTransition(
          opacity: fade,
          child: ScaleTransition(
            scale: scale,
            child: _AnimatedProfile(isMobile: true, isTablet: isTablet),
          ),
        ),
        SizedBox(height: isTablet ? 40 : 30),
        _HeroTextContent(
          isMobile: true, 
          isTablet: isTablet, 
          typewriterController: typewriterController,
          name: name,
          currentExpertise: currentExpertise,
        ),
      ],
    );
  }
}

class _HeroTextContent extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;
  final AnimationController typewriterController;
  final String name;
  final String currentExpertise;

  const _HeroTextContent({
    required this.isMobile,
    required this.isTablet,
    required this.typewriterController,
    required this.name,
    required this.currentExpertise,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // Welcome Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.cyan.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.cyan.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.handshake_outlined, size: 16, color: Colors.cyanAccent),
              const SizedBox(width: 8),
              Text(
                "WELCOME TO MY PORTFOLIO",
                style: TextStyle(
                  fontSize: isMobile ? (isTablet ? 14 : 11) : 14,
                  color: Colors.cyanAccent,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        // Static Name
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.cyanAccent, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            name,
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
            style: TextStyle(
              fontSize: isMobile ? (isTablet ? 50 : 34) : 60,
              height: 1.1,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              fontFamily: AppFonts.aclonicaFamily,
            ),
          ),
        ),
        
        const SizedBox(height: 10),

        // Looping Typewriter Expertise
        AnimatedBuilder(
          animation: typewriterController,
          builder: (context, child) {
            final count = (currentExpertise.length * typewriterController.value).floor();
            return ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Colors.orangeAccent, Colors.orange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Text(
                currentExpertise.substring(0, count),
                textAlign: isMobile ? TextAlign.center : TextAlign.start,
                style: TextStyle(
                  fontSize: isMobile ? (isTablet ? 35 : 24) : 45,
                  height: 1.1,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontFamily: AppFonts.dancingScriptFamily
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: 24),
        Text(
          "I'm a Flutter & Dart Enthusiast with 3+ years of experience in crafting high-performance, scalable mobile and web applications with beautiful user interfaces.",
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.bold,
            fontSize: isMobile ? (isTablet ? 18 : 15) : 20,
            height: 1.6,
            fontFamily: AppFonts.josefinSansFamily,
          ),
        ),
        const SizedBox(height: 48),
        Wrap(
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          spacing: 20,
          runSpacing: 20,
          children: [
            CustomButton(
              icon: const Icon(Icons.send_rounded, size: 20, color: Colors.black),
              title: "Let's Talk",
              onTap: () {

              },
            ),
            const _SecondaryCTA(),
          ],
        ),
        const SizedBox(height: 40),
        SocialLinks(isMobile: isMobile),
      ],
    );
  }
}

class _AnimatedBlob extends StatefulWidget {
  final int delay;
  final Alignment alignment;
  final Color color;
  final double size;

  const _AnimatedBlob({
    required this.delay,
    required this.alignment,
    required this.color,
    required this.size,
  });

  @override
  State<_AnimatedBlob> createState() => _AnimatedBlobState();
}

class _AnimatedBlobState extends State<_AnimatedBlob>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.alignment,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.color,
                blurRadius: 100,
                spreadRadius: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedProfile extends StatefulWidget {
  final bool isMobile;
  final bool isTablet;
  const _AnimatedProfile({required this.isMobile, required this.isTablet});

  @override
  State<_AnimatedProfile> createState() => _AnimatedProfileState();
}

class _AnimatedProfileState extends State<_AnimatedProfile>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double size = widget.isMobile ? (widget.isTablet ? 300 : 200) : 380;
    double iconRadius = widget.isMobile && !widget.isTablet ? size * 0.7 : size * 0.8;
    
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -15 * _floatController.value),
          child: child,
        );
      },
      child: Center(
        child: SizedBox(
          width: size + 60,
          height: size + 60,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _RotatingBorder(size: size + 60),
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orangeAccent.withOpacity(0.4),
                      blurRadius: 60,
                      spreadRadius: 10,
                    ),
                  ],
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade200, Colors.orangeAccent.shade200],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              Container(
                width: size - 20,
                height: size - 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.1), width: 8),
                ),
                child: ClipOval(
                  child: Image.asset(
                    "assets/images/profile.png",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.orangeAccent.shade400,
                      child: Icon(Icons.person, color: Colors.white, size: size * 0.4),
                    ),
                  ),
                ),
              ),
              _FloatingIcon(icon: Icons.flutter_dash, angle: -0.5, radius: iconRadius),
              _FloatingIcon(icon: Icons.code, angle: 0.8, radius: iconRadius * 1.05),
              _FloatingIcon(icon: Icons.storage, angle: 2.5, radius: iconRadius * 0.95),
              _FloatingIcon(icon: Icons.api, angle: 4.2, radius: iconRadius * 1.02),
            ],
          ),
        ),
      ),
    );
  }
}

class _RotatingBorder extends StatefulWidget {
  final double size;
  const _RotatingBorder({required this.size});

  @override
  State<_RotatingBorder> createState() => _RotatingBorderState();
}

class _RotatingBorderState extends State<_RotatingBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * math.pi,
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _DashedCirclePainter(),
          ),
        );
      },
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orangeAccent.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    const double dashWidth = 5;
    const double dashSpace = 10;
    double currentAngle = 0;
    final double radius = size.width / 2;

    while (currentAngle < 2 * math.pi) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        currentAngle,
        dashWidth / radius,
        false,
        paint,
      );
      currentAngle += (dashWidth + dashSpace) / radius;
    }

    canvas.drawCircle(
      Offset(radius + radius * math.cos(0), radius + radius * math.sin(0)),
      4,
      Paint()..color = Colors.cyanAccent,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FloatingIcon extends StatelessWidget {
  final IconData icon;
  final double angle;
  final double radius;

  const _FloatingIcon({
    required this.icon,
    required this.angle,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    double x = math.cos(angle) * radius;
    double y = math.sin(angle) * radius;

    return Transform.translate(
      offset: Offset(x, y),
      child: _FloatAnimation(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white10),
            boxShadow: [
              BoxShadow(
                color: Colors.cyanAccent.withOpacity(0.2),
                blurRadius: 10,
              ),
            ],
          ),
          child: Icon(icon, color: Colors.orangeAccent.shade200, size: 24),
        ),
      ),
    );
  }
}

class _FloatAnimation extends StatefulWidget {
  final Widget child;
  const _FloatAnimation({required this.child});

  @override
  State<_FloatAnimation> createState() => _FloatAnimationState();
}

class _FloatAnimationState extends State<_FloatAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 10 * math.sin(_controller.value * math.pi)),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _SecondaryCTA extends StatelessWidget {
  const _SecondaryCTA();

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: SizedBox(
        height: 52,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            side: const BorderSide(color: Colors.cyan),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Colors.transparent,
          ),
          onPressed: () {
             urlLauncher(url: "https://firebasestorage.googleapis.com/v0/b/jeetendra-soni-portfolio.firebasestorage.app/o/resume%2FJeetendra-Soni(Flutter).pdf?alt=media&token=34483284-5205-44a2-b123-603094f88770");
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.download_rounded, size: 20, color: Colors.cyan),
              SizedBox(width: 10),
              Text(
                'Resume',
                style: TextStyle(
                  color: Colors.cyan,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScrollIndicator extends StatefulWidget {
  const _ScrollIndicator();

  @override
  State<_ScrollIndicator> createState() => _ScrollIndicatorState();
}

class _ScrollIndicatorState extends State<_ScrollIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "SCROLL DOWN",
          style: TextStyle(
            color: Colors.white.withOpacity(0.3),
            fontSize: 10,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 24,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Positioned(
                    top: 5 + (20 * _controller.value),
                    child: Opacity(
                      opacity: 1 - _controller.value,
                      child: Container(
                        width: 4,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.cyanAccent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}