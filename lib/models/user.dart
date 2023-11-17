import 'package:csci361_vms_frontend/models/vehicle.dart';

class User {
  final int govId;
  final String name;
  String? middleName;
  final String lastName;
  final String phoneNumber;
  final String role;
  final String email;
  final String password;

  User({
    required this.govId,
    required this.name,
    required this.lastName,
    required this.phoneNumber,
    required this.role,
    required this.email,
    required this.password,
  });
}

class Admin extends User {
  final int adminId;

  Admin({
    required this.adminId,
    required super.govId,
    required super.name,
    required super.lastName,
    required super.phoneNumber,
    required super.role,
    required super.email,
    required super.password,
  });
}

class Driver extends User {
  final int driverId;
  Vehicle? assignedVehicle;

  Driver({
    required this.driverId,
    required super.govId,
    required super.name,
    required super.lastName,
    required super.phoneNumber,
    required super.role,
    required super.email,
    required super.password,
  });
}

class FuelingPerson extends User {
  final int fuelingPersonId;

  FuelingPerson({
    required this.fuelingPersonId,
    required super.govId,
    required super.name,
    required super.lastName,
    required super.phoneNumber,
    required super.role,
    required super.email,
    required super.password,
  });
}

final List<String> allRoles = ['Admin', 'Driver', 'Maintenance', 'Fueling'];
