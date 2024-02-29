import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:sxweather/classes/weather.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  WeatherService({required this.apiKey});

  Future<Weather> getWeatherFromCoords(
      double lon, double lat, String units, String lang) async {
    final response = await http.get(Uri.parse(
        "$BASE_URL?appid=$apiKey&lon=$lon&lat=$lat&units=$units&lang=$lang"));
    print(
        "\n\n\nreq: \"$BASE_URL?appid=$apiKey&lon=$lon&lat=$lat&units=$units&lang=$lang\"\n\n\n");

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          "Couldn't fetch the weather data\nstatus code: ${response.statusCode}");
    }
  }
}

Future<Position> getCurrentLocation() async {
  LocationPermission locationPermission = await Geolocator.checkPermission();
  if (locationPermission == LocationPermission.denied) {
    locationPermission = await Geolocator.requestPermission();
  }

  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  return position;
}
