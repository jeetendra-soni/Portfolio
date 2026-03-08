import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jeetendra_portfolio/configs/app_fonts.dart';
import 'package:jeetendra_portfolio/constants/color_const.dart';

class SkillCard extends StatefulWidget {
  final String title;
  final String icon;

  const SkillCard({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  State<SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<SkillCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    // final isMobile = context.size!.width < 500;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: _hovered ? (Matrix4.identity()..translate(0, -8)) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColor.randomShadowColor(),
              blurRadius: _hovered ? 10 : 3,
              offset:  Offset(_hovered ?4: 2, _hovered ? 4: 2, ),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 40,
              width: 40,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // color: widget.color.withOpacity(.1),
              ),
              child: CachedNetworkImage(
                imageUrl: widget.icon,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: AppFonts.josefinSansFamily,
              ),
              maxLines: 2,
              // overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}