import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import '../models/vehicle.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MapPageState();
  }
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  LocationData? currentLocation;
  Location location = Location();
  Set<Marker> markers = <Marker>{};

  Future<List<Vehicle>> fetchVehicleModels() async {
    final response = await http.get(Uri.http('vms-api.madi-wka.xyz', '/vehicle/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) {
        return Vehicle.fromJson(json);
      }).toList();
    } else {
      throw Exception('Failed to load vehicle models');
    }
  }

  @override
  void initState() {
    super.initState();

    location.onLocationChanged.listen((LocationData cLoc) {
      setState(() {
        currentLocation = cLoc;
        updateMarkers();
      });
    });

    fetchVehicleModels().then((vehicles) {
      setState(() {
        markers.addAll(vehicles.map((vehicle) {
          return Marker(
            markerId: MarkerId(vehicle.vehicleId.toString()),
            position: LatLng(
              double.parse(vehicle.currentLocation.elementAt(0)),
              double.parse(vehicle.currentLocation.elementAt(1)),
            ),
            infoWindow: InfoWindow(
              title: 'Vehicle id: ${vehicle.vehicleId}, Model: ${vehicle.model}, License Plate: ${vehicle.licensePlate}',
            ),
          );
        }));
      });
    });
  }

  void updateMarkers() {
    markers.add(
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
        infoWindow: const InfoWindow(title: 'Your Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Locations on Map'),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(currentLocation?.latitude ?? 0, currentLocation?.longitude ?? 0),
          zoom: 15.0,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: markers,
      ),
    );
  }
}

