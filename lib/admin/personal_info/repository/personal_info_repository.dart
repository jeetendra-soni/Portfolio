import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/personal_info_model.dart';

class PersonalInfoRepository {
  final _doc =
  FirebaseFirestore.instance.collection('personal_info').doc('main');

  /// Fetches info once (Future) - Better for performance if real-time updates aren't needed.
  Future<PersonalInfoModel?> getInfoOnce() async {
    try {
      final doc = await _doc.get();
      if (!doc.exists) return null;
      debugPrint("User Info Fetched Once: ${doc.data().toString()}");
      return PersonalInfoModel.fromDocument(doc);
    } catch (e) {
      debugPrint("User Info Fetch Error: $e");
      return null;
    }
  }

  /// Original stream method (optional, kept for compatibility)
  Stream<PersonalInfoModel?> getInfoStream() {
    return _doc.snapshots().map((doc) {
      if (!doc.exists) return null;
      return PersonalInfoModel.fromDocument(doc);
    });
  }

  Future<void> saveInfo(PersonalInfoModel info) async {
    await _doc.set(info.toMap(), SetOptions(merge: true));
  }
}