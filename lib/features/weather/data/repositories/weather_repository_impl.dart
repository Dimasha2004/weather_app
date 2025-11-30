import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_remote_datasource.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  WeatherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Weather>> getCurrentWeather(String cityName) async {
    try {
      final remoteWeather = await remoteDataSource.getCurrentWeather(cityName);
      return Right(remoteWeather);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Weather>>> getForecast(String cityName) async {
    try {
      final remoteForecast = await remoteDataSource.getForecast(cityName);
      return Right(remoteForecast);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
