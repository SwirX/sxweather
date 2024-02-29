import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherIcon extends StatefulWidget {
  const WeatherIcon({
    super.key,
    required this.weatherId,
    this.color = const Color(0xffdcdcdc),
    this.size = 16,
  });

  final int weatherId;
  final Color color;
  final double size;

  @override
  State<WeatherIcon> createState() => _WeatherIconState();
}

class _WeatherIconState extends State<WeatherIcon> {
  @override
  Widget build(BuildContext context) {
    final id = widget.weatherId;
    final color = widget.color;
    final size = widget.size;
    var icon = WeatherIcons.day_sunny;
    switch (id) {
      case 200:
      case 201:
      case 202:
      case 210:
      case 211:
      case 212:
      case 221:
      case 230:
      case 231:
      case 232:
        icon = WeatherIcons.thunderstorm;
      case 300:
      case 301:
      case 302:
      case 310:
      case 311:
      case 312:
      case 314:
      case 321:
        icon = WeatherIcons.rain_mix;
      case 500:
      case 501:
      case 502:
      case 503:
      case 504:
      case 511:
      case 520:
      case 521:
      case 522:
      case 531:
        icon = WeatherIcons.rain;
      case 600:
      case 601:
      case 602:
      case 611:
      case 612:
      case 613:
      case 615:
      case 616:
      case 620:
      case 621:
      case 622:
        icon = WeatherIcons.snow;
      case 700:
      case 741:
      case 771:
        icon = WeatherIcons.fog;
      case 711:
        icon = WeatherIcons.smoke;
      case 721:
        icon = WeatherIcons.day_haze;
      case 731:
        icon = WeatherIcons.dust;
      case 751:
        icon = WeatherIcons.sandstorm;
      case 761:
      case 762:
        icon = WeatherIcons.dust;
      case 781:
        icon = WeatherIcons.tornado;
      case 801:
        icon = WeatherIcons.cloud;
      case 802:
        icon = WeatherIcons.day_cloudy;
      case 803:
        icon = WeatherIcons.day_cloudy_high;
      case 804:
        icon = WeatherIcons.cloudy;
      case 800:
      default:
        icon = WeatherIcons.day_sunny;
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Icon(
        icon,
        color: color,
        size: size,
      ),
    );
  }
}
