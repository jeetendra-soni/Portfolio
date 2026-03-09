import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jeetendra_portfolio/admin/experience/model/experience_model.dart';
import 'package:jeetendra_portfolio/configs/app_fonts.dart';
import 'package:jeetendra_portfolio/configs/theme_config.dart';

class ExperienceCard extends StatefulWidget {
  final int index;
  final ExperienceModel exe;

  const ExperienceCard({
    super.key,
    required this.exe,
    required this.index,
  });

  @override
  State<ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<ExperienceCard>
    with SingleTickerProviderStateMixin {
  bool isHovering = false;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String formatDuration(DateTime startDate, DateTime? endDate) {
    final start = DateFormat('MMM yyyy').format(startDate);
    if (endDate == null) return "$start - Present";
    final end = DateFormat('MMM yyyy').format(endDate);
    return "$start - $end";
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, .1),
      end: Offset.zero,
    ).animate(_fadeAnimation);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 700;

      return FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: MouseRegion(
              onEnter: (_) => setState(() => isHovering = true),
              onExit: (_) => setState(() => isHovering = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: EdgeInsets.all(isMobile ? 20 : 32),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  color: Colors.white,
                  border: Border.all(
                    color: isHovering ? AppTheme.primary.withOpacity(0.3) : Colors.black.withOpacity(0.05),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isHovering
                          ? AppTheme.primary.withOpacity(.08)
                          : Colors.black.withOpacity(.02),
                      blurRadius: isHovering ? 40 : 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // --- TIMELINE ACCENT ---
                      Container(
                        width: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [AppTheme.primary, Colors.black],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      SizedBox(width: isMobile ? 16 : 24),

                      // --- CONTENT ---
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Row
                            if (isMobile)
                              _MobileHeader(
                                index: widget.index,
                                role: widget.exe.role,
                                company: widget.exe.company,
                              )
                            else
                              _DesktopHeader(
                                index: widget.index,
                                role: widget.exe.role,
                                company: widget.exe.company,
                              ),

                            const SizedBox(height: 16),

                            // Tags (Location & Duration)
                            Wrap(
                              spacing: 12,
                              runSpacing: 8,
                              children: [
                                _chip(Icons.location_on_rounded, widget.exe.location),
                                _chip(Icons.calendar_month_rounded, formatDuration(widget.exe.startDate, widget.exe.endDate)),
                              ],
                            ),

                            const SizedBox(height: 24),
                            Container(height: 1, color: Colors.grey.withOpacity(0.1)),
                            const SizedBox(height: 20),

                            // Description Points
                            ...widget.exe.description
                                .split(". ")
                                .where((e) => e.trim().isNotEmpty)
                                .map((point) => Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 6),
                                            child: Icon(Icons.check_circle_rounded, 
                                              size: 16, 
                                              color: AppTheme.primary.withOpacity(0.7)
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              point.trim(),
                                              style: TextStyle(
                                                height: 1.6,
                                                fontSize: isMobile ? 14 : 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontFamily: AppFonts.josefinSansFamily,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _chip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black.withOpacity(0.05),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.black),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopHeader extends StatelessWidget {
  final int index;
  final String role;
  final String company;

  const _DesktopHeader({required this.index, required this.role, required this.company});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _IndexBadge(index: index),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(role, style:  TextStyle(fontSize: 22, fontWeight: FontWeight.w500, fontFamily: AppFonts.rowdiesFamily,)),
              Text(company, style:  TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black,fontFamily: AppFonts.josefinSansFamily,)),
            ],
          ),
        ),
      ],
    );
  }
}

class _MobileHeader extends StatelessWidget {
  final int index;
  final String role;
  final String company;

  const _MobileHeader({required this.index, required this.role, required this.company});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _IndexBadge(index: index, size: 40, fontSize: 18),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(role, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: AppFonts.rowdiesFamily,)),
                  Text(company, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
                ],
              ),
            ),
          ],
        ),],
    );
  }
}

class _IndexBadge extends StatelessWidget {
  final int index;
  final double size;
  final double fontSize;

  const _IndexBadge({required this.index, this.size = 60, this.fontSize = 22});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(colors: [AppTheme.primary, Colors.black]),
      ),
      child: Center(
        child: Icon(Icons.business_outlined, color: Colors.white, size: size * 0.6),
        // Text(
        //   "${index + 1}.",
        //   style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: AppFonts.rowdiesFamily),
        // ),
      ),
    );
  }
}