class MaintenanceAssignment {
  final int id;
  final String description;
  final DateTime? date;
  final List<CarPart> carPartsList;
  final double totalCost;
  final Vehicle? vehicle;
  final Assignee? assignedTo;
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
      id: json['Id'] ?? 0,
      description: json['Description'] ?? 'N/A',
      vehicle: json['Vehicle'] != null ? Vehicle.fromJson(json['Vehicle']) : null,
      date: json['Date'] != null ? DateTime.parse(json['Date']) : null,
      carPartsList: (json['CarPartsList'] as List<dynamic>?)
          ?.map((part) => CarPart.fromJson(part))
          .toList() ?? [],
      totalCost: json['TotalCost']?.toDouble() ?? 0.0,
      completed: json['Status'] == 'Completed',
      assignedTo: json['AssignedTo'] != null ? Assignee.fromJson(json['AssignedTo']) : null,
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

  factory CarPart.fromJson(Map<String, dynamic> json) {
    return CarPart(
      parentId: json['ParentId'] ?? 0,
      name: json['Name'] ?? 'N/A',
      number: json['Number'] ?? 'N/A',
      condition: json['Condition'] ?? 'N/A',
      cost: json['Cost']?.toDouble() ?? 0.0,
      image: json['Image'] ?? 'N/A',
    );
  }
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

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['Id'] ?? 0,
      model: json['Model'] ?? 'N/A',
      year: json['Year'] ?? 0,
      licensePlate: json['LicensePlate'] ?? 'N/A',
      mileage: json['Mileage'] ?? 0,
      currentLocation: (json['CurrentLocation'] as List<dynamic>?)
          ?.map((location) => location.toString())
          .toList() ?? [],
      fuel: json['Fuel']?.toDouble() ?? 0.0,
      type: json['Type'] ?? 'N/A',
      driverHistory: (json['DriverHistory'] as List<dynamic>?)
          ?.map((history) => history as int)
          .toList() ?? [],
      assignedDriver: json['AssignedDriver'] != null ? Driver.fromJson(json['AssignedDriver']) : Driver(id: 0, name: 'N/A', middleName: 'N/A', lastName: 'N/A', contactNumber: 'N/A', governmentId: 'N/A', address: 'N/A', email: 'N/A', role: 'N/A', drivingLicenseNumber: 'N/A'),
      capacity: json['Capacity'] ?? 0,
      status: json['Status'] ?? 'N/A',
    );
  }
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

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['Id'] ?? 0,
      name: json['Name'] ?? 'N/A',
      middleName: json['MiddleName'] ?? 'N/A',
      lastName: json['LastName'] ?? 'N/A',
      contactNumber: json['ContactNumber'] ?? 'N/A',
      governmentId: json['GovernmentId'] ?? 'N/A',
      address: json['Address'] ?? 'N/A',
      email: json['Email'] ?? 'N/A',
      role: json['Role'] ?? 'N/A',
      drivingLicenseNumber: json['DrivingLicenseNumber'] ?? 'N/A',
    );
  }
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

  factory Assignee.fromJson(Map<String, dynamic> json) {
    return Assignee(
      id: json['Id'] ?? 0,
      name: json['Name'] ?? 'N/A',
      middleName: json['MiddleName'] ?? 'N/A',
      lastName: json['LastName'] ?? 'N/A',
      contactNumber: json['ContactNumber'] ?? 'N/A',
      governmentId: json['GovernmentId'] ?? 'N/A',
      address: json['Address'] ?? 'N/A',
      email: json['Email'] ?? 'N/A',
      role: json['Role'] ?? 'N/A',
    );
  }
}
