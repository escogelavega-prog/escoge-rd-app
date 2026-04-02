import 'package:escoge/features/auth/data/services/auth_service.dart';
import 'package:escoge/features/auth/domain/app_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final AuthService service;

  AuthRepository(this.service);

  Stream<User?> authStateChanges() => service.authStateChanges();

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return service.signIn(email: email, password: password);
  }

  Future<UserCredential> register({
    required String email,
    required String password,
  }) {
    return service.register(email: email, password: password);
  }

  Future<void> signOut() => service.signOut();

  Future<AppUserModel?> getCurrentAppUser() => service.getCurrentAppUser();
}
