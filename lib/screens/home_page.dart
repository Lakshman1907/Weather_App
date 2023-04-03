import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MediaQuery(
        data: MediaQueryData(),
        child: HomePage(),
      ),
    ),
  );
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  late TextEditingController _locationController;
  late String _locationName = '';
  late String _temperatureText='';
  late double _temperatureCelsius=0.0;
  late String _temperatureIcon='';

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController();
    _loadLocation();
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  void _loadLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _locationName = prefs.getString('locationName')!;
      if (_locationName.isNotEmpty) {
        _locationController.text = _locationName;
        _getWeatherData(_locationName);
      } else {
        // Check if text field is empty
        if (_locationController.text.isEmpty) {
          _getWeatherDataByLocation();
        } else {
          _getWeatherData(_locationController.text);
        }
      }
    });
  }


  void _saveLocation(String location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('locationName', location);
  }

  void _getWeatherData(String location) async {
    // Call weather API to get data
    // Use http package or any other package you prefer to make the API call
    // Example API endpoint: https://api.weatherapi.com/v1/current.json?key=YOUR_API_KEY&q=LOCATION_NAME
    // Example API response format: {"current": {"temp_c": 8.0, "condition": {"text": "Clear", "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png"}}}
    String apiKey = '96ef7f147f8f4e75802122037232603';
    String url = 'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$location&aqi=no';
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        _temperatureCelsius = data['current']['temp_c'];
        _temperatureText = data['current']['condition']['text'];
        _temperatureIcon = 'https:' + data['current']['condition']['icon'];
      });
    } else {
      // Handle API error
      setState(() {
        double _temperatureCelsius;
        String _temperatureText;
        String _temperatureIcon;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to get weather data for $_locationName'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _getWeatherDataByLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    String latitude = position.latitude.toString();
    String longitude = position.longitude.toString();
    setState(() {
      _locationName = '$latitude,$longitude';
      _locationController.text = _locationName; // update the text field with the location
    });
    _getWeatherData(_locationName);
  }



  void _onSaveButtonPressed() {
    setState(() {
      _locationName = _locationController.text;
      if (_locationName.isEmpty) {
        _getWeatherDataByLocation();
      } else {
        _saveLocation(_locationName);
        _getWeatherData(_locationName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Weather App',textAlign:TextAlign.center),
          leading:
          IconButton(onPressed: (
              ){
            Navigator.pop(context);
          },
              icon: Icon(Icons.arrow_back_ios_new)),

        ),
        body: Column(
          children: <Widget>[
            SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: 'Enter location',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _onSaveButtonPressed,
              child: Text('Get Weather'),
            ),
            SizedBox(height: 16),
            Column(
              children: [
                Text(
                  '${_temperatureCelsius.toStringAsFixed(1)} °C',
                  style: TextStyle(fontSize: 32),
                ),
                Text(
                  _temperatureText,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Image.network(
                  _temperatureIcon,
                  width: 64,
                  height: 64,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
