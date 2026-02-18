import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jeetendra_portfolio/admin/projects/provider/project_provider.dart';
import 'package:jeetendra_portfolio/admin/projects/ui/project_dialog.dart';
import 'package:jeetendra_portfolio/admin/projects/ui/project_tile.dart';

class ProjectManager extends ConsumerWidget {
  const ProjectManager({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectStreamProvider);
    final repo = ref.read(projectRepositoryProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ---------------- HEADER ----------------
        Row(
          children: [
            const Text(
              "Projects",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "Add Project",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
              ),
              onPressed: () => showDialog(
                context: context,
                builder: (_) => ProjectDialog(
                  onSave: repo.addProject,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        /// ---------------- LIST ----------------
        Expanded(
          child: projectsAsync.when(
            data: (projects) {
              if (projects.isEmpty) {
                return const Center(
                  child: Text(
                    "No projects added yet.",
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              return ListView.builder(
                itemCount: projects.length,
                itemBuilder: (_, i) => ProjectTile(
                  project: projects[i],

                  /// -------- EDIT --------
                  onEdit: () => showDialog(
                    context: context,
                    builder: (_) => ProjectDialog(
                      project: projects[i],
                      onSave: repo.updateProject,
                    ),
                  ),

                  /// -------- DELETE --------
                  onDelete: () => showDialog(
                    context: context,
                    builder: (_) => ProjectDeleteDialog(
                      projectName: projects[i].title,
                      onConfirm: () =>
                          repo.deleteProject(projects[i].id),
                    ),
                  ),
                ),
              );
            },

            loading: () =>
            const Center(child: CircularProgressIndicator()),

            error: (e, _) =>
                Center(child: Text("Error: ${e.toString()}")),
          ),
        ),
      ],
    );
  }
}
