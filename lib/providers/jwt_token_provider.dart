import 'package:flutter_riverpod/flutter_riverpod.dart';

class JwtToken {
  late Provider<String> jwtTokenProvider;

  void setJwtToken(String jwt) {
    jwtTokenProvider = Provider((ref) => jwt);
  }
}

final jwt = JwtToken();
