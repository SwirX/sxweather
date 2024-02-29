import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:simple_progress_indicators/simple_progress_indicators.dart';
import 'package:sxweather/classes/weather.dart';
import 'package:sxweather/service/weather.dart';
import 'package:sxweather/widgets/suncycle.dart';
import 'package:sxweather/widgets/weatherIcon.dart';
import 'package:weather_icons/weather_icons.dart';

class FullWeather extends StatefulWidget {
  const FullWeather({
    super.key,
    required this.weather,
  });

  final Weather weather;

  @override
  State<FullWeather> createState() => _FullWeatherState();
}

class _FullWeatherState extends State<FullWeather> {
  final weatherService =
      WeatherService(apiKey: "e640b569032c2a8f056fe955962a2ebc");
  Weather? weather;
  double offset = 0;
  DateTime currentTime = DateTime.now();
  Timer? timer;

  _fetchWeather() async {
    Position position = await getCurrentLocation();
    try {
      Weather tmpWeather = await weatherService.getWeatherFromCoords(
          position.longitude, position.latitude, "metric", "en");

      setState(() {
        weather = tmpWeather;
        offset = (MediaQuery.of(context).size.width / 4) -
            ((("${weather!.maxTemperature}".length + 1) +
                ("${weather!.minTemperature}".length + 1)));
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      weather = widget.weather;
    });
    timer = Timer.periodic(const Duration(minutes: 5), (timer) {
      setState(() {
        currentTime = DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 162, 255),
        foregroundColor: const Color(0xffdcdcdc),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(CupertinoIcons.square_list))
        ],
        title: //city name
            Hero(
          tag: "city_name",
          child: Text(
            weather?.city ?? "Fetching data",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
          ),
        ),
      ),
      body: Container(
        alignment: AlignmentDirectional.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 0, 162, 255),
              Color.fromARGB(255, 80, 134, 220)
            ],
            begin: AlignmentDirectional(0, -1),
            end: AlignmentDirectional(0, 1),
            stops: [0, 1],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              // weather icon
              Hero(
                tag: "weather_icon",
                child: WeatherIcon(
                  weatherId: weather!.weatherId,
                  size: 128,
                ),
              ),
              // temperature
              Hero(
                tag: "temperature",
                child: Align(
                  child: Stack(
                    children: [
                      Stack(
                        children: [
                          Text(
                            " ${weather!.temperature.round()} ",
                            style: const TextStyle(
                              color: Color(0xffdcdcdc),
                              fontSize: 128,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Positioned(
                            right: -5,
                            child: Text(
                              "°",
                              style: TextStyle(
                                color: Color(0xffdcdcdc),
                                fontSize: 128,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 15,
                        left: MediaQuery.of(context).size.width / 5.225,
                        child: Align(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${weather!.maxTemperature.round()}",
                                style: const TextStyle(
                                  color: Color(0xffdcdcdc),
                                  fontSize: 14,
                                ),
                              ),
                              Icon(
                                CupertinoIcons.up_arrow,
                                color: Colors.red[600],
                                size: 14,
                              ),
                              Text(
                                "${weather!.minTemperature.round()}",
                                style: const TextStyle(
                                  color: Color(0xffdcdcdc),
                                  fontSize: 14,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                CupertinoIcons.down_arrow,
                                color: Colors.blue[800],
                                size: 14,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // condition
              Hero(
                tag: "condition",
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    weather?.weatherDescription ?? "fetching data",
                    style: const TextStyle(
                      color: Color(0xffdcdcdc),
                      fontSize: 22,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // addtional info
              Hero(
                tag: "info_row",
                child: Container(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x885090ff),
                        blurRadius: 50,
                        spreadRadius: 15,
                      )
                    ],
                  ),
                  child: GlassContainer.clearGlass(
                    height: MediaQuery.of(context).size.height * .125,
                    width: MediaQuery.of(context).size.width - 25,
                    borderRadius: BorderRadius.circular(45),
                    blur: 1,
                    color: Colors.black26,
                    borderWidth: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: Icon(
                                    CupertinoIcons.wind,
                                    color: Color(0xffdcdcdc),
                                  ),
                                ),
                                Text(
                                  "${weather!.windspeed} m/s",
                                  style: const TextStyle(
                                    color: Color(0xffdcdcdc),
                                    fontSize: 16,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  "Wind",
                                  style: TextStyle(
                                    color: Color(0x77dcdcdc),
                                    fontSize: 10,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              color: const Color(0x88dcdcdc),
                              width: 1,
                              height: MediaQuery.of(context).size.height * .05,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: Icon(
                                    CupertinoIcons.drop,
                                    color: Color(0xffdcdcdc),
                                  ),
                                ),
                                Text(
                                  "${weather!.humidity} %",
                                  style: const TextStyle(
                                    color: Color(0xffdcdcdc),
                                    fontSize: 16,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  "Humidity",
                                  style: TextStyle(
                                    color: Color(0x77dcdcdc),
                                    fontSize: 10,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              color: const Color(0x88dcdcdc),
                              width: 1,
                              height: MediaQuery.of(context).size.height * .05,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: Icon(
                                    WeatherIcons.barometer,
                                    color: Color(0xffdcdcdc),
                                  ),
                                ),
                                Text(
                                  "${weather!.pressure} hPa",
                                  style: const TextStyle(
                                    color: Color(0xffdcdcdc),
                                    fontSize: 16,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  "Pressure",
                                  style: TextStyle(
                                    color: Color(0x77dcdcdc),
                                    fontSize: 10,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.only(top: 8, start: 4, end: 4),
                    child: GlassContainer.clearGlass(
                      borderRadius: BorderRadius.circular(8),
                      elevation: 5,
                      blur: 15,
                      color: Colors.black26,
                      borderWidth: 0,
                      height: 72,
                      width: 72,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              WeatherIcons.thermometer,
                              color: Color(0xffdcdcdc),
                            ),
                          ),
                          const Text(
                            "Feels like",
                            style: TextStyle(
                              color: Color(0xffdcdcdc),
                              fontSize: 14,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${weather!.feelLikeTemp}°C",
                            style: const TextStyle(
                              color: Color(0xffdcdcdc),
                              fontSize: 12,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.only(top: 8, start: 4, end: 4),
                    child: GlassContainer.clearGlass(
                      borderRadius: BorderRadius.circular(8),
                      elevation: 5,
                      blur: 15,
                      color: Colors.black26,
                      borderWidth: 0,
                      height: 72,
                      width: 72,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              WeatherIcons.wind_direction,
                              color: Color(0xffdcdcdc),
                            ),
                          ),
                          const Text(
                            "Wind Direction",
                            style: TextStyle(
                              color: Color(0xffdcdcdc),
                              fontSize: 12,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${weather!.windDirection}°",
                            style: const TextStyle(
                              color: Color(0xffdcdcdc),
                              fontSize: 12,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.only(top: 8, start: 4, end: 4),
                    child: GlassContainer.clearGlass(
                      borderRadius: BorderRadius.circular(8),
                      elevation: 5,
                      blur: 15,
                      color: Colors.black26,
                      borderWidth: 0,
                      height: 72,
                      width: 72,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              CupertinoIcons.wind,
                              color: Color(0xffdcdcdc),
                            ),
                          ),
                          const Text(
                            "Wind Gust",
                            style: TextStyle(
                              color: Color(0xffdcdcdc),
                              fontSize: 14,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${weather!.gust}m/s",
                            style: const TextStyle(
                              color: Color(0xffdcdcdc),
                              fontSize: 12,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              //  ROW 2
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.only(top: 8, start: 4, end: 4),
                    child: GlassContainer.clearGlass(
                      borderRadius: BorderRadius.circular(8),
                      elevation: 5,
                      blur: 15,
                      color: Colors.black26,
                      borderWidth: 0,
                      height: 72,
                      width: 72,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.beach_access,
                              color: Color(0xffdcdcdc),
                            ),
                          ),
                          const Text(
                            "Sea Level",
                            style: TextStyle(
                              color: Color(0xffdcdcdc),
                              fontSize: 14,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${weather!.seaLevel}hPa",
                            style: const TextStyle(
                              color: Color(0xffdcdcdc),
                              fontSize: 12,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.only(top: 8, start: 4, end: 4),
                    child: GlassContainer.clearGlass(
                      borderRadius: BorderRadius.circular(8),
                      elevation: 5,
                      blur: 15,
                      color: Colors.black26,
                      borderWidth: 0,
                      height: 72,
                      width: 72,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.directions_walk,
                              color: Color(0xffdcdcdc),
                            ),
                          ),
                          const Text(
                            "Ground Level",
                            style: TextStyle(
                              color: Color(0xffdcdcdc),
                              fontSize: 12,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${weather!.groundLevel}hPa",
                            style: const TextStyle(
                              color: Color(0xffdcdcdc),
                              fontSize: 12,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.only(top: 8, start: 4, end: 4),
                    child: GlassContainer.clearGlass(
                      borderRadius: BorderRadius.circular(8),
                      elevation: 5,
                      blur: 15,
                      color: Colors.black26,
                      borderWidth: 0,
                      height: 72,
                      width: 72,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              WeatherIcons.cloud,
                              color: Color(0xffdcdcdc),
                            ),
                          ),
                          const Text(
                            "Cloudiness",
                            style: TextStyle(
                              color: Color(0xffdcdcdc),
                              fontSize: 14,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${weather!.cloudiness}%",
                            style: const TextStyle(
                              color: Color(0xffdcdcdc),
                              fontSize: 12,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DateTime.now().millisecondsSinceEpoch /
                                    weather!.sunset.millisecondsSinceEpoch >=
                                1
                            ? const Icon(WeatherIcons.sunset)
                            : const Icon(WeatherIcons.sunrise),
                        Spacer(),
                        DateTime.now().millisecondsSinceEpoch -
                                    weather!.sunset.millisecondsSinceEpoch >=
                                1
                            ? const Icon(WeatherIcons.sunrise)
                            : const Icon(WeatherIcons.sunset),
                      ],
                    ),
                  ),
                  SunCycleProgress(
                      sunrise: weather!.sunrise, sunset: weather!.sunset),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
