

import 'package:dartz/dartz.dart';
import 'package:empire/core/utils/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
 
  Future <Either<Failures, User>> login(String name,String password);
 
    
}
 
