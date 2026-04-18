import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escoge/core/constants/firebase_collections.dart';
import 'package:escoge/features/oracion/data/models/versiculo_del_dia_model.dart';

class VersiculoDiaService {
  VersiculoDiaService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _liturgiaRef =>
      _firestore.collection(FirebaseCollections.liturgiaDiaria);

  Future<VersiculoDelDiaModel?> getTodayVersiculo() async {
    return getVersiculoByDate(DateTime.now());
  }

  Future<VersiculoDelDiaModel?> getVersiculoByDate(DateTime date) async {
    final docId = _buildDateDocId(date);

    final doc = await _liturgiaRef.doc(docId).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    final data = doc.data()!;
    final versiculoMap = data['versiculoDelDia'];

    if (versiculoMap is Map<String, dynamic>) {
      return VersiculoDelDiaModel.fromMap(versiculoMap);
    }

    if (versiculoMap is Map) {
      return VersiculoDelDiaModel.fromMap(
        versiculoMap.map((key, value) => MapEntry(key.toString(), value)),
      );
    }

    return null;
  }

  Stream<VersiculoDelDiaModel?> watchVersiculoByDate(DateTime date) {
    final docId = _buildDateDocId(date);

    return _liturgiaRef.doc(docId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) {
        return null;
      }

      final versiculoMap = doc.data()!['versiculoDelDia'];

      if (versiculoMap is Map<String, dynamic>) {
        return VersiculoDelDiaModel.fromMap(versiculoMap);
      }

      if (versiculoMap is Map) {
        return VersiculoDelDiaModel.fromMap(
          versiculoMap.map((key, value) => MapEntry(key.toString(), value)),
        );
      }

      return null;
    });
  }

  String _buildDateDocId(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
