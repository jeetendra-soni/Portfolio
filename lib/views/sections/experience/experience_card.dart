import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jeetendra_portfolio/admin/experience/model/experience_model.dart';

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

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOut);

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
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: MouseRegion(
            onEnter: (_) => setState(() => isHovering = true),
            onExit: (_) => setState(() => isHovering = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xffffffff),
                    Color(0xfff8fafc),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isHovering
                        ?  Colors.orangeAccent.withOpacity(.15)
                        : Colors.black.withOpacity(.05),
                    blurRadius: isHovering ? 40 : 25,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// LEFT TIMELINE ACCENT
                  Container(
                    width: 4,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [
                          Colors.orangeAccent,
                          Colors.orange,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),

                  const SizedBox(width: 24),

                  /// CONTENT
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        /// HEADER
                        Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [

                            /// INDEX BADGE
                            Container(
                              width: 65,
                              height: 65,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(18),
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.orangeAccent,
                                    Colors.orange,
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "${widget.index + 1}",
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight:
                                    FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 22),

                            /// TITLE SECTION
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                children: [

                                  Text(
                                    widget.exe.role,
                                    style:
                                    const TextStyle(
                                      fontSize: 22,
                                      fontWeight:
                                      FontWeight.bold,
                                      letterSpacing: .3,
                                    ),
                                  ),

                                  const SizedBox(
                                      height: 6),

                                  Text(
                                    widget.exe.company,
                                    style:
                                    const TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                      FontWeight.w600,
                                      color: Colors.orangeAccent,
                                    ),
                                  ),

                                  const SizedBox(
                                      height: 12),

                                  Wrap(
                                    spacing: 14,
                                    runSpacing: 8,
                                    children: [
                                      _chip(
                                        Icons
                                            .location_on_outlined,
                                        widget.exe
                                            .location,
                                      ),
                                      _chip(
                                        Icons
                                            .calendar_today_outlined,
                                        formatDuration(
                                            widget.exe
                                                .startDate,
                                            widget.exe
                                                .endDate),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 26),

                        Container(
                          height: 1,
                          color: Colors.grey.shade200,
                        ),

                        const SizedBox(height: 22),

                        /// DESCRIPTION
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: widget.exe.description
                              .split(". ")
                              .where((e) =>
                          e.trim().isNotEmpty)
                              .map(
                                (point) => Padding(
                              padding:
                              const EdgeInsets
                                  .only(
                                  bottom: 14),
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                children: [

                                  Container(
                                    margin:
                                    const EdgeInsets
                                        .only(
                                        top: 7),
                                    width: 9,
                                    height: 9,
                                    decoration:
                                    const BoxDecoration(
                                      shape: BoxShape
                                          .circle,
                                      color: Colors.orangeAccent,
                                    ),
                                  ),

                                  const SizedBox(
                                      width: 14),

                                  Expanded(
                                    child: Text(
                                      point.trim(),
                                      style:
                                      const TextStyle(
                                        height: 1.7,
                                        fontSize: 15,
                                        color: Colors
                                            .black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: const Color(0xfff1f5f9),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 14, color: Colors.grey.shade600),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}