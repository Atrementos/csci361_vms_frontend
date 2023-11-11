import 'package:csci361_vms_frontend/data/dummy_maintenance_assigment.dart';
import 'package:csci361_vms_frontend/models/maintenance_assignment.dart';
import 'package:csci361_vms_frontend/pages/maintenance_assignment_page.dart';
import 'package:csci361_vms_frontend/widgets/maintenance_drawer.dart';
import 'package:flutter/material.dart';

class CreateMaintenanceAssignmentPage extends StatefulWidget {
  const CreateMaintenanceAssignmentPage({super.key});

  @override
  State<CreateMaintenanceAssignmentPage> createState() {
    return _CreateMaintenanceAssignmentPageState();
  }
}

class _CreateMaintenanceAssignmentPageState extends State<CreateMaintenanceAssignmentPage> {
  final _formKey = GlobalKey<FormState>();
  List<MaintenanceAssignment> _registeredMaintenanceAssignment = dummyMaintenanceAssignments;

  void _addMaintenanceAssignment() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Assignment Page'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 6,
          ),
          Text(
            'Add a new assignment',
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
                              label: Text('Date'),
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
                              label: Text('Maintenance Worker'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              label: Text('Vehicle'),
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
                              label: Text('Car Parts'),
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
                    '${_registeredMaintenanceAssignment[index].vehicle}',
                  ),
                  title: Text(
                    '${_registeredMaintenanceAssignment[index].carParts}, ${_registeredMaintenanceAssignment[index].totalRepairCost}',
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
              },
            ),
          ),
        ],
      ),
      drawer: const MaintenanceDrawer(),
    );
  }
}
