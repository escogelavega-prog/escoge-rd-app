class AppUserModel {
  final String uid;
  final String nombre;
  final String email;
  final String rol;
  final String? diocesisId;
  final bool activo;

  const AppUserModel({
    required this.uid,
    required this.nombre,
    required this.email,
    required this.rol,
    required this.diocesisId,
    required this.activo,
  });

  factory AppUserModel.fromMap(String uid, Map<String, dynamic> map) {
    return AppUserModel(
      uid: uid,
      nombre: map['nombre'] ?? '',
      email: map['email'] ?? '',
      rol: map['rol'] ?? 'usuario',
      diocesisId: map['diocesisId'],
      activo: map['activo'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'email': email,
      'rol': rol,
      'diocesisId': diocesisId,
      'activo': activo,
    };
  }
}