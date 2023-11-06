import 'package:csci361_vms_frontend/data/dummy_fueling_persons.dart';
import 'package:csci361_vms_frontend/models/user.dart';
import 'package:csci361_vms_frontend/pages/fueling_person_details_page.dart';
import 'package:csci361_vms_frontend/widgets/admin_drawer.dart';
import 'package:flutter/material.dart';

class FuelingPersonsPage extends StatefulWidget {
  const FuelingPersonsPage({super.key});

  @override
  State<FuelingPersonsPage> createState() {
    return _FuelingPersonsPageState();
  }
}

class _FuelingPersonsPageState extends State<FuelingPersonsPage> {
  final _formKey = GlobalKey<FormState>();
  List<FuelingPerson> _registeredFuelingPersons = dummyFuelingPersons;

  void _addFuelingPerson() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fueling Persons Page'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 6,
          ),
          Text(
            'Add a new fueling person here',
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
                          onPressed: _addFuelingPerson,
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
              itemCount: _registeredFuelingPersons.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text(
                    '${_registeredFuelingPersons[index].fuelingPersonId}',
                  ),
                  title: Text(
                    '${_registeredFuelingPersons[index].name}, ${_registeredFuelingPersons[index].lastName}',
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => FuelingPersonDetailsPage(
                              fuelingPerson: _registeredFuelingPersons[index]),
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
      drawer: const AdminDrawer(),
    );
  }
}
