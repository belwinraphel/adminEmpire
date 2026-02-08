import 'package:dartz/dartz.dart';
import 'package:empire/core/utils/failure.dart';
 
import '../../../../core/usecases/usecase.dart';
import '../entities/employee.dart';
import '../repositories/dashboard_repository.dart';

class GetEmployees implements UseCase<List<Employee>, NoParams> {
  final DashboardRepository repository;

  GetEmployees(this.repository);

  @override
  Future<Either<Failures, List<Employee>>> call(NoParams params) async {
    return await repository.getEmployees();
  }
}
