import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jeetendra_portfolio/admin/projects/model/project_model.dart';

class ProjectRepository {
  final CollectionReference<Map<String, dynamic>> _collection =
  FirebaseFirestore.instance.collection('projects');

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
    await _collection.add({
      ...project.toMap(),
      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": null,
    });
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
