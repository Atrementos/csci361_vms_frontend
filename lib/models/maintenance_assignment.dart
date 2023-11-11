class MaintenanceAssignment {
  final String description;
  final String vehicle;
  final DateTime date;
  final String maintenanceWorker;
  final List<CarPart> carParts;
  final double totalRepairCost;
  final String status;

  MaintenanceAssignment({
    required this.description,
    required this.vehicle,
    required this.date,
    required this.maintenanceWorker,
    required this.carParts,
    required this.totalRepairCost,
    required this.status,
  });
}

class CarPart {
  final String name;
  final String image;
  final double cost;

  CarPart({
    required this.name,
    required this.image,
    required this.cost,
  });
}
