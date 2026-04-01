import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DiocesisService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> obtenerDiocesis() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot;

      try {
        snapshot =
            await _firestore.collection('diocesis').orderBy('orden').get();
      } catch (e) {
        debugPrint(
          'No se pudo ordenar por "orden". Se intentará cargar sin orderBy.',
        );

        snapshot = await _firestore.collection('diocesis').get();
      }

      final items = snapshot.docs.map((doc) {
        final data = doc.data();

        return <String, dynamic>{
          'id': doc.id,
          'nombre': (data['nombre'] ?? '').toString(),
          'activo': data['activo'] == true,
          'orden': data['orden'] is num ? (data['orden'] as num).toInt() : 9999,
        };
      }).toList();

      final activas = items.where((item) => item['activo'] == true).toList()
        ..sort((a, b) {
          final ordenA = a['orden'] as int;
          final ordenB = b['orden'] as int;
          return ordenA.compareTo(ordenB);
        });

      final resultado = activas
          .map(
            (item) => <String, dynamic>{
              'id': item['id'],
              'nombre': item['nombre'],
            },
          )
          .toList();

      debugPrint('=== DIOCESIS CARGADAS ===');
      debugPrint(resultado.toString());

      return resultado;
    } on FirebaseException catch (e) {
      debugPrint('=== FIREBASE ERROR DIOCESIS ===');
      debugPrint('code: ${e.code}');
      debugPrint('message: ${e.message}');
      throw Exception(
        e.message ?? 'No se pudieron cargar las diócesis desde Firestore.',
      );
    } catch (e) {
      debugPrint('=== ERROR INESPERADO DIOCESIS ===');
      debugPrint(e.toString());
      throw Exception('Error inesperado al cargar diócesis: $e');
    }
  }
}
