import 'package:csci361_vms_frontend/widgets/admin_drawer.dart';
import 'package:flutter/material.dart';

class VehicleAssignmentPage extends StatelessWidget {
  const VehicleAssignmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Assignment'),
      ),
      body: Text(
        'Assign a vehicle to a driver',
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
      ),
      drawer: const AdminDrawer(),
    );
  }
}
