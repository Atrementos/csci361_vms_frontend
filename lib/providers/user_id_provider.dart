import 'package:flutter_riverpod/flutter_riverpod.dart';

class IdIdentifier {
  late Provider<int> idProvider;

  void setId(int id) {
    idProvider = Provider((ref) => id);
  }
}

final userId = IdIdentifier();
