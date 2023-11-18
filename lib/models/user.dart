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
    this.middleName,
    required this.lastName,
    required this.phoneNumber,
    required this.role,
    required this.email,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      govId: json['GovId'],
      name: json['Name'],
      middleName: json['MiddleName'],
      lastName: json['LastName'],
      phoneNumber: json['PhoneNumber'],
      role: json['Role'],
      email: json['Email'],
      password: json['Password'],
    );
  }
}

class Admin extends User {
  final int adminId;

  Admin({
    required this.adminId,
    required super.govId,
    required super.name,
    super.middleName,
    required super.lastName,
    required super.phoneNumber,
    required super.role,
    required super.email,
    required super.password,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      adminId: json['Id'],
      govId: json['GovId'],
      name: json['Name'],
      middleName: json['MiddleName'],
      lastName: json['LastName'],
      phoneNumber: json['PhoneNumber'],
      role: json['Role'],
      email: json['Email'],
      password: json['Password'],
    );
  }
}

class Driver extends User {
  final int driverId;
  Vehicle? assignedVehicle;

  Driver({
    required this.driverId,
    required super.govId,
    required super.name,
    super.middleName,
    required super.lastName,
    required super.phoneNumber,
    required super.role,
    required super.email,
    required super.password,
  });

  factory Driver.fromJson(Map<String, dynamic>? json) {
    return Driver(
      driverId: json?['Id'] ?? 0,
      govId: json?['GovId'] ?? 0,
      name: json?['Name'] ?? '',
      middleName: json?['MiddleName'] ?? '',
      lastName: json?['LastName'] ?? '',
      phoneNumber: json?['PhoneNumber'] ?? '',
      role: json?['Role'] ?? '',
      email: json?['Email'] ?? '',
      password: json?['Password'] ?? '',
    );
  }
}

class FuelingPerson extends User {
  final int fuelingPersonId;

  FuelingPerson({
    required this.fuelingPersonId,
    required super.govId,
    required super.name,
    super.middleName,
    required super.lastName,
    required super.phoneNumber,
    required super.role,
    required super.email,
    required super.password,
  });

  factory FuelingPerson.fromJson(Map<String, dynamic> json) {
    return FuelingPerson(
      fuelingPersonId: json['Id'],
      govId: json['GovId'],
      name: json['Name'],
      middleName: json['MiddleName'],
      lastName: json['LastName'],
      phoneNumber: json['PhoneNumber'],
      role: json['Role'],
      email: json['Email'],
      password: json['Password'],
    );
  }
}

final List<String> allRoles = ['Admin', 'Driver', 'Maintenance', 'Fueling'];
