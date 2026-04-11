import 'package:escoge/features/auth/data/services/auth_service.dart';
import 'package:escoge/features/auth/domain/app_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final AuthService _service;

  AuthRepository(this._service);

  Stream<User?> authStateChanges() => _service.authStateChanges();

  User? get currentFirebaseUser => _service.currentFirebaseUser;

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return _service.signIn(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> register({
    required String email,
    required String password,
  }) {
    return _service.register(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signInWithGoogle() {
    return _service.signInWithGoogle();
  }

  Future<void> signOut() {
    return _service.signOut();
  }

  Future<AppUserModel?> getCurrentAppUser() {
    return _service.getCurrentAppUser();
  }
}
