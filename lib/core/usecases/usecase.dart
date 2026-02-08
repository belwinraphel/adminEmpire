import 'package:dartz/dartz.dart';
import 'package:empire/core/utils/failure.dart';
 

abstract class UseCase<Type, Params> {
  Future<Either<Failures, Type>> call(Params params);
}

class NoParams {}
