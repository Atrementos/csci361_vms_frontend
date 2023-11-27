import 'dart:convert';

import 'package:csci361_vms_frontend/providers/jwt_token_provider.dart';
import 'package:csci361_vms_frontend/models/maintenance_assignment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MaintenanceAssignmentPage extends ConsumerStatefulWidget {
  final MaintenanceAssignment maintenanceAssignment;
  const MaintenanceAssignmentPage(
      {super.key, required this.maintenanceAssignment});

  @override
  ConsumerState<MaintenanceAssignmentPage> createState() {
    return _MaintenanceAssignmentPageState();
  }
}

class _MaintenanceAssignmentPageState
    extends ConsumerState<MaintenanceAssignmentPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _uploadParts();
  }

  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> _carParts = [];
  final imagepicker = ImagePicker();
  File? _selectedImage;
  TextEditingController _carPartNameController = TextEditingController();
  TextEditingController _repairCostController = TextEditingController();
  TextEditingController _carPartNumberController = TextEditingController();
  TextEditingController _carPartConditionController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await imagepicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
      }
    });
  }

  void _uploadParts() async {
    // Once the image is uploaded successfully, fetch CarPartsList
    final carPartsResponse = await http.get(
      Uri.parse(
          'http://vms-api.madi-wka.xyz/maintenancejob/${widget.maintenanceAssignment.id}'),
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer ${ref.read(jwt.jwtTokenProvider)}"
      },
    );

    if (carPartsResponse.statusCode == 200) {
      final List<dynamic> data =
          jsonDecode(carPartsResponse.body)['CarPartsList'];
      setState(() {
        _carParts = data
            .map<Map<String, dynamic>>((part) => {
                  'name': part['Name'],
                  'number': part['Number'],
                  'condition': part['Condition'],
                  'cost': part['Cost'].toString(),
                  'photo': base64Decode(part['image']), // Decode base64 image
                })
            .toList();
      });
    }
  }

  void _addCarPart() async {
    final carPart = {
      "ParentId": widget.maintenanceAssignment.id.toString(),
      "Name": _carPartNameController.text,
      "Number": _carPartNumberController.text,
      "Condition": _carPartConditionController.text,
      "Cost": _repairCostController.text,
    };
    var request = http.MultipartRequest(
      'POST',
      Uri.http('vms-api.madi-wka.xyz', 'maintenancejob/carpart', carPart),
    );
    request.headers.addAll({
      HttpHeaders.authorizationHeader:
          "Bearer ${ref.read(jwt.jwtTokenProvider)}"
    });

    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        _selectedImage!.path,
      ),
    );
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final response = await request.send();
      var responseData = await response.stream.toBytes();
      if (response.statusCode != 201) {
        print(response.statusCode);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not upload the car part. Try again!'),
            ),
          );
        }
        return;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Uploaded successfully'),
            ),
          );
        }
        _uploadParts();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 6,
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
                        const SizedBox(
                          width: 12,
                        ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _carPartNumberController,
                            decoration: const InputDecoration(
                              label: Text('Car Part Number'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _carPartConditionController,
                            decoration: const InputDecoration(
                              label: Text('Car Part Condition'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            _selectedImage != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        //to show image, you type like this.
                        File(_selectedImage!.path),
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                      ),
                    ),
                  )
                : const SizedBox(
                    height: 10,
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _pickImage();
                  },
                  child: Text('Upload Photo'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedImage = null;
                    });
                  },
                  child: Text('Delete Photo'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _addCarPart,
              child: const Text('Add Car Part'),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              child: const Text(
                "Uploaded Car Parts",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
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
                      Text(
                        'Car Part Name:   ${_carParts[index]['name']}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w300),
                      ),
                      Text(
                        'Car Part Number:  ${_carParts[index]['number']}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w300),
                      ),
                      Text(
                        'Car Part Cost:   ${_carParts[index]['cost']}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w300),
                      ),
                      Text(
                        'Car Part Condition:   ${_carParts[index]['condition']}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w300),
                      ),
                      if (_carParts[index]['photo'] != null)
                        Image.memory(_carParts[index]['photo']!),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
