import 'package:flutter/material.dart';
import 'package:jeetendra_portfolio/utils/utils.dart';

class TestimonialSection extends StatelessWidget {
  const TestimonialSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: "Client Testimonials"),
        const SizedBox(height: 60),
        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 800;
            return Wrap(
              spacing: 30,
              runSpacing: 30,
              alignment: WrapAlignment.center,
              children: const [
                _TestimonialCard(
                  name: "John Doe",
                  role: "CEO, TechFlow",
                  message: "Jeetendra delivered an exceptional Flutter app ahead of schedule. His attention to detail and UI/UX expertise is top-notch.",
                  rating: 5,
                ),
                _TestimonialCard(
                  name: "Sarah Smith",
                  role: "Product Manager, HealthSync",
                  message: "Working with Jeetendra was a breeze. He translated our complex requirements into a smooth, high-performance mobile experience.",
                  rating: 5,
                ),
                _TestimonialCard(
                  name: "Michael Brown",
                  role: "Founder, QuickRide",
                  message: "The scalability and clean code Jeetendra provided helped us grow our user base without any performance hiccups. Highly recommended!",
                  rating: 4.5,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _TestimonialCard extends StatefulWidget {
  final String name;
  final String role;
  final String message;
  final double rating;

  const _TestimonialCard({
    required this.name,
    required this.role,
    required this.message,
    required this.rating,
  });

  @override
  State<_TestimonialCard> createState() => _TestimonialCardState();
}

class _TestimonialCardState extends State<_TestimonialCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 360,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _isHovered ? Colors.blueAccent.withOpacity(0.5) : Colors.grey.withOpacity(0.1),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered ? Colors.blueAccent.withOpacity(0.1) : Colors.black.withOpacity(0.02),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        transform: _isHovered ? (Matrix4.identity()..translate(0, -10)) : Matrix4.identity(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < widget.rating.floor()
                      ? Icons.star_rounded
                      : (index < widget.rating ? Icons.star_half_rounded : Icons.star_outline_rounded),
                  color: Colors.amber,
                  size: 20,
                );
              }),
            ),
            const SizedBox(height: 24),
            Text(
              "\"${widget.message}\"",
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 16,
                fontStyle: FontStyle.italic,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blueAccent.withOpacity(0.1),
                  child: Text(widget.name[0], style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      widget.role,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}