import 'package:csci361_vms_frontend/widgets/driver_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViewVehiclePage extends StatefulWidget {
  final List<dynamic> currentLocation;
  const ViewVehiclePage({Key? key, required this.currentLocation}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ViewVehiclePageState();
  }
}

class _ViewVehiclePageState extends State<ViewVehiclePage> {
  late GoogleMapController mapController;

  late LatLng _center;

  @override
  void initState() {
    super.initState();
    _center = LatLng(
      double.parse(widget.currentLocation.elementAt(0)),
      double.parse(widget.currentLocation.elementAt(1)),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Vehicle Location'),
        elevation: 2,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 16.0,
        ),
        markers: {
          Marker(
            markerId: const MarkerId("vehicle"),
            position: _center,
            infoWindow: const InfoWindow(title: "Vehicle Location"),
          ),
        },
      ),
      drawer: const DriverDrawer(),
    );
  }
}

