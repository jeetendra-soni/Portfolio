import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jeetendra_portfolio/admin/projects/provider/project_provider.dart';
import 'package:jeetendra_portfolio/utils/utils.dart';
import 'package:jeetendra_portfolio/views/sections/project%20/view/project_card.dart';

class ProjectsSection extends ConsumerWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final asyncProjects = ref.watch(projectStreamProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Projects'),
        const SizedBox(height: 40),
        asyncProjects.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (e, _) => const Center(
            child: Text("Something went wrong."),
          ),
          data: (projects) {

            final width = MediaQuery.of(context).size.width;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: projects.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: width < 700 ? 1 : width < 1100 ? 2: 3,
                crossAxisSpacing: 32,
                mainAxisSpacing: 32,
                childAspectRatio: width < 700 ? .60 : width < 1100 ? .50 : 3.78,
              ),
              itemBuilder: (context, index) {
                return ProjectCard(project: projects[index]);
              },
            );
          },
        ),
      ],
    );
  }
}
