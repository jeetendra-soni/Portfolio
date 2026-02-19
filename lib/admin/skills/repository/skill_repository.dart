import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jeetendra_portfolio/admin/skills/model/skill_model.dart';
import 'package:uuid/uuid.dart';

class SkillRepository {

  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

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

  /// Upload Icon to Firebase Storage
  Future<String> uploadSkillIcon(File file) async {
    final fileName = const Uuid().v4();
    final ref = _storage.ref().child('skill_icons/$fileName.png');

    await ref.putFile(file);

    final downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> uploadSkillIconWeb(Uint8List bytes) async {
    if (bytes.isEmpty) {
      throw Exception("Image bytes are empty");
    }

    final fileName = DateTime.now().millisecondsSinceEpoch.toString();

    final ref = FirebaseStorage.instance
        .ref()
        .child('skill_icons/$fileName.jpg');

    await ref.putData(
      bytes,
      SettableMetadata(
        contentType: 'image/jpeg', // 🔥 VERY IMPORTANT
      ),
    );

    return await ref.getDownloadURL();
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