import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jeetendra_portfolio/constants/enums.dart';
import 'package:jeetendra_portfolio/controllers/auth_controller/auth_stats.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(),
);

class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(const AuthState());

  final _auth = FirebaseAuth.instance;
  bool loading = false;
  static const adminEmail = "admin.jeetendra@gmail.com";

  Future<User?> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);

    try {
      final res = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (res.user?.email != adminEmail) {
        await _auth.signOut();
        throw FirebaseAuthException(
          code: 'not-admin',
          message: 'Unauthorized',
        );
      }

      state = state.copyWith(status: AuthStatus.success);
      return res.user;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        error: _mapError(e.code),
      );
      return null;
    }
  }

  String _mapError(String code) {
    switch (code) {
      case 'user-not-found':
        return "Admin account not found";
      case 'wrong-password':
        return "Incorrect password";
      case 'invalid-email':
        return "Invalid email";
      case 'not-admin':
        return "You are not authorized";
      default:
        return "Login failed";
    }
  }
}
