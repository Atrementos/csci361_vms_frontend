import 'dart:convert';

import 'package:csci361_vms_frontend/models/vehicle.dart';
import 'package:csci361_vms_frontend/pages/fueling_person_task.dart';
import 'package:csci361_vms_frontend/widgets/fueling_person_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class VehicleForFuelingPage extends ConsumerStatefulWidget {
  const VehicleForFuelingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _VehicleForFuelingPageState();
  }
}

class _VehicleForFuelingPageState extends ConsumerState<VehicleForFuelingPage> {
  var vehicles = [];
  bool vehiclesLoaded = false;

  @override
  void initState() {
    super.initState();
    loadVehicles();
  }

  void loadVehicles() async {
    final url = Uri.parse('http://vms-api.madi-wka.xyz/vehicle/');
    final response = await http.get(url);
    print(response.statusCode);
    print(response.body);
    setState(() {
      vehicles = json.decode(response.body);
      vehiclesLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicles'),
      ),
      body: !vehiclesLoaded
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: Text(vehicles[index]['LicensePlate']),
                    title: Text(
                        '${vehicles[index]['Model']} (${vehicles[index]['Year']})'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) {
                              return FuelingDetailsPage(
                                vehicle: Vehicle.fromJson(vehicles[index]),
                              );
                            },
                          ),
                        );
                      },
                      child: const Text('Change'),
                    ),
                  ),
                );
              },
            ),
      drawer: const FuelingPersonDrawer(),
    );
  }
}
