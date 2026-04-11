import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escoge/features/oracion/data/models/liturgia_day_model.dart';
import 'package:escoge/features/oracion/data/repositories/liturgia_repository.dart';

class LiturgiaService implements LiturgiaRepository {
  LiturgiaService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const String _collection = 'liturgia_diaria';

  @override
  Future<LiturgiaDayModel?> getTodayLiturgia() async {
    final now = DateTime.now();
    return getLiturgiaByDate(now);
  }

  @override
  Future<LiturgiaDayModel?> getLiturgiaByDate(DateTime date) async {
    try {
      final docId = _buildDocId(date);

      final doc = await _firestore.collection(_collection).doc(docId).get();

      if (!doc.exists || doc.data() == null) {
        return null;
      }

      final data = doc.data()!;
      return LiturgiaDayModel.fromMap(doc.id, data);
    } catch (e) {
      throw Exception('Error al obtener la liturgia del día: $e');
    }
  }

  String _buildDocId(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
