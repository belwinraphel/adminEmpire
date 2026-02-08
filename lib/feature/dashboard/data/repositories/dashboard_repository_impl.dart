import 'package:dartz/dartz.dart';
import 'package:empire/core/utils/failure.dart';
 
import '../../domain/entities/employee.dart';
import '../../domain/entities/kpi.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_data_source.dart';

import '../../../../core/services/climate_service.dart';
import '../../domain/entities/climate.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;
  final ClimateService climateService;

  DashboardRepositoryImpl({
    required this.remoteDataSource,
    required this.climateService,
  });

  @override
  Future<Either<Failures, Climate>> getClimateData() async {
    final data = await climateService.getClimateData();
    if (data.isEmpty) {
      return Left(Failures.server('No climate data available')); // Handle empty data as failure
    }

    final double temperature = (data['temperature'] as num).toDouble();
    final double windSpeed = (data['windSpeed'] as num).toDouble();
    final double humidity = (data['humidity'] as num).toDouble();
    final String condition = data['condition'] as String;

    String videoUrl;
    if (temperature < 20) {
      videoUrl =
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';
    } else if (condition == 'Sunny') {
      videoUrl =
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4';
    } else {
      videoUrl =
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';
    }

    return Right(
      Climate(
        temperature: temperature,
        windSpeed: windSpeed,
        humidity: humidity,
        condition: condition,
        videoUrl: videoUrl,
      ),
    );
  }

  @override
  Future<Either<Failures, List<KPI>>> getDashboardStats() async {
    try {
      final remoteStats = await remoteDataSource.getDashboardStats();
      return Right(remoteStats);
    } catch (e) {
      return Left(Failures.server(e.toString()));
    }
  }

  @override
  Future<Either<Failures, List<Employee>>> getEmployees() async {
    try {
      final remoteEmployees = await remoteDataSource.getEmployees();
      return Right(remoteEmployees);
    } catch (e) {
      return Left(Failures.server(e.toString()));
    }
  }
}
