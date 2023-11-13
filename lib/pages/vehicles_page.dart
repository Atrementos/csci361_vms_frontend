import 'package:csci361_vms_frontend/models/vehicle.dart';
import 'package:csci361_vms_frontend/pages/map_page.dart';
import 'package:csci361_vms_frontend/widgets/admin_drawer.dart';
import 'package:flutter/material.dart';
import 'package:csci361_vms_frontend/data/dummy_vehicles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VehiclesPage extends ConsumerWidget {
  VehiclesPage({super.key});

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
          Text(
            'Add a new vehicle here',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              label: Text('License Plate'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              label: Text('Type'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Model'),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              label: Text('Make'),
                            ),
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
                              label: Text('Year'),
                            ),
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
                              label: Text('Capacity'),
                            ),
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
                    '${_registeredVehicles[index].make}, ${_registeredVehicles[index].model}, ${_registeredVehicles[index].year}',
                  ),
                  trailing: const Icon(Icons.arrow_outward),
                );
                // const Row(
                //   children: [
                //     Text('Vehicle license plate'),
                //     Text('Vehicle model'),
                //     Text('Vehicle year')
                //   ],
                // );
              },
            ),
          ),
        ],
      ),
      drawer: const AdminDrawer(),
    );
  }
}
