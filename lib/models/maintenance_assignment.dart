class MaintenanceAssignment {
  final int id;
  final String description;
  final DateTime date;
  final List<CarPart> carPartsList;
  final double totalCost;
  final Vehicle vehicle;
  final Assignee assignedTo;
  bool completed = false;

  MaintenanceAssignment({
    required this.id,
    required this.description,
    required this.date,
    required this.carPartsList,
    required this.totalCost,
    required this.vehicle,
    required this.assignedTo,
    required this.completed,

  });

  factory MaintenanceAssignment.fromJson(Map<String, dynamic> json) {
    return MaintenanceAssignment(
      id: json['id'],
      description: json['description'],
      vehicle: json['vehicle'],
      date: DateTime.parse(json['date']),
      carPartsList: json['carPart'],
      totalCost: json['repairingCost'].toDouble(),
      completed: json['status'],
      assignedTo: json['assignedTo']
      // Map other JSON properties to class properties...
    );
  }
}

class CarPart {
  final int parentId;
  final String name;
  final String number;
  final String condition;
  final double cost;
  final String image;

  CarPart({
    required this.parentId,
    required this.name,
    required this.number,
    required this.condition,
    required this.cost,
    required this.image,
  });
}

class Vehicle {
  final int id;
  final String model;
  final int year;
  final String licensePlate;
  final int mileage;
  final List<String> currentLocation;
  final double fuel;
  final String type;
  final List<int> driverHistory;
  final Driver assignedDriver;
  final int capacity;
  final String status;

  Vehicle({
    required this.id,
    required this.model,
    required this.year,
    required this.licensePlate,
    required this.mileage,
    required this.currentLocation,
    required this.fuel,
    required this.type,
    required this.driverHistory,
    required this.assignedDriver,
    required this.capacity,
    required this.status,
  });
}

class Driver {
  final int id;
  final String name;
  final String middleName;
  final String lastName;
  final String contactNumber;
  final String governmentId;
  final String address;
  final String email;
  final String role;
  final String drivingLicenseNumber;

  Driver({
    required this.id,
    required this.name,
    required this.middleName,
    required this.lastName,
    required this.contactNumber,
    required this.governmentId,
    required this.address,
    required this.email,
    required this.role,
    required this.drivingLicenseNumber,
  });
}

class Assignee {
  final int id;
  final String name;
  final String middleName;
  final String lastName;
  final String contactNumber;
  final String governmentId;
  final String address;
  final String email;
  final String role;

  Assignee({
    required this.id,
    required this.name,
    required this.middleName,
    required this.lastName,
    required this.contactNumber,
    required this.governmentId,
    required this.address,
    required this.email,
    required this.role,
  });
}
