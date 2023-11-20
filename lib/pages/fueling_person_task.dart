import 'dart:convert';
import 'dart:io';
import 'package:csci361_vms_frontend/models/vehicle.dart';
import 'package:csci361_vms_frontend/widgets/fueling_person_drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FuelingDetailsPage extends StatefulWidget {
  final Vehicle vehicle; // Make the Vehicle parameter nullable

  const FuelingDetailsPage({Key? key, required this.vehicle}) : super(key: key);

  @override
  _FuelingDetailsPageState createState() => _FuelingDetailsPageState();
}

class _FuelingDetailsPageState extends State<FuelingDetailsPage> {
  String _fuelAmount = "";
  String _fuelingTask = "";
  String _description = "";
  String _date = "";
  String _cost = "";
  String _fuelRefilled = "";
  String _gasStationName = "";
  File? _beforeImage;
  File? _afterImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Fueling Details${widget.vehicle != null ? ' - ${widget.vehicle!.model}' : ''}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ... (unchanged code)

            Text(
              'Change Fuel Amount',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Fuel Amount',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a fuel amount';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _fuelAmount = value;
                    },
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle the logic to change fuel amount here
                    // You can use the _fuelAmount value and make the necessary API calls.
                  },
                  child: const Text('Change'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Fueling Task Details',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              onChanged: (value) {
                _description = value;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Date',
              ),
              onChanged: (value) {
                _date = value;
              },
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Cost',
              ),
              onChanged: (value) {
                _cost = value;
              },
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Fuel Refilled (in liters or gallons)',
              ),
              onChanged: (value) {
                _fuelRefilled = value;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Gas Station Name',
              ),
              onChanged: (value) {
                _gasStationName = value;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle the logic to upload before image
                  },
                  child: const Text('Upload Before Image'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    // Handle the logic to upload after image
                  },
                  child: const Text('Upload After Image'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle the logic to submit the fueling task details
                // You can use the entered values and uploaded images for API calls.
              },
              child: const Text('Submit Task'),
            ),
          ],
        ),
      ),
    );
  }
}
