class AppUserModel {
  final String uid;
  final String nombre;
  final String email;

  /// Nuevo nombre oficial
  final String role;

  /// Alias legacy para no romper código viejo
  String get rol => role;

  final String diocesisId;

  /// Nuevo nombre oficial
  final bool isActive;

  /// Alias legacy para no romper código viejo
  bool get activo => isActive;

  const AppUserModel({
    required this.uid,
    required this.nombre,
    required this.email,
    required this.role,
    required this.diocesisId,
    required this.isActive,
  });

  factory AppUserModel.fromMap(String uid, Map<String, dynamic> map) {
    final rawRole = (map['role'] ?? map['rol'] ?? 'joven').toString().trim();

    String normalizedRole;
    switch (rawRole) {
      case 'superadmin':
      case 'nacional':
      case 'diocesano':
      case 'joven':
        normalizedRole = rawRole;
        break;
      case 'usuario':
        normalizedRole = 'joven';
        break;
      default:
        normalizedRole = 'joven';
    }

    return AppUserModel(
      uid: uid,
      nombre: (map['nombre'] ?? '').toString(),
      email: (map['email'] ?? '').toString(),
      role: normalizedRole,
      diocesisId: (map['diocesisId'] ?? '').toString(),
      isActive: map['isActive'] ?? map['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'nombre': nombre,
      'email': email,

      // Nuevo formato oficial
      'role': role,
      'isActive': isActive,

      // Compatibilidad legacy temporal
      'rol': role,
      'activo': isActive,

      'diocesisId': diocesisId,
    };
  }
}
