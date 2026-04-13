import 'package:cloud_firestore/cloud_firestore.dart';

class PeticionModel {
  const PeticionModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.texto,
    required this.categoria,
    required this.tipoVisibilidad,
    required this.isAnonymous,
    required this.status,
    required this.unidosCount,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String userId;
  final String userName;
  final String texto;
  final String categoria;
  final String tipoVisibilidad; // publica | anonima
  final bool isAnonymous;
  final String status; // publicada
  final int unidosCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get esPublica => tipoVisibilidad == 'publica' && !isAnonymous;
  bool get esAnonima => tipoVisibilidad == 'anonima' || isAnonymous;

  String get nombreVisible {
    if (esAnonima) return 'Petición anónima';
    if (userName.trim().isEmpty) return 'Usuario';
    return userName.trim();
  }

  factory PeticionModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      return null;
    }

    int parseInt(dynamic value) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      return 0;
    }

    final tipoVisibilidad =
        (map['tipoVisibilidad'] ?? 'publica').toString().trim().toLowerCase();

    final isAnonymous = map['isAnonymous'] is bool
        ? map['isAnonymous'] as bool
        : tipoVisibilidad == 'anonima';

    final status =
        (map['status'] ?? 'publicada').toString().trim().toLowerCase();

    return PeticionModel(
      id: id,
      userId: (map['userId'] ?? '').toString().trim(),
      userName: (map['userName'] ?? '').toString().trim(),
      texto: (map['texto'] ?? '').toString().trim(),
      categoria: (map['categoria'] ?? 'Otra').toString().trim(),
      tipoVisibilidad: tipoVisibilidad.isEmpty ? 'publica' : tipoVisibilidad,
      isAnonymous: isAnonymous,
      status: status.isEmpty ? 'publicada' : status,
      unidosCount: parseInt(map['unidosCount']),
      createdAt: parseDate(map['createdAt']),
      updatedAt: parseDate(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'texto': texto,
      'categoria': categoria,
      'tipoVisibilidad': tipoVisibilidad,
      'isAnonymous': isAnonymous,
      'status': status,
      'unidosCount': unidosCount,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': updatedAt != null
          ? Timestamp.fromDate(updatedAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  PeticionModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? texto,
    String? categoria,
    String? tipoVisibilidad,
    bool? isAnonymous,
    String? status,
    int? unidosCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PeticionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      texto: texto ?? this.texto,
      categoria: categoria ?? this.categoria,
      tipoVisibilidad: tipoVisibilidad ?? this.tipoVisibilidad,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      status: status ?? this.status,
      unidosCount: unidosCount ?? this.unidosCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
