import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMapsView extends StatefulWidget {
  const GoogleMapsView({super.key});

  @override
  State<GoogleMapsView> createState() => _GoogleMapsViewState();
}

class _GoogleMapsViewState extends State<GoogleMapsView> {
  final Completer<GoogleMapController> _controller = Completer();
  final LatLng sourceLocation = const LatLng(37.33500926, -122.03272188);
  final LatLng destination =  const LatLng(37.334429383, -122.06600055);

  LocationData? currentLocation;

  void getCurrentLocation() async {
    Location location = Location();


    location.getLocation().then((location) {
      if(mounted) {
        setState(() {
          currentLocation = location;
        });
      }
    });

    GoogleMapController googleMapController = await _controller.future;


    location.onLocationChanged.listen((newLoc) {

      if(mounted) {
        setState(() {
          currentLocation = newLoc;
        });
        googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(zoom: 14.5, target: LatLng(newLoc.latitude!, newLoc.longitude!,))));

      }
    });
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentLocation == null
          ? const Text('Loading')
          : GoogleMap(
        initialCameraPosition:
      CameraPosition(
          target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!,),
          zoom: 14.5,
      ),
      markers: {
        Marker(
          markerId: const MarkerId('source'),
          position: sourceLocation,
        ),
        Marker(
          markerId: const MarkerId('destination'),
          position: destination,
        ),
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
        ),
      },
        onMapCreated: (mapController) {
          _controller.complete(mapController);
        },
      ),
    );
  }
}