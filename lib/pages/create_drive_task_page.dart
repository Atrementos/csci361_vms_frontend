import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:csci361_vms_frontend/providers/jwt_token_provider.dart';
class CreateDriveTaskPage extends ConsumerStatefulWidget {
  final int driverId;

  const CreateDriveTaskPage({super.key, required this.driverId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _CreateDriveTaskPageState();
  }
}

class _CreateDriveTaskPageState extends ConsumerState<CreateDriveTaskPage> {
  TextEditingController startStreetController = TextEditingController();
  TextEditingController startNumberController = TextEditingController();
  TextEditingController endStreetController = TextEditingController();
  TextEditingController endNumberController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<void> createTask() async {
    Map<String, dynamic> taskData = {
      'StartLocation': [startStreetController.text, startNumberController.text],
      'EndLocation': [endStreetController.text, endNumberController.text],
      'Description': descriptionController.text,
      'DriverId': widget.driverId.toString(),
    };

    try {
      final url = Uri.parse('http://vms-api.madi-wka.xyz/task/');
      var response =
      await http.post(url, body: jsonEncode(taskData), headers: {
        HttpHeaders.authorizationHeader:
        "Bearer ${ref.read(jwt.jwtTokenProvider)}",
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*',
      });
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task created successfully!', style: TextStyle(color: Colors.white),),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.cyan,

          ),
        );
      } else {
        print(response.statusCode);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create task'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      throw Exception(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildLocationInput(
                'Start Location',
                startStreetController,
                startNumberController,
              ),
              _buildLocationInput(
                'End Location',
                endStreetController,
                endNumberController,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    createTask();
                  }
                },
                child: Text('Create Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationInput(
      String label,
      TextEditingController streetController,
      TextEditingController numberController,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: streetController,
                decoration: InputDecoration(labelText: 'Street'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter street';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: numberController,
                decoration: InputDecoration(labelText: 'Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}