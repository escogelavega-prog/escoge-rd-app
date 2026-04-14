import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escoge/features/peticiones/data/models/peticion_model.dart';

class PeticionesService {
  PeticionesService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const String _peticionesCollection = 'peticiones';
  static const String _usuariosCollection = 'usuarios';

  Stream<List<PeticionModel>> getPeticionesPublicadas() {
    return _firestore
        .collection(_peticionesCollection)
        .where('status', isEqualTo: 'publicada')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => PeticionModel.fromMap(
                  doc.id,
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  Future<void> crearPeticion({
    required String userId,
    required String userName,
    required String texto,
    required String categoria,
    required String tipoVisibilidad,
    required bool isAnonymous,
  }) async {
    final peticionRef = _firestore.collection(_peticionesCollection).doc();

    await peticionRef.set({
      'userId': userId,
      'userName': userName.trim(),
      'texto': texto.trim(),
      'categoria': categoria.trim(),
      'tipoVisibilidad': tipoVisibilidad,
      'isAnonymous': isAnonymous,
      'status': 'publicada',
      'unidosCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> unirseAOracion({
    required String peticionId,
    required String userId,
  }) async {
    final peticionRef =
        _firestore.collection(_peticionesCollection).doc(peticionId);
    final unidoRef = peticionRef.collection('unidos').doc(userId);
    final userRef = _firestore.collection(_usuariosCollection).doc(userId);

    await _firestore.runTransaction((transaction) async {
      final unidoSnap = await transaction.get(unidoRef);

      if (unidoSnap.exists) {
        return;
      }

      final userSnap = await transaction.get(userRef);
      final userData = userSnap.data() ?? <String, dynamic>{};

      final hoy = _soloFecha(DateTime.now());

      final ultimaOracionRaw = userData['ultimaOracionFecha'];
      final ultimaOracionFecha = ultimaOracionRaw is Timestamp
          ? _soloFecha(ultimaOracionRaw.toDate())
          : null;

      final rachaActual = _safeInt(userData['rachaOracionDias']);
      final nuevaRacha = _calcularNuevaRacha(
        hoy: hoy,
        ultimaOracionFecha: ultimaOracionFecha,
        rachaActual: rachaActual,
      );

      transaction.set(unidoRef, {
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      transaction.update(peticionRef, {
        'unidosCount': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      transaction.set(
        userRef,
        {
          'oracionesCount': FieldValue.increment(1),
          'rachaOracionDias': nuevaRacha,
          'ultimaOracionFecha': Timestamp.fromDate(hoy),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    });
  }

  Future<bool> yaSeUnio({
    required String peticionId,
    required String userId,
  }) async {
    final doc = await _firestore
        .collection(_peticionesCollection)
        .doc(peticionId)
        .collection('unidos')
        .doc(userId)
        .get();

    return doc.exists;
  }

  Future<void> repararConteoOracionesUsuario(String userId) async {
    final peticionesSnapshot = await _firestore
        .collection(_peticionesCollection)
        .where('status', isEqualTo: 'publicada')
        .get();

    int totalUniones = 0;
    DateTime? ultimaFechaDetectada;

    for (final peticionDoc in peticionesSnapshot.docs) {
      final unidoDoc =
          await peticionDoc.reference.collection('unidos').doc(userId).get();

      if (unidoDoc.exists) {
        totalUniones++;

        final data = unidoDoc.data();
        final createdAt = data?['createdAt'];

        if (createdAt is Timestamp) {
          final fecha = _soloFecha(createdAt.toDate());

          if (ultimaFechaDetectada == null ||
              fecha.isAfter(ultimaFechaDetectada)) {
            ultimaFechaDetectada = fecha;
          }
        }
      }
    }

    await _firestore.collection(_usuariosCollection).doc(userId).set(
      {
        'oracionesCount': totalUniones,
        if (ultimaFechaDetectada != null)
          'ultimaOracionFecha': Timestamp.fromDate(ultimaFechaDetectada),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  int _calcularNuevaRacha({
    required DateTime hoy,
    required DateTime? ultimaOracionFecha,
    required int rachaActual,
  }) {
    if (ultimaOracionFecha == null) {
      return 1;
    }

    final diferencia = hoy.difference(ultimaOracionFecha).inDays;

    if (diferencia <= 0) {
      return rachaActual > 0 ? rachaActual : 1;
    }

    if (diferencia == 1) {
      final base = rachaActual > 0 ? rachaActual : 1;
      return base + 1;
    }

    return 1;
  }

  DateTime _soloFecha(DateTime fecha) {
    return DateTime(fecha.year, fecha.month, fecha.day);
  }

  int _safeInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return 0;
  }
}
