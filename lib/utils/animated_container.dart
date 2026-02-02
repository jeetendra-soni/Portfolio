import 'package:flutter/material.dart';

class CustomContainer extends StatefulWidget {
  final Color color;
  final Widget child;

  const CustomContainer({super.key, this.color = Colors.transparent, required this.child});

  @override
  State<CustomContainer> createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
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
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(.25),
              blurRadius: _hovered ? 30 : 16,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}
