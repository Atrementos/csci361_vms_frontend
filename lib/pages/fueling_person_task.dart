import 'dart:convert';
import 'package:csci361_vms_frontend/models/vehicle.dart';
import 'package:csci361_vms_frontend/widgets/admin_drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FuelingVehiclesPage extends StatefulWidget {
  const FuelingVehiclesPage({Key? key}) : super(key: key);

  @override
  _FuelingVehiclesPageState createState() => _FuelingVehiclesPageState();
}

class _FuelingVehiclesPageState extends State<FuelingVehiclesPage> {
  final _formKey = GlobalKey<FormState>();
  String _fuelAmount = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fueling Vehicles Page'),
      ),
      body: FutureBuilder<List<Vehicle>>(
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
                return Column(
                  children: [
                    ListTile(
                      leading: Text(vehicles[index].licensePlate),
                      title: Text(
                          '${vehicles[index].model} (${vehicles[index].year})'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  FuelingDetailsPage(vehicle: vehicles[index]),
                            ),
                          );
                        },
                        child: const Text('Change'),
                      ),
                    ),
                    const Divider(),
                  ],
                );
              },
            );
          }
        },
      ),
      drawer: const AdminDrawer(),
    );
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
}

class FuelingDetailsPage extends StatefulWidget {
  final Vehicle vehicle;

  const FuelingDetailsPage({Key? key, required this.vehicle}) : super(key: key);

  @override
  _FuelingDetailsPageState createState() => _FuelingDetailsPageState();
}

class _FuelingDetailsPageState extends State<FuelingDetailsPage> {
  String _fuelAmount = "";
  String _fuelingTask = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fueling Details - ${widget.vehicle.model}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Change Fuel Amount',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Fuel Amount',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a fuel amount';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _fuelAmount = value;
                    },
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle the logic to change fuel amount here
                    // You can use the _fuelAmount value and make the necessary API calls.
                  },
                  child: const Text('Change'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Fueling Task',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Fueling Task',
                    ),
                    onChanged: (value) {
                      _fuelingTask = value;
                    },
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle the logic for the fueling task here
                    // You can use the _fuelingTask value and make the necessary API calls.
                  },
                  child: const Text('Submit Task'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
