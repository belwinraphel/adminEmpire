import 'package:dartz/dartz.dart';
import 'package:empire/core/utils/failure.dart';
 
import '../entities/employee.dart';
import '../entities/kpi.dart';
import '../entities/climate.dart';

abstract class DashboardRepository {
  Future<Either<Failures, List<KPI>>> getDashboardStats();
  Future<Either<Failures, List<Employee>>> getEmployees();
  Future<Either<Failures, Climate>> getClimateData();
}
