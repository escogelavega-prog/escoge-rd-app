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
      email: email,
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
      email: email,
      password: password,
    );

    await _ensureUserDocument(
      user: credential.user,
      provider: 'password',
    );

    return credential;
  }

  Future<UserCredential> signInWithGoogle() async {
    await _googleSignIn.initialize();

    final GoogleSignInAccount googleUser;
    try {
      googleUser = await _googleSignIn.authenticate();
    } catch (_) {
      throw Exception('Inicio de sesión con Google cancelado o fallido.');
    }

    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);

    await _ensureUserDocument(
      user: userCredential.user,
      provider: 'google.com',
    );

    return userCredential;
  }

  Future<void> signOut() async {
    final currentUser = _auth.currentUser;
    final providerIds =
        currentUser?.providerData.map((e) => e.providerId).toSet() ?? {};

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
      throw Exception('No se pudo cerrar la sesión correctamente: $e');
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
      throw Exception('No se encontró el usuario autenticado.');
    }

    final docRef = _firestore.collection('usuarios').doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
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
      }, SetOptions(merge: true));
    } else {
      final data = doc.data() ?? {};

      await docRef.set({
        'nombre': ((data['nombre'] ?? '').toString().trim().isEmpty)
            ? (user.displayName ?? '')
            : data['nombre'],
        'email': user.email ?? '',
        'provider': provider,
        'photoUrl': user.photoURL ?? '',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }
}
