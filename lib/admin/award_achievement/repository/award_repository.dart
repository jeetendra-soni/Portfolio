import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jeetendra_portfolio/admin/award_achievement/model/award_model.dart';

class AwardRepository {
  final FirebaseFirestore _firestore;

  AwardRepository(this._firestore);

  Stream<List<AwardModel>> getAwardsStream() {
    return _firestore
        .collection("awards")
        .orderBy("order")
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => AwardModel.fromMap(doc.data(), doc.id))
        .toList());
  }

  Future<void> addAward(AwardModel award) async {
    await _firestore.collection("awards").add(award.toMap());
  }

  Future<void> updateAward(AwardModel award) async {
    await _firestore
        .collection("awards")
        .doc(award.id)
        .update(award.toMap());
  }

  Future<void> deleteAward(String id) async {
    await _firestore.collection("awards").doc(id).delete();
  }
}