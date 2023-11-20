import 'package:flutter_riverpod/flutter_riverpod.dart';

final jwt = JwtToken();

class JwtToken {
  late Provider<String> jwtTokenProvider;

  void setJwtToken(String jwt) {
    jwtTokenProvider = Provider((ref) => jwt);
  }
}
