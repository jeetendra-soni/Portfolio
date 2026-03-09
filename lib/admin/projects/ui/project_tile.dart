import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
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

            /// ---------------- PROJECT ICON / BANNER ----------------
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias, // This ensures content stays inside the radius
              child: project.icon.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: project.icon,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey.shade50,
                        child: const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade50,
                        child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey, size: 24),
                      ),
                    )
                  : Container(
                      color: Colors.grey.shade50,
                      child: const Icon(Icons.image_outlined, color: Colors.grey, size: 24),
                    ),
            ),

            const SizedBox(width: 16),

            /// ---------------- DETAILS ----------------
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// Title + Featured + Status
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
                            (tech) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.blue.withOpacity(0.1)),
                              ),
                              child: Text(
                                tech,
                                style: const TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.w600),
                              ),
                            ),
                          )
                          .toList(),
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
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_note_rounded, color: Colors.blueGrey),
                        onPressed: onEdit,
                        tooltip: "Edit Project",
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                        onPressed: onDelete,
                        tooltip: "Delete Project",
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
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.blueGrey),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade800),
          ),
        ],
      ),
    );
  }
}