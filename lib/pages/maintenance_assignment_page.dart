import 'package:csci361_vms_frontend/models/maintenance_assignment.dart';
import 'package:flutter/material.dart';
import 'package:csci361_vms_frontend/widgets/maintenance_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MaintenanceAssignmentPage extends StatefulWidget {
  const MaintenanceAssignmentPage({Key? key, required this.maintenanceAssignment})
      : super(key: key);
  final MaintenanceAssignment maintenanceAssignment;

  @override
  State<StatefulWidget> createState() {
    return _MaintenanceAssignmentPageState();
  }
}

class _MaintenanceAssignmentPageState extends State<MaintenanceAssignmentPage> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> _carParts = [];
  final imagepicker = ImagePicker();
  File? _selectedImage;
  TextEditingController _carPartNameController = TextEditingController();
  TextEditingController _repairCostController = TextEditingController();

  void _createAssignment() {
    // Perform assignment creation logic here, including car part details
    // You can access the entered values using _carPartNameController.text
    // and _repairCostController.text
    if (_selectedImage != null) {
      // Handle image upload logic here
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await imagepicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
      }
    });
  }

  void _addCarPart() {
    setState(() {
      _carParts.add({
        'name': _carPartNameController.text,
        'cost': double.parse(_repairCostController.text),
        'photo': _selectedImage,
      });

      // Clear the text controllers after adding a car part
      _carPartNameController.clear();
      _repairCostController.clear();
      _selectedImage = null;
    });
  }

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
            'Add a car part to repair',
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
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _carPartNameController,
                          decoration: const InputDecoration(
                            label: Text('Car Part Name'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _repairCostController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            label: Text('Repair Cost'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  _pickImage();
                },
                child: Text('Upload Photo'),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _addCarPart,
            child: const Text('Add Car Part'),
          ),
          if (_selectedImage != null)
            Image.file(_selectedImage!),
          Expanded(
            child: ListView.builder(
              itemCount: _carParts.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Car Part ${index + 1}'),
                      Text('Name: ${_carParts[index]['name']}'),
                      Text('Cost: \$${_carParts[index]['cost']}'),
                      if (_carParts[index]['photo'] != null)
                        Image.file(_carParts[index]['photo']!),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
