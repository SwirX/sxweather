class Weather {
  final String city;
  final double feelLikeTemp;
  final double temperature;
  final double minTemperature;
  final double maxTemperature;
  final String mainCondition;
  final String weatherDescription;
  final int pressure;
  final int humidity;
  final int seaLevel;
  final int groundLevel;
  final int visibility;
  final double windspeed;
  final int windDirection;
  final double gust;
  final DateTime sunrise;
  final DateTime sunset;
  final int cloudiness;
  final int weatherId;
  final double? rain1h;
  final double? rain3h;
  final double? snow1h;
  final double? snow3h;

  Weather({
    required this.city,
    required this.feelLikeTemp,
    required this.temperature,
    required this.minTemperature,
    required this.maxTemperature,
    required this.mainCondition,
    required this.weatherDescription,
    required this.pressure,
    required this.humidity,
    required this.seaLevel,
    required this.groundLevel,
    required this.visibility,
    required this.windspeed,
    required this.windDirection,
    required this.gust,
    required this.sunrise,
    required this.sunset,
    required this.cloudiness,
    required this.weatherId,
    this.rain1h,
    this.rain3h,
    this.snow1h,
    this.snow3h,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final sunrise =
        DateTime.fromMillisecondsSinceEpoch(json["sys"]["sunrise"] * 1000);
    final sunset =
        DateTime.fromMillisecondsSinceEpoch(json["sys"]["sunset"] * 1000);
    return Weather(
      city: json["name"],
      feelLikeTemp: json["main"]["feels_like"],
      temperature: json["main"]["temp"],
      weatherId: json["weather"][0]["id"],
      mainCondition: json["weather"][0]["main"],
      weatherDescription: json["weather"][0]["description"],
      maxTemperature: json["main"]["temp_max"],
      minTemperature: json["main"]["temp_min"],
      pressure: json["main"]["pressure"].toInt(),
      humidity: json["main"]["humidity"].toInt(),
      seaLevel: json["main"]["sea_level"].toInt(),
      groundLevel: json["main"]["grnd_level"].toInt(),
      visibility: json["visibility"].toInt(),
      windspeed: json["wind"]["speed"],
      windDirection: json["wind"]["deg"],
      gust: json["wind"]["gust"],
      cloudiness: json["clouds"]["all"].toInt(),
      sunrise: sunrise,
      sunset: sunset,
      rain1h: json["rain"] == null ? null : json["rain"]["1h"],
      rain3h: json["rain"] == null ? null : json["rain"]["3h"],
      snow1h: json["snow"] == null ? null : json["snow"]["1h"],
      snow3h: json["snow"] == null ? null : json["snow"]["3h"],
    );
  }
}
