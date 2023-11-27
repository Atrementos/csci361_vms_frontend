import 'dart:convert';
import 'dart:io';

import 'package:csci361_vms_frontend/models/vehicle.dart';
import 'package:csci361_vms_frontend/pages/assign_driver_page.dart';
import 'package:csci361_vms_frontend/pages/user_details_page.dart';
import 'package:csci361_vms_frontend/pages/view_vehicle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../providers/jwt_token_provider.dart';
import '../providers/role_provider.dart';
import '../widgets/driver_drawer.dart';
import '../widgets/fueling_person_drawer.dart';

class VehicleDetailsPage extends ConsumerStatefulWidget {
  final int vehicleId;
  const VehicleDetailsPage({super.key, required this.vehicleId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _VehicleDetailsPageState();
  }
}

class _VehicleDetailsPageState extends ConsumerState<VehicleDetailsPage> {
  final formKey = GlobalKey<FormState>();
  Vehicle? currentVehicle;
  Map<String, dynamic>? vehicle;

  @override
  void initState() {
    super.initState();
    loadVehicleInfo();
  }

  void seeAssignedDriver() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) {
          return UserDetailsPage(
              userId: currentVehicle!.assignedDriver!.driverId);
        },
      ),
    );
  }

  void loadVehicleInfo() async {
    final url =
        Uri.parse('http://vms-api.madi-wka.xyz/vehicle/${widget.vehicleId}');
    final response = await http.get(url);
    var decodedResponse = json.decode(response.body);
    setState(() {
      vehicle = decodedResponse;
      currentVehicle = Vehicle.fromJson(decodedResponse);
    });
  }

  void viewVehicleOnMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) {
          return ViewVehiclePage(currentLocation:
            currentVehicle!.currentLocation
          );
        },
      ),
    );
  }

  void updateVehicleLocation() async {
    Position position = await getCurrentLocation();
    final List<dynamic> positions = [position.latitude.toString(), position.longitude.toString()];
    final postBody = {
      'CurrentLocation': positions,
    };
    final url = Uri.http('vms-api.madi-wka.xyz', '/vehicle/${currentVehicle?.vehicleId}/location');
    if (kDebugMode) {
      print(url);
    }
    final response = await http.post(
      url,
      body: json.encode(postBody),
      headers: {
        HttpHeaders.authorizationHeader:
        'Bearer ${ref.read(jwt.jwtTokenProvider)}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      if (context.mounted) {
        loadVehicleInfo();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vehicle location updated successfully!'),
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to update vehicle location: ${response.body}  ${response.statusCode}'),
          ),
        );
      }
    }
  }

  Future<Position> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (kDebugMode) {
          print('Location permission denied.');
        }
        return Future.error('Location permission denied.');
      }
      Position position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting current location: $e');
      }
      return Future.error('Error getting current location: $e');
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Vehicle ID: ${currentVehicle!.vehicleId}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.white70,
                          fontSize: 24,
                        ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    'Model: ${currentVehicle!.model}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.white70,
                          fontSize: 24,
                        ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    'Year: ${currentVehicle!.year}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.white70,
                          fontSize: 24,
                        ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    'License Plate: ${currentVehicle!.licensePlate}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.white70,
                          fontSize: 24,
                        ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    'Mileage: ${currentVehicle!.mileage}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.white70,
                          fontSize: 24,
                        ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    'Sitting capacity: ${currentVehicle!.sittingCapacity}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.white70,
                          fontSize: 24,
                        ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    'Status: ${currentVehicle!.status}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.white70,
                          fontSize: 24,
                        ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      Text(
                        'Current Location on Map:',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.white70,
                          fontSize: 24,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.location_on, color: Colors.blueGrey),
                        onPressed: () {
                          viewVehicleOnMap();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  if (ref.read(userRole.roleProvider) == 'Driver')
                    Row(
                      children: [
                        Text(
                          'Update current location of the vehicle:',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.white70,
                            fontSize: 24,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_location, color: Colors.blueGrey),
                          onPressed: () {
                            // Perform API call to update vehicle location
                            updateVehicleLocation();
                          },
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 12,
                  ),
                  vehicle!['AssignedDriver'] != null
                      ? ElevatedButton(
                          onPressed: () {
                            seeAssignedDriver();
                          },
                          child: const Text('See assigned driver'),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              useSafeArea: true,
                              isScrollControlled: true,
                              context: context,
                              builder: (ctx) => AssignDriverPage(
                                  vehicleId: currentVehicle!.vehicleId),
                            );
                          },
                          child: const Text('Assign a driver'),
                        ),
                ],
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
