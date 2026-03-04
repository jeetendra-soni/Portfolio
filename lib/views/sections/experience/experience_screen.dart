import 'package:flutter/material.dart';
import 'package:jeetendra_portfolio/admin/experience/repository/exp_repository.dart';
import 'package:jeetendra_portfolio/utils/utils.dart';
import 'package:jeetendra_portfolio/views/sections/experience/experience_card.dart';
import 'package:jeetendra_portfolio/admin/experience/model/experience_model.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = ExperienceRepository();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Professional Experience'),
        const SizedBox(height: 50),

        StreamBuilder<List<ExperienceModel>>(
          stream: repo.getExperiences(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }

            final experiences = snapshot.data ?? [];

            if (experiences.isEmpty) {
              return const Text("No experience added yet.");
            }

              return ListView.builder(
                itemCount: experiences.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index){
                  return ExperienceCard(
                    index: index,
                    exe: experiences[index],
                  );
                },
            );
          },
        ),
      ],
    );
  }
}