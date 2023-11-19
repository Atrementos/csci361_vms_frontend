import 'package:csci361_vms_frontend/models/vehicle.dart';
import 'package:csci361_vms_frontend/pages/map_page.dart';
import 'package:csci361_vms_frontend/widgets/admin_drawer.dart';
import 'package:csci361_vms_frontend/widgets/maintenance_drawer.dart';
import 'package:flutter/material.dart';
import 'package:csci361_vms_frontend/data/dummy_vehicles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VehiclesForMaintenancePage extends ConsumerWidget {
  VehiclesForMaintenancePage({super.key});

  final List<Vehicle> _registeredVehicles = dummyVehicles;
  final _formKey = GlobalKey<FormState>();

  void _addVehicle() {
    // TODO (Validate->Save->Sync with backend)
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          Expanded(
            child: ListView.builder(
              itemCount: _registeredVehicles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text(
                    _registeredVehicles[index].licensePlate,
                  ),
                  title: Text(
                    ' ${_registeredVehicles[index].model}, ${_registeredVehicles[index].year}',
                  ),
                  trailing: const Icon(Icons.arrow_outward),
                );
              },
            ),
          ),
        ],
      ),
      drawer: const MaintenanceDrawer(),
    );
  }
}
