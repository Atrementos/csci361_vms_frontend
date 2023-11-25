import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../providers/jwt_token_provider.dart';


class FuelingTaskPage extends ConsumerStatefulWidget {
  final int id;
  const FuelingTaskPage(this.id, {super.key});
  @override
  ConsumerState<FuelingTaskPage> createState() {
    return _FuelingTaskPageState();
  }
}
class FuelingTaskDetails {
  final int taskId;
  final int vehicleId;
  final String description;
  final DateTime date;
  final double cost;
  final double fuelRefilled;
  final String gasStationName;
  final String driverName;
  final String driverLastName;
  final String vehicleLicensePlate;
  final String vehicleModel;
  final int creatorId;
  late final Uint8List imageBefore;
  late final Uint8List imageAfter;

  FuelingTaskDetails({
    required this.taskId,
    required this.vehicleId,
    required this.description,
    required this.date,
    required this.cost,
    required this.fuelRefilled,
    required this.gasStationName,
    required this.driverName,
    required this.driverLastName,
    required this.vehicleLicensePlate,
    required this.vehicleModel,
    required this.creatorId,
    required this.imageBefore,
    required this.imageAfter,
  });

  factory FuelingTaskDetails.fromJson(Map<String, dynamic> json) {
    return FuelingTaskDetails(
      taskId: json['Id'],
      vehicleId: json['VehicleId'],
      description: json['Description'],
      date: DateTime.parse(json['Date']),
      cost: json['Cost'].toDouble(),
      fuelRefilled: json['FuelRefilled'].toDouble(),
      gasStationName: json['GasStationName'],
      driverName: json['Driver']['Name'],
      driverLastName: json['Driver']['LastName'],
      vehicleLicensePlate: json['Driver']['AssignedVehicle']['LicensePlate'],
      vehicleModel: json['Driver']['AssignedVehicle']['Model'],
      creatorId: json['Creator'],
      imageBefore: base64Decode(json['ImageBefore']),
      imageAfter: base64Decode(json['ImageAfter']),
    );
  }
}

class _FuelingTaskPageState extends ConsumerState<FuelingTaskPage> {
  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    fetchFuelingTasksDetails();
  }
  late FuelingTaskDetails tasksDetail;

  Future<void> fetchFuelingTasksDetails() async {
    final url = Uri.http('vms-api.madi-wka.xyz', '/fuel/${widget.id}'); // Replace with your backend URL

    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader : 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJtYWRpLnR1cmd1bm92QG51LmVkdS5reiIsImV4cCI6MTcwMTE5MzIwNH0.IXyt9_g5mangj9Px00fREGPTmkO6zXmCWV9qle2RyVg',
    });
    print(response.statusCode);
    if (response.statusCode == 200) {

      final decodedResponse = json.decode(response.body);
      tasksDetail = FuelingTaskDetails.fromJson(decodedResponse);
    }
    else {
      throw Exception('Failed to fetch data from the backend');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fueling history'),
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.all(8.0),
          child: ListTile(
            title: Text('Task ID: ${tasksDetail.taskId}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Other details...
                Text('Gas Station Name: ${tasksDetail.gasStationName}'),
                Text('Driver Name: ${tasksDetail.driverName} ${tasksDetail.driverLastName}'),
                // Display imageBefore
                tasksDetail.imageBefore.isNotEmpty
                    ? Image.memory(
                  tasksDetail.imageBefore,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                )
                    : SizedBox.shrink(), // Show nothing if imageBefore is empty
                // Display imageAfter
                tasksDetail.imageAfter.isNotEmpty
                    ? Image.memory(
                  (tasksDetail.imageAfter),
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                )
                    : SizedBox.shrink(), // Show nothing if imageAfter is empty
              ],
            ),
          ),
        ),
      ),
    );
  }
}
