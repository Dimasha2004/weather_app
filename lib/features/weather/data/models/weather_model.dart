import '../../domain/entities/weather.dart';

class WeatherModel extends Weather {
  WeatherModel({
    required super.cityName,
    required super.temperature,
    required super.description,
    required super.iconCode,
    required super.windSpeed,
    required super.humidity,
    required super.date,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json, {String? cityName}) {
    return WeatherModel(
      cityName: cityName ?? json['name'] as String,
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'] as String,
      iconCode: json['weather'][0]['icon'] as String,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      humidity: json['main']['humidity'] as int,
      date: DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),
    );
  }
}
