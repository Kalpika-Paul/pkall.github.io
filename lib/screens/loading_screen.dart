import 'package:flutter/material.dart';
import '../services/network.dart';
import 'location_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'city_screen.dart'; // Adjust the path as per your project structure
import '../services/weather.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final String apiKey =
      'a4279bd28f6dcb4a7797de3f15d4cd3d'; // Replace with your API key
  late String weatherUrl;

  @override
  void initState() {
    super.initState();
    getLocationAndWeather();
  }

  Future<void> getLocationAndWeather() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      double latitude = position.latitude;
      double longitude = position.longitude;

      String weatherUrl =
          "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric";

      var weatherData = await getWeatherData(weatherUrl);
      String cityName = weatherData['name']; // Extract city name from the data

      navigateToLocationScreen(cityName, weatherData);
    } catch (e) {
      print(e);
    }
  }

  Future<void> getWeatherByCityName(String cityName) async {
    try {
      String weatherUrl =
          "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric";

      var weatherData = await getWeatherData(weatherUrl);
      navigateToLocationScreen(cityName, weatherData);
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> getWeatherData(String url) async {
    NetworkHelper networkHelper = NetworkHelper(url);
    return await networkHelper.getData();
  }

  void navigateToLocationScreen(String cityName, dynamic weatherData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LocationScreen(
            locationWeather: weatherData,
            cityName: cityName,
            onSearch: getWeatherByCityName, // Pass the search function
            getLocationWeather:
                getLocationAndWeather, // Pass the method reference
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.09),
              BlendMode.darken,
            ),
          ),
        ),
        child: Center(
          child: SpinKitDoubleBounce(
            color: Colors.white,
            size: 100.0,
          ),
        ),
      ),
    );
  }
}
