import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRoleService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getCurrentUserRole() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('usuarios').doc(user.uid).get();
    final data = doc.data();

    if (data == null) return null;

    return data['role']?.toString();
  }

  Stream<String?> currentUserRoleStream() {
    final user = _auth.currentUser;
    if (user == null) {
      return const Stream<String?>.empty();
    }

    return _firestore
        .collection('usuarios')
        .doc(user.uid)
        .snapshots()
        .map((doc) => doc.data()?['role']?.toString());
  }
}
