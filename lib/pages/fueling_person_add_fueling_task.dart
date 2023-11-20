import 'package:csci361_vms_frontend/models/user.dart';
import 'package:csci361_vms_frontend/widgets/admin_drawer.dart';
import 'package:flutter/material.dart';

class AddFueling extends StatefulWidget {
  const AddFueling({super.key});

  @override
  State<AddFueling> createState() => _AddFuelingState();
}

class _AddFuelingState extends State<AddFueling> {
  List<Driver> _registeredDrivers = [];
  final _formKey = GlobalKey<FormState>();

  void _addDriver() {}

  void loadDrivers() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drivers Page'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 6,
          ),
          Text(
            'Add a new driver here',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
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
                            label: Text('First Name'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Last Name'),
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
                            label: Text('Government ID'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Middle Name'),
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
                            label: Text('Phone Number'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Role'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Email'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Password'),
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
                        onPressed: _addDriver,
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _registeredDrivers.length,
              itemBuilder: (context, index) {
                return const Row(
                  children: [
                    Text('Driver name'),
                    Text('Driver last name'),
                    Text('Driver ID')
                  ],
                );
              },
            ),
          ),
        ],
      ),
      drawer: const AdminDrawer(),
    );
  }
}


// Widget build(BuildContext context) {
//     // ... Existing code ...

//     return ListView.builder(
//       itemCount: vehicles.length,
//       itemBuilder: (context, index) {
//         return Column(
//           children: [
//             ListTile(
//               leading: Text(
//                 vehicles[index].licensePlate,
//               ),
//               title: Text(
//                 '${vehicles[index].model} (${vehicles[index].year})',
//               ),
//               trailing: ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => VehicleDetailsPage(vehicle: vehicles[index]),
//                     ),
//                   );
//                 },
//                 child: const Text('Change'),
//               ),
//             ),
//             const Divider(), // Add a divider between each set of vehicle and button
//           ],
//         );
//       },
//     );
// }

