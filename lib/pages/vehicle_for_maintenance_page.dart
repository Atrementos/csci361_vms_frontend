import 'dart:convert';

import 'package:csci361_vms_frontend/models/vehicle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import '../providers/role_provider.dart';
import '../widgets/admin_drawer.dart';
import '../widgets/driver_drawer.dart';
import '../widgets/fueling_person_drawer.dart';
import 'package:csci361_vms_frontend/providers/jwt_token_provider.dart';

class VehicleForMaintenancePage extends ConsumerStatefulWidget {
  final int vehicleId;

  const VehicleForMaintenancePage({Key? key, required this.vehicleId})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _VehicleForMaintenancePageState();
  }
}


class _VehicleForMaintenancePageState extends ConsumerState<VehicleForMaintenancePage> {
  final formKey = GlobalKey<FormState>();
  Vehicle? currentVehicle;

  // Add controllers for the editable fields
  TextEditingController licensePlateController = TextEditingController();
  TextEditingController mileageController = TextEditingController();
  TextEditingController statusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadVehicleInfo();
  }

  void loadVehicleInfo() async {
    final url = Uri.parse('http://vms-api.madi-wka.xyz/vehicle/${widget.vehicleId}');
    final response = await http.get(url);
    var decodedResponse = json.decode(response.body);
    setState(() {
      currentVehicle = Vehicle.fromJson(decodedResponse);

      // Set initial values for controllers
      licensePlateController.text = currentVehicle!.licensePlate;
      mileageController.text = currentVehicle!.mileage.toString();
      statusController.text = currentVehicle!.status; // Replace 'status' with the actual field name
    });
  }

  Future<void> _editVehicle() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      final Map<String, String> queryParams = {
        "Model": currentVehicle!.model,
        "Year": currentVehicle!.year.toString(),
        "LicensePlate": licensePlateController.text,
        "Mileage": mileageController.text,
        "Capacity": currentVehicle!.sittingCapacity.toString(),
        "Status": statusController.text,
        "Type": currentVehicle!.type,
      };

      final url = Uri.parse('http://vms-api.madi-wka.xyz/vehicle/${widget.vehicleId}');
      var response = await http.put(url, body: jsonEncode(queryParams), headers: {
        HttpHeaders.authorizationHeader: "Bearer ${ref.read(jwt.jwtTokenProvider)}",
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*',
      });

      if (response.statusCode == 200) {
        // Optionally, you might want to reload the vehicle information after editing.
        loadVehicleInfo();
      } else {
        throw Exception(response.body);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Details'),
      ),
      body: currentVehicle == null
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display vehicle details here as before
              // ...

              // Add TextFormFields for editing
              const SizedBox(height: 16),
              TextFormField(
                controller: licensePlateController,
                decoration: const InputDecoration(labelText: 'License Plate'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a license plate';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: mileageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Mileage'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter mileage';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: statusController,
                decoration: const InputDecoration(labelText: 'Status'),
                validator: (value) {
                  // Add validation for status if needed
                  return null;
                },
              ),

              // Add an edit button
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _editVehicle,
                child: Text('Edit Vehicle'),
              ),
            ],
          ),
        ),
      ),
      drawer: ref.read(userRole.roleProvider) == null
          ? const CircularProgressIndicator()
          : ref.read(userRole.roleProvider) == 'Driver'
          ? const DriverDrawer()
          : ref.read(userRole.roleProvider) == 'Fueling'
          ? const FuelingPersonDrawer()
          : null,
    );
  }
}
