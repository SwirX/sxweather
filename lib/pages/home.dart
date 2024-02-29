import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:sxweather/classes/weather.dart';
import 'package:sxweather/pages/locations.dart';
import 'package:sxweather/pages/weather.dart';
import 'package:sxweather/service/weather.dart';
import 'package:sxweather/widgets/weatherIcon.dart';
import 'package:weather_icons/weather_icons.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final weatherService =
      WeatherService(apiKey: "e640b569032c2a8f056fe955962a2ebc");
  Weather? weather;
  double offset = 0;

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
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff202020),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .75,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(35)),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 80, 134, 220),
                  blurRadius: 50,
                  spreadRadius: 15,
                )
              ],
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 0, 162, 255),
                  Color.fromARGB(255, 80, 134, 220)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Spacer(),
                //city name
                Hero(
                  tag: "city_name",
                  child: Text(
                    weather?.city ?? "Fetching data",
                    style: const TextStyle(
                      color: Color(0xffdcdcdc),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
                // additional info
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
                                height:
                                    MediaQuery.of(context).size.height * .05,
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
                                height:
                                    MediaQuery.of(context).size.height * .05,
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
                Spacer(),
                GestureDetector(
                  onVerticalDragUpdate: (details) {
                    print("dragging");
                    if (details.delta.dy < 5 && details.localPosition.dy < 0) {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          barrierDismissible: true,
                          fullscreenDialog: true,
                          builder: (context) {
                            return const Locations();
                          },
                        ),
                      );
                    } else if (details.delta.dy < 5 &&
                        details.localPosition.dy > 0) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          allowSnapshotting: true,
                          builder: (context) {
                            return FullWeather(
                              weather: weather!,
                            );
                          },
                        ),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 100,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color(0xffcdcdcd)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
