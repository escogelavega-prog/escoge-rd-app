class AppRoles {
  /// 🔹 Roles oficiales del sistema
  static const String joven = 'joven';
  static const String diocesano = 'diocesano';
  static const String nacional = 'nacional';
  static const String superadmin = 'superadmin';

  /// 🔹 Lista completa de roles válidos
  static const List<String> all = [
    joven,
    diocesano,
    nacional,
    superadmin,
  ];

  /// 🔹 Verifica si un rol es válido
  static bool isValid(String? role) {
    if (role == null) return false;
    return all.contains(role);
  }

  /// 🔹 Jerarquía de roles (nivel de acceso)
  /// Mayor número = mayor privilegio
  static int level(String role) {
    switch (role) {
      case superadmin:
        return 4;
      case nacional:
        return 3;
      case diocesano:
        return 2;
      case joven:
      default:
        return 1;
    }
  }

  /// 🔹 Permite verificar acceso por jerarquía
  /// Ej: nacional puede acceder a cosas de diocesano
  static bool hasAccess({
    required String userRole,
    required String requiredRole,
  }) {
    return level(userRole) >= level(requiredRole);
  }

  /// 🔹 Etiqueta amigable para UI
  static String label(String role) {
    switch (role) {
      case superadmin:
        return 'Super Administrador';
      case nacional:
        return 'Equipo Nacional';
      case diocesano:
        return 'Equipo Diocesano';
      case joven:
      default:
        return 'Joven';
    }
  }
}
