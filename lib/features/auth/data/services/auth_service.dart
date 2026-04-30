import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escoge/features/auth/domain/app_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentFirebaseUser => _auth.currentUser;

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    await _ensureUserDocument(
      user: credential.user,
      provider: 'password',
    );

    return credential;
  }

  Future<UserCredential> register({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    await _ensureUserDocument(
      user: credential.user,
      provider: 'password',
    );

    return credential;
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      await _googleSignIn.initialize();

      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final String? idToken = googleAuth.idToken;

      if (idToken == null || idToken.trim().isEmpty) {
        throw FirebaseAuthException(
          code: 'missing-google-id-token',
          message:
              'Google no devolvió un token válido. Revisa la configuración de GoogleService-Info.plist y Firebase.',
        );
      }

      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      await _ensureUserDocument(
        user: userCredential.user,
        provider: 'google.com',
      );

      return userCredential;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'google-sign-in-failed',
        message: 'No se pudo iniciar sesión con Google. Detalle: $e',
      );
    }
  }

  Future<void> signOut() async {
    final currentUser = _auth.currentUser;
    final providerIds = currentUser?.providerData
            .map((provider) => provider.providerId)
            .toSet() ??
        {};

    try {
      if (providerIds.contains('google.com')) {
        try {
          await _googleSignIn.initialize();
        } catch (_) {}

        try {
          await _googleSignIn.signOut();
        } catch (_) {}

        try {
          await _googleSignIn.disconnect();
        } catch (_) {}
      }

      await _auth.signOut();
    } catch (e) {
      throw FirebaseAuthException(
        code: 'sign-out-failed',
        message: 'No se pudo cerrar la sesión correctamente: $e',
      );
    }
  }

  Future<AppUserModel?> getCurrentAppUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('usuarios').doc(user.uid).get();

    if (!doc.exists || doc.data() == null) return null;

    return AppUserModel.fromMap(doc.id, doc.data()!);
  }

  Future<void> _ensureUserDocument({
    required User? user,
    required String provider,
  }) async {
    if (user == null) {
      throw FirebaseAuthException(
        code: 'missing-user',
        message: 'No se encontró el usuario autenticado.',
      );
    }

    final docRef = _firestore.collection('usuarios').doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set(
        {
          'uid': user.uid,
          'nombre': user.displayName ?? '',
          'email': user.email ?? '',
          'telefono': '',
          'edad': null,
          'sexo': '',
          'diocesisId': '',
          'diocesisNombre': '',
          'role': 'joven',
          'isActive': true,
          'onboardingCompleted': true,
          'profileCompleted': false,
          'accountStatus': 'active',
          'provider': provider,
          'photoUrl': user.photoURL ?? '',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
      return;
    }

    final data = doc.data() ?? {};
    final currentName = (data['nombre'] ?? '').toString().trim();

    await docRef.set(
      {
        'nombre': currentName.isEmpty ? (user.displayName ?? '') : currentName,
        'email': user.email ?? '',
        'provider': provider,
        'photoUrl': user.photoURL ?? '',
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }
}
