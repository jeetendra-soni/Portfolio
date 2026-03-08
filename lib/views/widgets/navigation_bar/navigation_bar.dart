import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jeetendra_portfolio/configs/app_fonts.dart';
import 'package:jeetendra_portfolio/configs/theme_config.dart';
import 'package:jeetendra_portfolio/views/widgets/dialogs/login_dialog.dart';
import 'package:jeetendra_portfolio/views/widgets/navigation_bar/navbar_logo.dart';

class MyNavigationBar extends StatelessWidget {
  final VoidCallback? onContactTap;
  final VoidCallback? onHomeTap;
  final VoidCallback? onAboutTap;
  final VoidCallback? onSkillsTap;
  final VoidCallback? onProjectsTap;
  final VoidCallback? onExperienceTap;
  final VoidCallback? onTestimonialTap;
  final VoidCallback? onMenuTap;

  const MyNavigationBar({
    super.key,
    this.onContactTap,
    this.onHomeTap,
    this.onAboutTap,
    this.onSkillsTap,
    this.onProjectsTap,
    this.onMenuTap,
    this.onExperienceTap,
    this.onTestimonialTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: AppTheme.darkBackground.withOpacity(0.8),
            border: const Border(
              bottom: BorderSide(color: Colors.white10, width: 1),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth < AppBreakpoints.tablet) {
              return _MobileNav(
                onContactTap: onContactTap,
                onMenuTap: onMenuTap,
              );
            }
            return _DesktopNav(
              onHomeTap: onHomeTap,
              onAboutTap: onAboutTap,
              onSkillsTap: onSkillsTap,
              onProjectsTap: onProjectsTap,
              onContactTap: onContactTap,
              onExperienceTap: onExperienceTap,
              onTestimonialTap: onTestimonialTap,
            );
          }),
        ),
      ),
    );
  }
}

class _DesktopNav extends StatelessWidget {
  final VoidCallback? onContactTap;
  final VoidCallback? onHomeTap;
  final VoidCallback? onAboutTap;
  final VoidCallback? onSkillsTap;
  final VoidCallback? onProjectsTap;
  final VoidCallback? onExperienceTap;
  final VoidCallback? onTestimonialTap;

  const _DesktopNav({
    this.onContactTap,
    this.onHomeTap,
    this.onAboutTap,
    this.onSkillsTap,
    this.onProjectsTap,
    this.onExperienceTap,
    this.onTestimonialTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const NavBarLogo(),
        const SizedBox(width: 12),
        GestureDetector(
          onLongPress: (){
            showDialog(context: context, builder: (context){
              return LoginDialog();
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "JEETENDRA SONI",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  letterSpacing: 1.2,
                  fontFamily: AppFonts.rowdiesFamily,
                ),
              ),
              Text(
                "Mobile App Developer",
                style: TextStyle(
                  color: AppTheme.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        _NavLink(title: "Home", onTap: onHomeTap),
        _NavLink(title: "About", onTap: onAboutTap),
        _NavLink(title: "Experience", onTap: onExperienceTap),
        _NavLink(title: "Skills", onTap: onSkillsTap),
        _NavLink(title: "Projects", onTap: onProjectsTap),
        _NavLink(title: "Testimonials", onTap: onTestimonialTap),
        const SizedBox(width: 24),
        ElevatedButton(
          onPressed: onContactTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text("Contact Me", style: TextStyle(fontSize: 14, fontFamily: AppFonts.rowdiesFamily, color: Colors.black),),
        ),
        // ElevatedButton(
        //   onPressed: (){
        //     showDialog(context: context, builder: (context){
        //       return LoginDialog();
        //     });
        //
        //   },
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: AppTheme.primary,
        //     foregroundColor: Colors.white,
        //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(12),
        //     ),
        //   ),
        //   child: const Text("Login"),
        // ),
      ],
    );
  }
}

class _MobileNav extends StatelessWidget {
  final VoidCallback? onContactTap;
  final VoidCallback? onMenuTap;
  const _MobileNav({this.onContactTap, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "JEETENDRA SONI",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 18,
                letterSpacing: 1.2,
                fontFamily: 'Inter',
              ),
            ),
            Text(
              "Flutter Developer",
              style: TextStyle(
                color: AppTheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: onContactTap,
          icon: const Icon(Icons.mail_outline, color: Colors.white),
          style: IconButton.styleFrom(
            backgroundColor: AppTheme.darkBackground.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: onMenuTap,
          icon: const Icon(Icons.menu, color: Colors.white),
        ),
      ],
    );
  }
}

class _NavLink extends StatefulWidget {
  final String title;
  final VoidCallback? onTap;
  const _NavLink({required this.title, this.onTap});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              color: _isHovered ? AppTheme.primary : Colors.white70,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            child: Text(widget.title),
          ),
        ),
      ),
    );
  }
}