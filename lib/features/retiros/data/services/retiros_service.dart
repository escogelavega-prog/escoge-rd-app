import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escoge/features/retiros/domain/retiro_item.dart';

class RetirosService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RetiroItem _mapDocToRetiro(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    print('----------------------------------------');
    print('Documento retiro ID: ${doc.id}');
    print('Data cruda: $data');

    final recomendaciones =
        (data['recomendaciones'] as List?)?.map((e) => e.toString()).toList() ??
            <String>[];

    final imagePath = _readString(
      data,
      ['imagenUrl', 'imageUrl', 'imagePath', 'portada', 'bannerUrl'],
      fallback: 'assets/images/retiro_default.png',
    );

    final item = RetiroItem(
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
        ['diocesis', 'diocesisNombre'],
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

    print('Mapeado retiro: ${item.titulo} | activo=${item.activo}');
    return item;
  }

  Future<List<RetiroItem>> obtenerRetirosActivos() async {
    final snapshot = await _firestore.collection('retiros').limit(100).get();

    print('Cantidad de documentos en retiros: ${snapshot.docs.length}');

    final items = snapshot.docs
        .map(_mapDocToRetiro)
        .where((item) => item.activo)
        .toList();

    print('Cantidad de retiros activos mapeados: ${items.length}');

    items.sort((a, b) {
      if (a.destacado != b.destacado) return a.destacado ? -1 : 1;
      return a.titulo.toLowerCase().compareTo(b.titulo.toLowerCase());
    });

    return items;
  }

  Stream<List<RetiroItem>> escucharRetirosActivos() {
    return _firestore.collection('retiros').snapshots().map((snapshot) {
      print('STREAM retiros -> documentos recibidos: ${snapshot.docs.length}');

      final items = snapshot.docs
          .map(_mapDocToRetiro)
          .where((item) => item.activo)
          .toList();

      print('STREAM retiros -> activos después de mapear: ${items.length}');

      items.sort((a, b) {
        if (a.destacado != b.destacado) return a.destacado ? -1 : 1;
        return a.titulo.toLowerCase().compareTo(b.titulo.toLowerCase());
      });

      return items;
    });
  }

  Future<List<RetiroItem>> obtenerRetirosDestacados() async {
    final items = await obtenerRetirosActivos();
    return items.where((e) => e.destacado).take(5).toList();
  }

  Future<RetiroItem?> obtenerRetiroPrincipal() async {
    final items = await obtenerRetirosActivos();
    if (items.isEmpty) return null;

    final destacados = items.where((e) => e.destacado).toList();
    return destacados.isNotEmpty ? destacados.first : items.first;
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
    return value == false || value.toString().toLowerCase() == 'false';
  }

  bool _isEstadoOculto(dynamic value) {
    final text = value?.toString().toLowerCase().trim() ?? '';
    return text == 'oculto' || text == 'borrador' || text == 'inactivo';
  }
}
