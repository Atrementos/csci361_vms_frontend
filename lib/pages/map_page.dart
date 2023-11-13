import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MapPageState();
  }
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  late LocationData currentLocation;
  Location location = Location();
  Set<Marker> markers = Set<Marker>();
  List<LatLng> locations = const [
    LatLng(51.090786173856785, 71.40315888775255), // Marker B
    LatLng(51.09827895151411, 71.40959618928471),
    LatLng(51.09947822226643, 71.40624879252304),
    LatLng(51.09906050229118, 71.40135644331232),
  ];

  @override
  void initState() {
    super.initState();
    location.onLocationChanged.listen((LocationData cLoc) {
      setState(() {
        currentLocation = cLoc;
      });
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target:
                LatLng(currentLocation.latitude!, currentLocation.longitude!),
            zoom: 15.0,
          ),
        ),
      );
      updateMarkers();
    });

    markers.addAll(locations.map((LatLng latLng) {
      return Marker(
        markerId: MarkerId(latLng.toString()),
        position: latLng,
        infoWindow: const InfoWindow(title: 'Location'),
      );
    }));

    markers.add(
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: const LatLng(0, 0), // Initial position, will be updated later
        infoWindow: const InfoWindow(title: 'Your Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );
  }

  void updateMarkers() {
    markers.add(
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(currentLocation.latitude!, currentLocation.longitude!),
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
        initialCameraPosition: const CameraPosition(
          target: LatLng(0, 0),
          zoom: 15.0,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: markers,
      ),
    );
  }
}
