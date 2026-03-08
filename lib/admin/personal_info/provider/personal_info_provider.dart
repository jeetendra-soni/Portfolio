import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jeetendra_portfolio/admin/personal_info/model/personal_info_model.dart';
import 'package:jeetendra_portfolio/admin/personal_info/repository/personal_info_repository.dart';

final personalInfoRepositoryProvider =
Provider<PersonalInfoRepository>((ref) {
  return PersonalInfoRepository();
});

/// Fetches personal info once and caches it for the duration of the app session.
/// Using FutureProvider ensuring only one initial call.
final personalInfoProvider =
FutureProvider<PersonalInfoModel?>((ref) async {
  final repo = ref.read(personalInfoRepositoryProvider);
  return await repo.getInfoOnce();
});