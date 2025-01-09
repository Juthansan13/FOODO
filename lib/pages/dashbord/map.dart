import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // ignore: unused_field
  late GoogleMapController _mapController;
  LatLng? _currentLocation;
  final Set<Polyline> _polylines = {}; // Store polylines

  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  void _drawPolyline() {
  if (_currentLocation != null &&
      _latController.text.isNotEmpty &&
      _lngController.text.isNotEmpty) {
    LatLng destination = LatLng(
      double.tryParse(_latController.text) ?? 0.0,
      double.tryParse(_lngController.text) ?? 0.0,
    );

    Polyline polyline = Polyline(
      polylineId: const PolylineId('route'),
      points: [_currentLocation!, destination], // Start and end points
      color: Colors.blue,
      width: 5,
    );

    setState(() {
      _polylines.add(polyline); // Add the polyline to the set
    });
  } else {
    _showErrorDialog('Please enter valid latitude and longitude.');
  }
}


  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Destination'),
      ),
      body: Column(
        children: [
          _currentLocation != null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Current Location: ${_currentLocation!.latitude}, ${_currentLocation!.longitude}'),
                )
              : const Center(child: CircularProgressIndicator()),
          _currentLocation != null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _latController,
                    decoration: const InputDecoration(labelText: 'Latitude'),
                    keyboardType: TextInputType.number,
                  ),
                )
              : Container(),
          _currentLocation != null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _lngController,
                    decoration: const InputDecoration(labelText: 'Longitude'),
                    keyboardType: TextInputType.number,
                  ),
                )
              : Container(),
          ElevatedButton(
            onPressed: _drawPolyline,
            child: const Text('Draw Polyline'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentLocation != null) {
            Navigator.pop(context, {
              'latitude': _latController.text,
              'longitude': _lngController.text,
            });
          }
        },
        child: const Icon(Icons.check),
      ),
      bottomNavigationBar: _currentLocation == null
          ? null
          : SizedBox(
              height: 250,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _currentLocation!,
                  zoom: 14.0,
                ),
                onMapCreated: (controller) {
                  _mapController = controller;
                },
              ),
            ),
    );
  }
}
