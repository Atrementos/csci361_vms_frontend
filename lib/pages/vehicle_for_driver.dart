import 'package:flutter/material.dart';

import '../data/dummy_vehicles.dart';
import '../models/vehicle.dart';
import '../widgets/driver_drawer.dart';

class VehiclePage extends StatelessWidget {
  final Vehicle vehicle = dummyVehicles[0];

  VehiclePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5, // Add elevation to the card
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildInfoRow('Model', vehicle.model),
                buildInfoRow('Year', vehicle.year.toString()),
                buildInfoRow('License Plate', vehicle.licensePlate),
                buildInfoRow('Mileage', vehicle.mileage.toString()),
                buildInfoRow('Capacity', vehicle.sittingCapacity.toString()),
                buildInfoRow('Type', vehicle.type),
                // Add more details as needed
              ],
            ),
          ),
        ),
      ),
      drawer: const DriverDrawer(),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18, // Set font size to 18
              color: Colors.white, // Set text color to white
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18, // Set font size to 18
              color: Colors.white, // Set text color to white
            ),
          ),
        ],
      ),
    );
  }
}
