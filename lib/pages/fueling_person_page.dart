import 'package:csci361_vms_frontend/models/user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FuelingPersonPage extends StatefulWidget {
  const FuelingPersonPage({super.key});

  @override
  State<FuelingPersonPage> createState() => _FuelingPersonState();
}

class _FuelingPersonState extends State<FuelingPersonPage> {
  List<Driver> _registeredFuelingPersons = [];
  final _formKey = GlobalKey<FormState>();

  final imagepicker = ImagePicker();

  get image => null;
  void _addFuelingPerson() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fueling Person'),
      ),
      body: Column(children: [
        const SizedBox(
          height: 6,
        ),
        Text(
          'Update information on fueling vehicles',
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
                            label: Text('Car plate information'),
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
                            label: Text('Time'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Driver information'),
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
                            label: Text('Amount of fuel'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Total cost of fuel'),
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
                            label: Text('Gas station name'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Fueling person name'),
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
                        onPressed: _addFuelingPerson,
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          imagepicker.pickImage(source: ImageSource.gallery);
                        },
                        child: Text('Upload Photo'),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
