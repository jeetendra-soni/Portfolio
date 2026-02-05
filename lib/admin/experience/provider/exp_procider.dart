import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jeetendra_portfolio/admin/experience/model/experience_model.dart';
import 'package:jeetendra_portfolio/admin/experience/repository/exp_repository.dart';

final experienceRepositoryProvider =
Provider<ExperienceRepository>((ref) {
  return ExperienceRepository();
});

final experienceStreamProvider =
StreamProvider<List<ExperienceModel>>((ref) {
  return ref.read(experienceRepositoryProvider).getExperiences();
});
