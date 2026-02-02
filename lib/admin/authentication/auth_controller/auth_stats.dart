import 'package:jeetendra_portfolio/constants/enums.dart';

class AuthState {
  final AuthStatus status;
  final String? error;

  const AuthState({
    this.status = AuthStatus.idle,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      error: error,
    );
  }
}
