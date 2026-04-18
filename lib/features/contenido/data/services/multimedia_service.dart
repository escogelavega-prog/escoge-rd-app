import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escoge/core/constants/firebase_collections.dart';

import '../models/multimedia_item_model.dart';

class MultimediaService {
  MultimediaService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _multimediaRef =>
      _firestore.collection(FirebaseCollections.multimedia);

  Future<List<MultimediaItemModel>> getPublishedMultimedia() async {
    final query = await _multimediaRef
        .where('activo', isEqualTo: true)
        .where('publicado', isEqualTo: true)
        .orderBy('orden')
        .get();

    return query.docs
        .map((doc) => MultimediaItemModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<List<MultimediaItemModel>> getPublishedByCategory(
    String categoria,
  ) async {
    final query = await _multimediaRef
        .where('activo', isEqualTo: true)
        .where('publicado', isEqualTo: true)
        .where('categoria', isEqualTo: categoria)
        .orderBy('orden')
        .get();

    return query.docs
        .map((doc) => MultimediaItemModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<List<MultimediaItemModel>> getPublishedByType(
    String tipo,
  ) async {
    final query = await _multimediaRef
        .where('activo', isEqualTo: true)
        .where('publicado', isEqualTo: true)
        .where('tipo', isEqualTo: tipo)
        .orderBy('orden')
        .get();

    return query.docs
        .map((doc) => MultimediaItemModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<MultimediaItemModel?> getById(String id) async {
    final doc = await _multimediaRef.doc(id).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return MultimediaItemModel.fromMap(doc.id, doc.data()!);
  }

  Stream<List<MultimediaItemModel>> watchPublishedMultimedia() {
    return _multimediaRef
        .where('activo', isEqualTo: true)
        .where('publicado', isEqualTo: true)
        .orderBy('orden')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MultimediaItemModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }
}
