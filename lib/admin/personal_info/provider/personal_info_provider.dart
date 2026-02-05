import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jeetendra_portfolio/admin/personal_info/model/personal_info_model.dart';
import 'package:jeetendra_portfolio/admin/personal_info/repository/personal_info_repository.dart';

final personalInfoRepositoryProvider =
Provider<PersonalInfoRepository>((ref) {
  return PersonalInfoRepository();
});

final personalInfoProvider =
StreamProvider<PersonalInfoModel?>((ref) {
  return ref.read(personalInfoRepositoryProvider).getInfo();
});
