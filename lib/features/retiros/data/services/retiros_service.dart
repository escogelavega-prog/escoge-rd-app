import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escoge/core/constants/firebase_collections.dart';
import 'package:escoge/features/auth/domain/app_roles.dart';
import 'package:escoge/features/retiros/data/models/retiro_item_model.dart';

class RetirosService {
  RetirosService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _retirosRef =>
      _firestore.collection(FirebaseCollections.retiros);

  // =========================
  // MAPEO
  // =========================

  RetiroItemModel _mapDocToRetiro(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};

    final recomendaciones = (data['recomendaciones'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList();

    final imagePath = _readString(
      data,
      ['imagenUrl', 'imageUrl', 'imagePath', 'portada', 'bannerUrl'],
      fallback: 'assets/images/retiro_default.png',
    );

    return RetiroItemModel(
      id: doc.id,
      titulo: _readString(
        data,
        ['titulo', 'nombre'],
        fallback: 'Retiro espiritual',
      ),
      descripcion: _readString(
        data,
        ['descripcion', 'detalle', 'resumen'],
        fallback: 'Próximamente más información sobre este retiro.',
      ),
      ciudad: _readString(
        data,
        ['ciudad', 'ubicacionCiudad'],
        fallback: 'Ciudad por confirmar',
      ),
      lugar: _readString(
        data,
        ['lugar', 'ubicacion', 'casa_retiro'],
        fallback: 'Lugar por confirmar',
      ),
      fecha: _readString(
        data,
        ['fecha', 'fechaTexto', 'fecha_inicio'],
        fallback: 'Fecha por confirmar',
      ),
      diocesis: _readString(
        data,
        ['diocesisNombre', 'diocesis'],
        fallback: 'Diócesis por confirmar',
      ),
      categoria: _readString(
        data,
        ['categoria', 'subtitulo', 'tipoEvento'],
        fallback: 'Retiro',
      ),
      recomendaciones: recomendaciones,
      imagePath: imagePath,
      tipoFormulario: _readString(
        data,
        ['tipoFormulario'],
        fallback: 'general',
      ),
      destacado: data['destacado'] == true,
      activo: !_isFalse(data['activo']) && !_isEstadoOculto(data['estado']),
    );
  }

  // =========================
  // STREAM POR ROL
  // =========================

  Stream<List<RetiroItemModel>> escucharRetirosPorRol({
    required String role,
    String? diocesisId,
  }) {
    final normalizedRole = AppRoles.normalize(role);
    Query<Map<String, dynamic>> query = _retirosRef;

    // SUPERADMIN
    if (normalizedRole == AppRoles.superadmin) {
      return query.snapshots().map(_mapAndSort);
    }

    // NACIONAL
    if (normalizedRole == AppRoles.nacional) {
      return query.snapshots().map(
            (snapshot) => _mapAndSort(snapshot).where((e) => e.activo).toList(),
          );
    }

    // DIOCESANO
    if (normalizedRole == AppRoles.diocesano) {
      if (diocesisId == null || diocesisId.trim().isEmpty) {
        return Stream.value(<RetiroItemModel>[]);
      }

      query = query.where('diocesisId', isEqualTo: diocesisId.trim());

      return query.snapshots().map(
            (snapshot) => _mapAndSort(snapshot).where((e) => e.activo).toList(),
          );
    }

    // JOVEN / USUARIO NORMAL
    if (diocesisId != null && diocesisId.trim().isNotEmpty) {
      query = query.where('diocesisId', isEqualTo: diocesisId.trim());
    }

    return query.snapshots().map(
          (snapshot) => _mapAndSort(snapshot).where((e) => e.activo).toList(),
        );
  }

  // =========================
  // FUTURE POR ROL
  // =========================

  Future<List<RetiroItemModel>> obtenerRetirosPorRol({
    required String role,
    String? diocesisId,
  }) async {
    final normalizedRole = AppRoles.normalize(role);
    Query<Map<String, dynamic>> query = _retirosRef;

    if (normalizedRole == AppRoles.superadmin) {
      final snapshot = await query.get();
      return _mapAndSort(snapshot);
    }

    if (normalizedRole == AppRoles.nacional) {
      final snapshot = await query.get();
      return _mapAndSort(snapshot).where((e) => e.activo).toList();
    }

    if (normalizedRole == AppRoles.diocesano) {
      if (diocesisId == null || diocesisId.trim().isEmpty) {
        return <RetiroItemModel>[];
      }

      final snapshot =
          await query.where('diocesisId', isEqualTo: diocesisId.trim()).get();

      return _mapAndSort(snapshot).where((e) => e.activo).toList();
    }

    if (diocesisId != null && diocesisId.trim().isNotEmpty) {
      query = query.where('diocesisId', isEqualTo: diocesisId.trim());
    }

    final snapshot = await query.get();
    return _mapAndSort(snapshot).where((e) => e.activo).toList();
  }

  // =========================
  // DESTACADOS
  // =========================

  Future<List<RetiroItemModel>> obtenerRetirosDestacadosPorRol({
    required String role,
    String? diocesisId,
  }) async {
    final items = await obtenerRetirosPorRol(
      role: role,
      diocesisId: diocesisId,
    );

    return items.where((e) => e.destacado).take(5).toList();
  }

  Future<RetiroItemModel?> obtenerRetiroPrincipalPorRol({
    required String role,
    String? diocesisId,
  }) async {
    final items = await obtenerRetirosPorRol(
      role: role,
      diocesisId: diocesisId,
    );

    if (items.isEmpty) return null;

    final destacados = items.where((e) => e.destacado).toList();
    return destacados.isNotEmpty ? destacados.first : items.first;
  }

  // =========================
  // HELPERS
  // =========================

  List<RetiroItemModel> _mapAndSort(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    final items = snapshot.docs.map(_mapDocToRetiro).toList();

    items.sort((a, b) {
      if (a.destacado != b.destacado) return a.destacado ? -1 : 1;
      return a.titulo.toLowerCase().compareTo(b.titulo.toLowerCase());
    });

    return items;
  }

  String _readString(
    Map<String, dynamic> data,
    List<String> keys, {
    String fallback = '',
  }) {
    for (final key in keys) {
      final value = data[key];
      if (value == null) continue;

      final text = value.toString().trim();
      if (text.isNotEmpty) return text;
    }
    return fallback;
  }

  bool _isFalse(dynamic value) {
    return value == false || value.toString().toLowerCase().trim() == 'false';
  }

  bool _isEstadoOculto(dynamic value) {
    final text = value?.toString().toLowerCase().trim() ?? '';
    return text == 'oculto' || text == 'borrador' || text == 'inactivo';
  }
}
