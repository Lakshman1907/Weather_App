import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
class LocationForm extends StatefulWidget {
  @override
  _LocationFormState createState() => _LocationFormState();
}

class _LocationFormState extends State<LocationForm> {
  final TextEditingController _locationController = TextEditingController();
  bool _isLocationNameEmpty = true;
  String _currentLocation = '';

  @override
  void initState() {
    super.initState();
    _locationController.addListener(() {
      setState(() {
        _isLocationNameEmpty = _locationController.text.isEmpty;
      });
    });
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return;
    }
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      );
      setState(() {
        _currentLocation = '${position.latitude},${position.longitude}';
      });
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      );
      setState(() {
        _currentLocation = '${position.latitude},${position.longitude}';
      });
    } catch (e) {
      if (e is TimeoutException) {
        print('Timeout');
      }
      Future<void> _callWeatherApi(String location) async {
        // Call weather API with location
        print('Calling weather API with location: $location');
      }
    }
  }
  Future<void> _callWeatherApi(String location) async {
    // Call weather API with location
    print('Calling weather API with location: $location');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: 'Enter location name',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text(_isLocationNameEmpty ? 'Save' : 'Update'),
              onPressed: () {
                String locationName = _locationController.text;
                String location = '';
                if (locationName.isEmpty) {
                  location = _currentLocation;
                } else {
                  location = locationName;
                }
                _callWeatherApi(location);
              },
            ),

          ],
        ),
      ),
    );
  }


  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }
}


