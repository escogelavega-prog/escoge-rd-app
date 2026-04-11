class AppRoles {
  static const String joven = 'joven';
  static const String diocesano = 'diocesano';
  static const String nacional = 'nacional';
  static const String superadmin = 'superadmin';

  static const List<String> all = [
    joven,
    diocesano,
    nacional,
    superadmin,
  ];

  static bool isValid(String? role) {
    if (role == null) return false;
    return all.contains(role);
  }

  static String normalize(String? role) {
    if (role == null) return joven;
    return all.contains(role) ? role : joven;
  }

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

  static bool hasAccess({
    required String userRole,
    required String requiredRole,
  }) {
    return level(userRole) >= level(requiredRole);
  }

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
