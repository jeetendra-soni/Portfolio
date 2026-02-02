import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/skill_repository.dart';
import '../model/skill_model.dart';

final skillRepositoryProvider =
Provider((ref) => SkillRepository());

final skillStreamProvider =
StreamProvider<List<SkillModel>>(
      (ref) => ref.read(skillRepositoryProvider).getSkills(),
);
