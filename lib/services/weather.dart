import 'package:http/http.dart'
    as http; // Import HTTP package or any other package you're using for HTTP requests
import 'dart:convert'; // Import dart:convert

class Weather {
  final String apiKey =
      'a4279bd28f6dcb4a7797de3f15d4cd3d'; // Add your API key here

  Future<dynamic> getCityWeather(String cityName) async {
    String weatherUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric';

    http.Response response = await http.get(Uri.parse(weatherUrl));

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print('Error: ${response.statusCode}');
      return null;
    }
  }
}
