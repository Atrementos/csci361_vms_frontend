import 'dart:convert';

import 'package:csci361_vms_frontend/models/vehicle.dart';
import 'package:csci361_vms_frontend/pages/map_page.dart';
import 'package:csci361_vms_frontend/widgets/admin_drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VehiclesPage extends StatefulWidget {
  const VehiclesPage({Key? key}) : super(key: key);

  @override
  _VehiclesPageState createState() => _VehiclesPageState();
}

class _VehiclesPageState extends State<VehiclesPage> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _addVehicle() async {
    if (_formKey.currentState!.validate()) {
      // TODO: Save and sync with the backend
      // For now, let's reset the form
      _formKey.currentState!.reset();
      // Reload the vehicles list
      await _loadVehicles();
    }
  }

  Future<void> _loadVehicles() async {
    try {
      setState(() {
      });
    } catch (error) {
      throw('Error loading vehicles: $error');
      // Handle error as needed
    }
  }

  Future<List<Vehicle>> fetchVehicleModels() async {
    final response = await http.get(Uri.http('vms-api.madi-wka.xyz', '/vehicle/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) {
        return Vehicle.fromJson(json);
      }).toList();
    } else {
      throw Exception('Failed to load vehicle models');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicles Page'),
      ),
      body: Column(
        children: [
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => const MapPage(),
                    ),
                  );
                },
                child: const Text('View All Vehicles'),
              ),
            ],
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            'Add a new vehicle here',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'License Plate',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a license plate';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Type',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a vehicle type';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Model',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a vehicle model';
                      }
                      return null;
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Make',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a vehicle make';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Year',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a vehicle year';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Capacity',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a vehicle capacity';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          _formKey.currentState!.reset();
                        },
                        child: const Text('Reset'),
                      ),
                      ElevatedButton(
                        onPressed: _addVehicle,
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Vehicle>>(
              future: fetchVehicleModels(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final List<Vehicle> vehicles = snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: vehicles.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Text(
                          vehicles[index].licensePlate,
                        ),
                        title: Text(
                          '${vehicles[index].model} (${vehicles[index].year})',
                        ),
                        trailing: const Icon(Icons.arrow_outward),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      drawer: const AdminDrawer(),
    );
  }
}

