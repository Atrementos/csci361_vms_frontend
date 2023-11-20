class DriverAssignment {
  final String description;
  final List<double> startLocation;
  final List<double> endLocation;
  final int? distanceCovered;
  String status;
  final DateTime? startDateTime;
  final DateTime? endDateTime;

  DriverAssignment({
    required this.description,
    required this.startLocation,
    required this.endLocation,
    required this.distanceCovered,
    required this.status,
    required this.startDateTime,
    required this.endDateTime,
  });
}