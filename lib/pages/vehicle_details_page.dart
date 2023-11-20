import 'dart:convert';

import 'package:csci361_vms_frontend/models/vehicle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class VehicleDetailsPage extends ConsumerStatefulWidget {
  final int vehicleId;

  const VehicleDetailsPage({super.key, required this.vehicleId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _VehicleDetailsPageState();
  }
}

class _VehicleDetailsPageState extends ConsumerState<VehicleDetailsPage> {
  final formKey = GlobalKey<FormState>();
  Vehicle? currentVehicle;

  @override
  void initState() {
    super.initState();
    loadVehicleInfo();
  }

  void loadVehicleInfo() async {
    final url =
        Uri.parse('http://vms-api.madi-wka.xyz/vehicle/${widget.vehicleId}');
    final response = await http.get(url);
    print(response.statusCode);
    print(response.body);
    var decodedResponse = json.decode(response.body);
    setState(() {
      currentVehicle = Vehicle.fromJson(decodedResponse);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Details'),
      ),
      body: currentVehicle == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Vehicle ID: ${currentVehicle!.vehicleId}',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.white70,
                            fontSize: 24,
                          ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      'Model: ${currentVehicle!.model}',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.white70,
                            fontSize: 24,
                          ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      'Year: ${currentVehicle!.year}',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.white70,
                            fontSize: 24,
                          ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      'License Plate: ${currentVehicle!.licensePlate}',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.white70,
                            fontSize: 24,
                          ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      'Mileage: ${currentVehicle!.mileage}',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.white70,
                            fontSize: 24,
                          ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      'Sitting capacity: ${currentVehicle!.sittingCapacity}',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.white70,
                            fontSize: 24,
                          ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      'Status: ${currentVehicle!.status}',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.white70,
                            fontSize: 24,
                          ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
