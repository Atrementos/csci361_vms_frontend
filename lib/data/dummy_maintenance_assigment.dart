import 'package:csci361_vms_frontend/models/maintenance_assignment.dart';

List<MaintenanceAssignment> dummyMaintenanceAssignments = [
  MaintenanceAssignment(
    description: 'Routine Checkup',
    vehicle: '000AAA00',
    date: DateTime(2023, 11, 10),
    maintenanceWorker: 'John Doe',
    carParts: [
      CarPart(name: 'Engine Oil', image: 'engine_oil_image.jpg', cost: 50.0),
      CarPart(name: 'Air Filter', image: 'air_filter_image.jpg', cost: 20.0),
      CarPart(name: 'Brake Pads', image: 'brake_pads_image.jpg', cost: 30.0),
    ],
    totalRepairCost: 100.0,
    status: 'Completed',
  ),
  MaintenanceAssignment(
    description: 'Tire Replacement',
    vehicle: '002AAA00',
    date: DateTime(2023, 11, 5),
    maintenanceWorker: 'Jane Smith',
    carParts: [
      CarPart(name: 'Tire', image: 'tire_image.jpg', cost: 80.0),
      CarPart(name: 'Wheel Alignment', image: 'alignment_image.jpg', cost: 40.0),
    ],
    totalRepairCost: 120.0,
    status: 'In Progress',
  ),
  MaintenanceAssignment(
    description: 'Battery Replacement',
    vehicle: '003AAA00',
    date: DateTime(2023, 11, 3),
    maintenanceWorker: 'Bob Johnson',
    carParts: [
      CarPart(name: 'Battery', image: 'battery_image.jpg', cost: 60.0),
    ],
    totalRepairCost: 60.0,
    status: 'Pending',
  ),
];
