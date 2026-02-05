import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jeetendra_portfolio/admin/experience/model/experience_model.dart';

class ExperienceRepository {
  final _ref = FirebaseFirestore.instance
      .collection('experiences')
      .orderBy('order');

  Stream<List<ExperienceModel>> getExperiences() {
    return _ref.snapshots().map(
          (snapshot) => snapshot.docs
          .map((doc) => ExperienceModel.fromDoc(doc))
          .toList(),
    );
  }

  Future<void> addExperience(ExperienceModel experience) async {
    await FirebaseFirestore.instance.collection('experiences').add({
      ...experience.toMap(),
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateExperience(ExperienceModel experience) async {
    await FirebaseFirestore.instance
        .collection('experiences')
        .doc(experience.id)
        .update(experience.toMap());
  }

  Future<void> deleteExperience(String id) async {
    await FirebaseFirestore.instance
        .collection('experiences')
        .doc(id)
        .delete();
  }
}
