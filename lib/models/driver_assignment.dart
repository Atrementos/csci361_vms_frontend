class DriverAssignment {
  final int taskId;
  final String description;
  final List<dynamic> startLocation;
  final List<dynamic> endLocation;
  final int? distanceCovered;
  String status;
  final String? startDateTime;
  final String? endDateTime;

  DriverAssignment({
    required this.taskId,
    required this.description,
    required this.startLocation,
    required this.endLocation,
    required this.distanceCovered,
    required this.status,
    required this.startDateTime,
    required this.endDateTime,
  });

  factory DriverAssignment.fromJson(Map<String, dynamic> json) {
    return DriverAssignment(
      taskId: json['Id'],
      description: json['Description'],
      startLocation: json['StartLocation'],
      endLocation: json['EndLocation'],
      distanceCovered: json['DistanceCovered'],
      status: json['Status'],
      startDateTime: json['StartDateTime'],
      endDateTime: json['EndDateTime'],
    );
  }
}