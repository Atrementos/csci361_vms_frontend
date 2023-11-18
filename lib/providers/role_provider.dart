import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoleIdentifier {
  late Provider<String> roleProvider;

  void setRole(String role) {
    roleProvider = Provider((ref) => role);
  }
}

final userRole = RoleIdentifier();
