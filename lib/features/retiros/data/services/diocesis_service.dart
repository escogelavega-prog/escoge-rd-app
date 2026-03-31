import 'package:cloud_firestore/cloud_firestore.dart';

class DiocesisService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> obtenerDiocesis() async {
    final snapshot =
        await _firestore.collection('diocesis').orderBy('orden').get();

    return snapshot.docs
        .map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            'nombre': data['nombre'] ?? '',
            'activo': data['activo'] ?? false,
          };
        })
        .where((item) => item['activo'] == true)
        .map((item) => {
              'id': item['id'],
              'nombre': item['nombre'],
            })
        .toList();
  }
}
