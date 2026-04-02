import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escoge/features/oracion/data/models/evangelio_model.dart';

class EvangelioService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<EvangelioModel?> obtenerHoy() async {
    try {
      final doc = await _db.collection('evangelio').doc('hoy').get();

      if (!doc.exists || doc.data() == null) {
        return null;
      }

      return EvangelioModel.fromMap(doc.data()!);
    } catch (e) {
      return null;
    }
  }
}
