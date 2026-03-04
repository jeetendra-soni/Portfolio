import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jeetendra_portfolio/admin/award_achievement/model/award_model.dart';
import 'package:jeetendra_portfolio/admin/award_achievement/repository/award_repository.dart';


final awardRepositoryProvider = Provider<AwardRepository>((ref) {
  return AwardRepository(FirebaseFirestore.instance);
});

final awardStreamProvider = StreamProvider<List<AwardModel>>((ref) {
  final repo = ref.read(awardRepositoryProvider);
  return repo.getAwardsStream();
});