import 'dart:convert';
import 'dart:io';
import 'package:csci361_vms_frontend/pages/vehicle_details_page.dart';
import 'package:csci361_vms_frontend/pages/vehicle_for_maintenance_page.dart';
import 'package:csci361_vms_frontend/providers/jwt_token_provider.dart';
import 'package:csci361_vms_frontend/models/vehicle.dart';
import 'package:csci361_vms_frontend/pages/map_page.dart';
import 'package:csci361_vms_frontend/widgets/admin_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:csci361_vms_frontend/providers/role_provider.dart';
import 'package:http/http.dart' as http;

class VehiclesPage extends ConsumerStatefulWidget {
  const VehiclesPage({Key? key}) : super(key: key);

  @override
  _VehiclesPageState createState() => _VehiclesPageState();
}

class _VehiclesPageState extends ConsumerState<VehiclesPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadVehicles();
  }

  final _formKey = GlobalKey<FormState>();
  String _model = "",
      _year = "",
      _license_plate = "",
      _mileage = "",
      _capacity = "",
      _type = "";
  Future<void> _addVehicle() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // TODO (Validate->Save->Sync with backend)
      final Map<String, String> queryParams = {
        "Model": _model,
        "Year": _year,
        "LicensePlate": _license_plate,
        "Mileage": _mileage,
        "Capacity": _capacity,
        "Type": _type,
      };

      final url = Uri.parse('http://vms-api.madi-wka.xyz/vehicle/');
      var response =
          await http.post(url, body: jsonEncode(queryParams), headers: {
        HttpHeaders.authorizationHeader:
            "Bearer ${ref.read(jwt.jwtTokenProvider)}",
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*',
      });
      if (response.statusCode == 201) {
        _loadVehicles();
      } else {
        throw Exception(response.body);
      }
    }
  }

  Future<void> _loadVehicles() async {
    try {
      setState(() {
        fetchVehicleModels();
      });
    } catch (error) {
      throw ('Error loading vehicles: $error');
      // Handle error as needed
    }
  }

  Future<List<Vehicle>> fetchVehicleModels() async {
    final response =
        await http.get(Uri.http('vms-api.madi-wka.xyz', '/vehicle/'));
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
          ref.read(userRole.roleProvider) == 'Admin'
              ? Text(
                  'Add a new vehicle here',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                )
              : const SizedBox(
                  height: 0,
                ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: ref.read(userRole.roleProvider) == 'Admin'
                ? Form(
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
                                onChanged: (value) {
                                  _license_plate = value;
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
                                onChanged: (value) {
                                  _type = value;
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
                          onChanged: (value) {
                            _model = value;
                          },
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Mileage',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a vehicle Mileage';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  _mileage = value;
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
                                onChanged: (value) {
                                  _year = value;
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
                                onChanged: (value) {
                                  _capacity = value;
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
                  )
                : const Text('View Vehicles'),
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
                        trailing: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) {
                                    return ref.read(userRole.roleProvider) == 'Admin'
                                    ? VehicleDetailsPage(
                                      vehicleId: vehicles[index].vehicleId,
                                    ) : VehicleForMaintenancePage(vehicleId: vehicles[index].vehicleId,);
                                  },
                                ),
                              );
                            },
                            icon: const Icon(Icons.arrow_outward)),
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
