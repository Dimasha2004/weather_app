import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getCurrentWeather(String cityName);
  Future<WeatherModel> getCurrentWeatherByCoordinates(double lat, double lon);
  Future<List<WeatherModel>> getForecast(String cityName);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final Dio client;
  final String apiKey =
      'efce82a784856bbd314a308b83082c4d'; // In production, use env variables
  final String baseUrl = 'https://api.openweathermap.org/data/2.5';

  WeatherRemoteDataSourceImpl({required this.client});

  @override
  Future<WeatherModel> getCurrentWeather(String cityName) async {
    final response = await client.get(
      '$baseUrl/weather',
      queryParameters: {'q': cityName, 'appid': apiKey, 'units': 'metric'},
    );

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<WeatherModel> getCurrentWeatherByCoordinates(
    double lat,
    double lon,
  ) async {
    final response = await client.get(
      '$baseUrl/weather',
      queryParameters: {
        'lat': lat,
        'lon': lon,
        'appid': apiKey,
        'units': 'metric',
      },
    );

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<WeatherModel>> getForecast(String cityName) async {
    final response = await client.get(
      '$baseUrl/forecast',
      queryParameters: {'q': cityName, 'appid': apiKey, 'units': 'metric'},
    );

    if (response.statusCode == 200) {
      final cityName = response.data['city']['name'];
      final List<dynamic> list = response.data['list'];
      return list
          .map((e) => WeatherModel.fromJson(e, cityName: cityName))
          .toList();
    } else {
      throw ServerException();
    }
  }
}
