import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/personal_info_model.dart';

class PersonalInfoRepository {
  final _doc =
  FirebaseFirestore.instance.collection('personal_info').doc('main');

  Stream<PersonalInfoModel?> getInfo() {
    return _doc.snapshots().map((doc) {
      if (!doc.exists) return null;
      return PersonalInfoModel.fromDoc(doc);
    });
  }

  Future<void> saveInfo(PersonalInfoModel info) async {
    await _doc.set(info.toMap(), SetOptions(merge: true));
  }
}
