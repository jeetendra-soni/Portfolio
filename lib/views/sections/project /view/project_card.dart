import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jeetendra_portfolio/admin/projects/model/project_model.dart';

class ProjectCard extends StatefulWidget {
  final ProjectModel project;

  const ProjectCard({
    super.key,
    required this.project,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final project = widget.project;

    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        // padding: EdgeInsets.symmetric(vertical: 32),
        transform:
        hovered ? (Matrix4.identity()..translate(0, -12)) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: const Color(0xfff5f6f8),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: hovered ? 40 : 25,
              offset: const Offset(0, 10),
            ),
          ],

        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              // ================= HERO SECTION =================
              Container(
                height: 180,
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xfff5f6f8),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white),
                ),
                child: project.bannerImage.isNotEmpty
                    ? Image.memory(
                  base64Decode(project.bannerImage),
                  fit: BoxFit.fill,
                )
                    : Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image, size: 32),
                ),
              ),
              ListTile(
                leading: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.white
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),

                    child: Icon(Icons.import_contacts_sharp)
                ),
                title:
                Text(
                  project.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Row(
                  children: [
                    Text(
                      "Live on : ",
                      style: const TextStyle(
                        fontSize: 12
                      ),
                    ),
                    _platformIcon(Icons.browser_updated, color: Colors.blue),
                    const SizedBox(width: 14),
                    _platformIcon(Icons.android, color: Colors.green),
                    const SizedBox(width: 14),
                    _platformIcon(Icons.apple, color: Colors.black),
                  ],
                ),


              ),
              // ================= CONTENT SECTION =================
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      project.description,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.7,
                        color: Color(0xff333333),
                      ),
                    ),

                    const SizedBox(height: 28),

                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      children: project.technologies
                          .map(
                            (tech) => Card(
                              child: Text(
                                tech.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                      )
                          .toList(),
                    ),

                    const SizedBox(height: 32),

                    Row(
                      children: [
                        if (project.playStoreUrl.isNotEmpty)
                          _primaryButton("Google Play"),

                        if (project.githubUrl.isNotEmpty)
                          const SizedBox(width: 16),

                        if (project.githubUrl.isNotEmpty)
                          _outlineButton("GitHub"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _platformIcon(IconData icon, {Color? color}) {
    return Icon(
      icon,
      color: color,
      size: 20,
    );
  }

  Widget _primaryButton(String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff145c3a),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () {},
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _outlineButton(String text) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: const BorderSide(color: Color(0xff145c3a)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () {},
      child: const Text(
        "GitHub",
        style: TextStyle(
          color: Color(0xff145c3a),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
