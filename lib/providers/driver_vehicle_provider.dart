import 'package:flutter_riverpod/flutter_riverpod.dart';

class IdIdentifier {
  late Provider<int> vehicleIdProvider;

  void setId(int id) {
    vehicleIdProvider = Provider((ref) => id);
  }
}

class LocationIdentifier {
  late Provider<List<dynamic>> locationProvider;

  void setLocation(List<dynamic> location) {
    locationProvider = Provider((ref) => location);
  }
}

final vehicleId = IdIdentifier();
final locationId = LocationIdentifier();