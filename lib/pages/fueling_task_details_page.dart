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
    _tasksDetailFuture = fetchFuelingTasksDetails();
  }
  late Future<FuelingTaskDetails> _tasksDetailFuture;

  Future<FuelingTaskDetails> fetchFuelingTasksDetails() async {
    final url = Uri.http('vms-api.madi-wka.xyz', '/fuel/${widget.id}');

    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${ref.read(jwt.jwtTokenProvider)}',
    });

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      return FuelingTaskDetails.fromJson(decodedResponse);
    } else {
      throw Exception('Failed to fetch data from the backend');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fueling Task Details'),
      ),
      body: FutureBuilder<FuelingTaskDetails>(
        future: _tasksDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          } else {
            final tasksDetail = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Task ID', tasksDetail.taskId.toString()),
                  _buildDetailRow('Vehicle ID', tasksDetail.vehicleId.toString()),
                  _buildDetailRow('Description', tasksDetail.description),
                  _buildDetailRow('Date', tasksDetail.date.toString()),
                  _buildDetailRow('Cost', tasksDetail.cost.toString()),
                  _buildDetailRow('Fuel Refilled', tasksDetail.fuelRefilled.toString()),
                  _buildDetailRow('Gas Station Name', tasksDetail.gasStationName),
                  _buildDetailRow('Driver', '${tasksDetail.driverName} ${tasksDetail.driverLastName}'),
                  _buildDetailRow('Vehicle License Plate', tasksDetail.vehicleLicensePlate),
                  _buildDetailRow('Vehicle Model', tasksDetail.vehicleModel),
                  _buildDetailRow('Creator ID', tasksDetail.creatorId.toString()),
                  SizedBox(height: 16.0),
                  _buildImageSection('Image Before', tasksDetail.imageBefore),
                  _buildImageSection('Image After', tasksDetail.imageAfter),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white70, fontSize: 20)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white70, fontSize: 20)),
        ],
      ),
    );
  }

  Widget _buildImageSection(String title, Uint8List image) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white70, fontSize: 20)),
        SizedBox(height: 8.0),
        image.isNotEmpty
            ? Image.memory(
          image,
          height: 200,
          width: 200,
          fit: BoxFit.cover,
        )
            : const Text('No image available', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70, fontSize: 20)),
        SizedBox(height: 16.0),
      ],
    );
  }
}