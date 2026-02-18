import 'dart:convert';
import 'package:flutter/material.dart';
import '../model/project_model.dart';
import 'package:jeetendra_portfolio/constants/enums.dart';

class ProjectTile extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProjectTile({
    super.key,
    required this.project,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ---------------- BANNER IMAGE ----------------
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: project.bannerImage.isNotEmpty
                  ? Image.memory(
                base64Decode(project.bannerImage),
                width: 110,
                height: 110,
                fit: BoxFit.cover,
              )
                  : Container(
                width: 110,
                height: 110,
                color: Colors.grey.shade200,
                child: const Icon(Icons.image, size: 32),
              ),
            ),

            const SizedBox(width: 16),

            /// ---------------- DETAILS ----------------
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// Title + Featured + Order
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          project.title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      if (project.featured)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "FEATURED",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                          ),
                        ),

                      _buildStatusChip(project.status),
                    ],
                  ),

                  const SizedBox(height: 6),


                  const SizedBox(height: 6),

                  /// Description
                  Text(
                    project.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// Technologies
                  if (project.technologies.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: project.technologies
                          .map(
                            (tech) => Chip(
                          label: Text(
                            tech,
                            style: const TextStyle(fontSize: 11),
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                      )
                          .toList(),
                    ),

                  const SizedBox(height: 10),

                  /// Features (Preview)
                  if (project.features.isNotEmpty)
                    Text(
                      "Features: ${project.features.take(3).join(", ")}"
                          "${project.features.length > 3 ? "..." : ""}",
                      style: const TextStyle(fontSize: 12),
                    ),

                  const SizedBox(height: 12),

                  /// Links Row
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [

                      if (project.githubUrl.isNotEmpty)
                        _buildLinkChip(Icons.code, "GitHub"),

                      if (project.liveUrl.isNotEmpty)
                        _buildLinkChip(Icons.link, "Live"),

                      if (project.playStoreUrl.isNotEmpty)
                        _buildLinkChip(Icons.android, "Play Store"),

                      if (project.appStoreUrl.isNotEmpty)
                        _buildLinkChip(Icons.apple, "App Store"),

                      if (project.galleryImages.isNotEmpty)
                        _buildLinkChip(
                            Icons.photo_library,
                            "${project.galleryImages.length} Images"),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: onEdit,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: onDelete,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- STATUS CHIP ----------------
  Widget _buildStatusChip(ProjectStatus status) {
    Color color;

    switch (status) {
      case ProjectStatus.live:
        color = Colors.green;
        break;
      case ProjectStatus.inProgress:
        color = Colors.orange;
        break;
      case ProjectStatus.completed:
        color = Colors.blue;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// ---------------- LINK CHIP ----------------
  Widget _buildLinkChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }
}
