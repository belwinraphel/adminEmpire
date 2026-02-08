 
import 'package:dartz/dartz.dart';
import 'package:empire/core/usecases/usecase.dart';
import 'package:empire/core/utils/failure.dart';
import 'package:empire/feature/dashboard/domain/repositories/dashboard_repository.dart';
 import '../entities/climate.dart';

class GetClimateData implements UseCase<Climate, NoParams> {
  final DashboardRepository repository;

  GetClimateData(this.repository);

  @override
  Future<Either<Failures, Climate>> call(NoParams params) async {
    return await repository.getClimateData();
  }
}
