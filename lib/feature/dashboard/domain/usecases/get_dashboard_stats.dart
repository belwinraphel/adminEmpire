import 'package:dartz/dartz.dart';
import 'package:empire/core/utils/failure.dart';
 
import '../../../../core/usecases/usecase.dart';
import '../entities/kpi.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardStats implements UseCase<List<KPI>, NoParams> {
  final DashboardRepository repository;

  GetDashboardStats(this.repository);

  @override
  Future<Either<Failures, List<KPI>>> call(NoParams params) async {
    return await repository.getDashboardStats();
  }
}
