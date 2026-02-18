import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jeetendra_portfolio/admin/projects/model/project_model.dart';
import 'package:jeetendra_portfolio/admin/projects/repository/project_repository.dart';

final projectRepositoryProvider = Provider((ref) => ProjectRepository());

final projectStreamProvider = StreamProvider<List<ProjectModel>>((ref) => ref.read(projectRepositoryProvider).getProjects());