import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:csci361_vms_frontend/data/dummy_maintenance_assigment.dart';
import 'package:csci361_vms_frontend/models/maintenance_assignment.dart';
import 'package:csci361_vms_frontend/pages/maintenance_assignment_page.dart';
import 'package:csci361_vms_frontend/widgets/maintenance_drawer.dart';

class CreateMaintenanceAssignmentPage extends StatefulWidget {
  const CreateMaintenanceAssignmentPage({Key? key}) : super(key: key);

  @override
  State<CreateMaintenanceAssignmentPage> createState() {
    return _CreateMaintenanceAssignmentPageState();
  }
}

class _CreateMaintenanceAssignmentPageState extends State<CreateMaintenanceAssignmentPage> {
  final _formKey = GlobalKey<FormState>();
  List<MaintenanceAssignment> _registeredMaintenanceAssignment = dummyMaintenanceAssignments;

  late String _imagePath;

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _licensePlateController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _fuelController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  Future<void> _getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  void _addMaintenanceAssignment() {
    if (_formKey.currentState!.validate()) {
      MaintenanceAssignment newAssignment = MaintenanceAssignment(
        id: 0, // Replace with the actual assignment ID logic
        description: _descriptionController.text,
        date: DateTime.parse(_dateController.text),
        carPartsList: [
          CarPart(
            parentId: 0, // Replace with the actual parent ID logic
            name: _nameController.text,
            number: _numberController.text,
            condition: _conditionController.text,
            cost: double.parse(_costController.text),
            image: _imagePath,
          ),
        ],
        totalCost: double.parse(_costController.text), // Assuming total cost is the same as the car part cost
        vehicle: Vehicle(
          id: 0, // Replace with the actual vehicle ID logic
          model: _modelController.text,
          year: int.parse(_yearController.text),
          licensePlate: _licensePlateController.text,
          mileage: int.parse(_mileageController.text),
          currentLocation: [],
          fuel: double.parse(_fuelController.text),
          type: _typeController.text,
          driverHistory: [0], // Assuming a single driver history ID
          assignedDriver: Driver(
            id: 0, // Replace with the actual driver ID logic
            name: 'string', // Add actual driver details
            middleName: 'string',
            lastName: 'string',
            contactNumber: 'string',
            governmentId: 'string',
            address: 'string',
            email: 'user@example.com',
            role: 'string',
            drivingLicenseNumber: 'string',
          ),
          capacity: int.parse(_capacityController.text),
          status: _statusController.text,
        ),
        assignedTo: Assignee(
          id: 0, // Replace with the actual assignee ID logic
          name: 'string', // Add actual assignee details
          middleName: 'string',
          lastName: 'string',
          contactNumber: 'string',
          governmentId: 'string',
          address: 'string',
          email: 'user@example.com',
          role: 'string',
        ),
      );

      _registeredMaintenanceAssignment.add(newAssignment);

      _formKey.currentState!.reset();
      setState(() {
        _imagePath = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Assignment Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 6),
            Text(
              'Add a new assignment',
              style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _dateController,
                      decoration: const InputDecoration(
                        labelText: 'Date',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a date';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Car Part Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a car part name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _numberController,
                      decoration: const InputDecoration(
                        labelText: 'Car Part Number',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a car part number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _conditionController,
                      decoration: const InputDecoration(
                        labelText: 'Car Part Condition',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a car part condition';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _costController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Car Part Cost',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a car part cost';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _getImage,
                      child: const Text('Pick Image'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _modelController,
                      decoration: const InputDecoration(
                        labelText: 'Vehicle Model',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a vehicle model';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _yearController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Vehicle Year',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a vehicle year';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _licensePlateController,
                      decoration: const InputDecoration(
                        labelText: 'Vehicle License Plate',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a vehicle license plate';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _mileageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Vehicle Mileage',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a vehicle mileage';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _fuelController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Vehicle Fuel',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a vehicle fuel';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _typeController,
                      decoration: const InputDecoration(
                        labelText: 'Vehicle Type',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a vehicle type';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _capacityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Vehicle Capacity',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a vehicle capacity';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _statusController,
                      decoration: const InputDecoration(
                        labelText: 'Vehicle Status',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a vehicle status';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            _formKey.currentState!.reset();
                            setState(() {
                              _imagePath = '';
                            });
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
            _imagePath.isNotEmpty
                ? Image.file(
              File(_imagePath),
              height: 200,
              width: 200,
            )
                : Container(height: 200,
              width: 200,
              color: Colors.grey, // Placeholder color or any other visual indication
              child: Center(
                child: Text(
                  'No Image Selected',
                  style: TextStyle(color: Colors.white),
                ),
              ),),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _registeredMaintenanceAssignment.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text(
                      '${_registeredMaintenanceAssignment[index].vehicle.model}',
                    ),
                    title: Text(
                      'Total Cost: ${_registeredMaintenanceAssignment[index].totalCost}',
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
      ),
      drawer: const MaintenanceDrawer(),
    );
  }
}
