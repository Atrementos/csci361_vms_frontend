import 'package:flutter_riverpod/flutter_riverpod.dart';

class IdIdentifier {
  late Provider<int> vehicleIdProvider;

  void setId(int id) {
    vehicleIdProvider = Provider((ref) => id);
  }
}

final vehicleId = IdIdentifier();