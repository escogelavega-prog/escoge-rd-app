import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escoge/features/auth/domain/app_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

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

    final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
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
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _auth.signOut();
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
