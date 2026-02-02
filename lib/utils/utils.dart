import 'package:flutter/material.dart';

class _AnimatedSkillCardState extends State<AnimatedSkillCard> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 160,
        height: 140,
        decoration: BoxDecoration(
          color: hover ? Colors.cyan.withOpacity(0.2) : Colors.white10,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.cyanAccent),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, size: 40, color: Colors.cyanAccent),
            const SizedBox(height: 10),
            Text(widget.title),
          ],
        ),
      ),
    );
  }
}

class AnimatedSkillCard extends StatefulWidget {
  final String title;
  final IconData icon;

  const AnimatedSkillCard({super.key, required this.title, required this.icon});

  @override
  State<AnimatedSkillCard> createState() => _AnimatedSkillCardState();
}

class AnimatedFlutterGraphic extends StatefulWidget {
  const AnimatedFlutterGraphic({super.key});

  @override
  State<AnimatedFlutterGraphic> createState() => _AnimatedFlutterGraphicState();
}

class _AnimatedFlutterGraphicState extends State<AnimatedFlutterGraphic> with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      child: const Icon(Icons.flutter_dash, size: 220, color: Colors.cyanAccent),
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (controller.value - 0.5)),
          child: child,
        );
      },
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final bool light;
  const SectionTitle({super.key, required this.title, this.light = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: light ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 4,
          width: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: const LinearGradient(
              colors: [Colors.blue, Colors.purple],
            ),
          ),
        ),
      ],
    );
  }
}
