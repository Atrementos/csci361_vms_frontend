import 'package:csci361_vms_frontend/models/maintenance_assignment.dart';
import 'package:flutter/material.dart';
import 'package:csci361_vms_frontend/widgets/maintenance_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class MaintenanceAssignmentPage extends StatefulWidget {
  const MaintenanceAssignmentPage(
      {Key? key, required this.maintenanceAssignment})
      : super(key: key);
  final MaintenanceAssignment maintenanceAssignment;

  @override
  State<StatefulWidget> createState() {
    return _MaintenanceAssignmentPageState();
  }
}

class _MaintenanceAssignmentPageState
    extends State<MaintenanceAssignmentPage> {
  final _formKey = GlobalKey<FormState>();
  List<MaintenanceAssignment> _MaintenanceAssignments = [];
  final imagepicker = ImagePicker();

  void _createAssignment() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment Details'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 6,
          ),
          Text(
            'Update a maintenance assignment',
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
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              label: Text('Car Parts'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              label: Text('Total repairing Cost'),
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
                          onPressed: _createAssignment,
                          child: const Text('Update'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  imagepicker.pickImage(source: ImageSource.gallery);
                },
                child: Text('Upload Photo'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _MaintenanceAssignments.length,
              itemBuilder: (context, index) {
                return const Row(
                  children: [
                    Text('Maintenance Worker'),
                    Text('Car Parts'),
                    Text('Total Repairing Cost')
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
