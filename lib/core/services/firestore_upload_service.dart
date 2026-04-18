import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escoge/core/constants/firebase_collections.dart';
import 'package:escoge/core/constants/firestore_fields.dart';
import 'package:escoge/core/models/storage_file_model.dart';

class FirestoreUploadService {
  FirestoreUploadService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<void> saveMultimediaFile({
    required String documentId,
    required String titulo,
    required String descripcion,
    required String tipo,
    required String categoria,
    required StorageFileModel file,
    String thumbnailUrl = '',
    int duracionSegundos = 0,
    int orden = 0,
    bool activo = true,
    bool publicado = true,
    DateTime? fechaPublicacion,
  }) async {
    await _firestore
        .collection(FirebaseCollections.multimedia)
        .doc(documentId)
        .set({
      FirestoreFields.titulo: titulo,
      FirestoreFields.descripcion: descripcion,
      FirestoreFields.tipo: tipo,
      FirestoreFields.categoria: categoria,
      FirestoreFields.storagePath: file.fullPath,
      FirestoreFields.downloadUrl: file.downloadUrl,
      FirestoreFields.thumbnailUrl: thumbnailUrl,
      FirestoreFields.duracionSegundos: duracionSegundos,
      FirestoreFields.orden: orden,
      FirestoreFields.activo: activo,
      FirestoreFields.publicado: publicado,
      'contentType': file.contentType,
      'size': file.size,
      'name': file.name,
      'fechaPublicacion': fechaPublicacion?.toIso8601String(),
      FirestoreFields.createdAt: DateTime.now().toIso8601String(),
      FirestoreFields.updatedAt: DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
  }

  Future<void> saveLiturgiaAudio({
    required DateTime fecha,
    required StorageFileModel file,
    int duracionSegundos = 0,
  }) async {
    final docId = _buildDateDocId(fecha);

    await _firestore
        .collection(FirebaseCollections.liturgiaDiaria)
        .doc(docId)
        .set({
      'audio': {
        'url': file.downloadUrl,
        'storagePath': file.fullPath,
        'duracionSegundos': duracionSegundos,
        'contentType': file.contentType,
        'size': file.size,
        'name': file.name,
      },
      FirestoreFields.updatedAt: DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
  }

  Future<void> saveSantoDelDiaImage({
    required DateTime fecha,
    required StorageFileModel file,
  }) async {
    final docId = _buildDateDocId(fecha);

    await _firestore
        .collection(FirebaseCollections.liturgiaDiaria)
        .doc(docId)
        .set({
      'santoDelDia': {
        'imagenUrl': file.downloadUrl,
        'storagePath': file.fullPath,
        'nombreArchivo': file.name,
      },
      FirestoreFields.updatedAt: DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
  }

  Future<void> saveGenericDocument({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection(collection).doc(documentId).set(
      {
        ...data,
        FirestoreFields.updatedAt: DateTime.now().toIso8601String(),
      },
      SetOptions(merge: true),
    );
  }

  String _buildDateDocId(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
