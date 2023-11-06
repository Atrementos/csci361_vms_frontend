import 'package:csci361_vms_frontend/models/fueling_assignment.dart';
import 'package:csci361_vms_frontend/models/user.dart';
import 'package:flutter/material.dart';

class FuelingPersonDetailsPage extends StatefulWidget {
  const FuelingPersonDetailsPage({super.key, required this.fuelingPerson});
  final FuelingPerson fuelingPerson;

  @override
  State<StatefulWidget> createState() {
    return _FuelingPersonDetailsPageState();
  }
}

class _FuelingPersonDetailsPageState extends State<FuelingPersonDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  List<FuelingAssignment> _fuelingAssignments = [];

  void _createAssignment() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fueling Person Details'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 6,
          ),
          Text(
            'Assign a fueling assignment to fueling person here',
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
                              label: Text('Vehicle ID'),
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
                              label: Text('Fuel cost'),
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
                              label: Text('Gas station name'),
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
              itemCount: _fuelingAssignments.length,
              itemBuilder: (context, index) {
                return const Row(
                  children: [
                    Text('Vehicle ID'),
                    Text('Fuel cost'),
                    Text('Gas station name')
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
