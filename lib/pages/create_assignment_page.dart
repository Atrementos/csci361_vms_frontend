// import 'dart:html';
import 'package:csci361_vms_frontend/models/maintenance_assignment.dart';
import 'package:csci361_vms_frontend/models/user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:csci361_vms_frontend/widgets/maintenance_drawer.dart';
import 'package:csci361_vms_frontend/data/dummy_maintenance_assigment.dart';
import 'package:csci361_vms_frontend/pages/maintenance_assignment_page.dart';

class CreateMaintenancePage extends StatefulWidget {
  const CreateMaintenancePage({super.key});

  @override
  State<CreateMaintenancePage> createState() => _CreateMaintenanceState();
}

class _CreateMaintenanceState extends State<CreateMaintenancePage> {
  final List<MaintenanceAssignment> _registeredMaintenanceAssignment = dummyMaintenanceAssignments;
  final _formKey = GlobalKey<FormState>();

  final imagepicker = ImagePicker();

  get image => null;
  void _addMaintenanceAssignment() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance Assignment'),
      ),
      body: Column(children: [
        const SizedBox(
          height: 6,
        ),
        Text(
          'Create maintenance assignment',
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
                            label: Text('Description'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            label: Text('VehicleID'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            label: Text('Date'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Car Part'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            label: Text('Repairing Cost'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Status'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
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
                        onPressed: _addMaintenanceAssignment,
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
            itemCount: _registeredMaintenanceAssignment.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Text(
                  _registeredMaintenanceAssignment[index].description,
                ),
                title: Text(
                  ' ${_registeredMaintenanceAssignment[index].vehicle.id}, ${_registeredMaintenanceAssignment[index].date}',
                ),

                trailing: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => MaintenanceAssignmentPage(
                            maintenanceAssignment: _registeredMaintenanceAssignment[index]),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_outward),
                ),
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
      ]),
      drawer: const MaintenanceDrawer(),
    );
  }
}
