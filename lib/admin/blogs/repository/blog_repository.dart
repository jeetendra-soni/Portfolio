import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../model/blog_model.dart';

class BlogRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String collectionPath = 'blogs';

  Stream<List<BlogModel>> getBlogs() {
    return _firestore
        .collection(collectionPath)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => BlogModel.fromFirestore(doc)).toList());
  }

  Future<void> addBlog(BlogModel blog) async {
    await _firestore.collection(collectionPath).add(blog.toFirestore());
  }

  Future<void> updateBlog(BlogModel blog) async {
    await _firestore
        .collection(collectionPath)
        .doc(blog.id)
        .update(blog.toFirestore());
  }

  Future<void> deleteBlog(String id) async {
    await _firestore.collection(collectionPath).doc(id).delete();
  }

  Future<String?> uploadBlogImage(Uint8List bytes, String fileName) async {
    try {
      Reference ref = _storage.ref().child('blog_images/$fileName');
      UploadTask uploadTask = ref.putData(bytes);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading blog image: $e');
      return null;
    }
  }
}