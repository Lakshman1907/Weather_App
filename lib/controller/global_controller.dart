import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomepageScreen extends StatefulWidget {
  @override
  _HomepageScreenState createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  String _cityName = 'London';
  double _temperature = 0.0;
  String _description = '';
  bool _isLoading = true;

  void _getWeatherData() async {
    final response = await http.get(Uri.parse(
        'http://api.weatherapi.com/v1/current.json?key=96ef7f147f8f4e75802122037232603&q=$_cityName&aqi=yes'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _temperature = data['current']['temp_c'];
        _description = data['current']['condition']['text'];
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }

  @override
  void initState() {
    super.initState();
    _getWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Weather App'),
        ),
        body: Center(
          child: _isLoading
              ? CircularProgressIndicator()
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Current Temperature:',
                style: TextStyle(fontSize: 24.0),
              ),
              Text(
                '${_temperature.toStringAsFixed(1)} °C',
                style: TextStyle(fontSize: 48.0),
              ),
              Text(
                _description,
                style: TextStyle(fontSize: 24.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}