import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:jeetendra_portfolio/admin/projects/model/project_model.dart';

class ProjectRepository {
  final CollectionReference<Map<String, dynamic>> _collection =
  FirebaseFirestore.instance.collection('projects');
  final _storage = FirebaseStorage.instance;

  Future<String?> uploadToFirebase(
      Uint8List bytes,
      String folder,
      ) async {
    final fileName =
        "${DateTime.now().millisecondsSinceEpoch}.png";

    final ref = _storage
        .ref()
        .child("projects/$folder/$fileName");

    final uploadTask = await ref.putData(bytes);
    return await uploadTask.ref.getDownloadURL();
  }

  /// ---------------- GET PROJECTS ----------------
  Stream<List<ProjectModel>> getProjects() {
    return _collection
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => ProjectModel.fromMap(
          doc.data(),
          doc.id,
        ),
      ).toList(),
    );
  }

  /// ---------------- GET FEATURED PROJECTS ----------------
  Stream<List<ProjectModel>> getFeaturedProjects() {
    return _collection
        .where('featured', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => ProjectModel.fromMap(
          doc.data(),
          doc.id,
        ),
      )
          .toList(),
    );
  }

  /// ---------------- ADD PROJECT ----------------
  Future<void> addProject(ProjectModel project) async {
    try{
      await _collection.add({
        ...project.toMap(),
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      });
    }catch(e){
      debugPrint("Failed to add project : $e");
    }

  }

  /// ---------------- UPDATE PROJECT ----------------
  Future<void> updateProject(ProjectModel project) async {
    await _collection.doc(project.id).update({
      ...project.toMap(),
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  /// ---------------- DELETE PROJECT ----------------
  Future<void> deleteProject(String id) async {
    await _collection.doc(id).delete();
  }

  /// ---------------- TOGGLE FEATURED ----------------
  Future<void> toggleFeatured(String id, bool value) async {
    await _collection.doc(id).update({
      "featured": value,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

}