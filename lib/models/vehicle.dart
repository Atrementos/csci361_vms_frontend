import 'package:csci361_vms_frontend/models/user.dart';

class Vehicle {
  final int vehicleId;
  final String model;
  final int year;
  final String licensePlate;
  final int mileage;
  final List<dynamic> currentLocation;
  final int fuel;
  final String type;
  final List<int>? driverHistory;
  final Driver? assignedDriver;
  final int sittingCapacity;
  final String status;

  const Vehicle({
    required this.vehicleId,
    required this.model,
    required this.year,
    required this.licensePlate,
    required this.mileage,
    required this.currentLocation,
    required this.fuel,
    required this.type,
    required this.driverHistory,
    required this.assignedDriver,
    required this.sittingCapacity,
    required this.status,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      vehicleId: json['Id'],
      model: json['Model'],
      year: json['Year'],
      licensePlate: json['LicensePlate'],
      mileage: json['Mileage'],
      currentLocation: json['CurrentLocation'],
      fuel: json['Fuel'],
      type: json['Type'],
      driverHistory: json['DriverHistory'],
      assignedDriver: Driver.fromJson(json['AssignedDriver']),
      sittingCapacity: json['Capacity'],
      status: json['Status'],
    );
  }
}
