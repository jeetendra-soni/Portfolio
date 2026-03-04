import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ContactService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- CONFIG ---
  // Using EmailJS (free and standard for static/Flutter portfolios)
  static const String _serviceId = 'service_fcjd7m9'; // Replace with your EmailJS service ID
  static const String _templateId = 'template_q79npla'; // Replace with your EmailJS template ID
  static const String _userId = 'w2zAardKy0kEIxu-Q'; // Replace with your EmailJS public key

  Future<void> saveAndSendQuery({
    required String name,
    required String email,
    required String message,
  }) async {
    try {
      // 1. Save to Firebase Collection
      await _firestore.collection('contact_queries').add({
        'name': name,
        'email': email,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'new',
      });

      // // 2. Send Email via EmailJS API
      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'service_id': _serviceId,
          'template_id': _templateId,
          'user_id': _userId,
          'template_params': {
            'from_name': name,
            'from_email': email,
            'message': message,
            'to_email': 'dev.jeetendra1503@gmail.com',
          }
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send email: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error saving and sending query: $e');
      rethrow;
    }
  }
}