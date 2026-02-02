import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/skill_model.dart';

class SkillRepository {
  final _ref = FirebaseFirestore.instance
      .collection('skills')
      .orderBy('order');

  Stream<List<SkillModel>> getSkills() {
    return _ref.snapshots().map(
          (snapshot) => snapshot.docs
          .map((doc) => SkillModel.fromDoc(doc))
          .toList(),
    );
  }

  Future<void> addSkill(SkillModel skill) async {
    await FirebaseFirestore.instance.collection('skills').add({
      ...skill.toMap(),
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateSkill(SkillModel skill) async {
    await FirebaseFirestore.instance
        .collection('skills')
        .doc(skill.id)
        .update(skill.toMap());
  }

  Future<void> deleteSkill(String id) async {
    await FirebaseFirestore.instance
        .collection('skills')
        .doc(id)
        .delete();
  }
}
