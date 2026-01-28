import 'package:empire/feature/auth/data/datasource/register.dart';
import 'package:empire/feature/auth/domain/repositories/register.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final UserFirebaseSource userFirebaseSource;
  RegisterRepositoryImpl(this.userFirebaseSource);
  @override
  Future<bool> checkingUser({required String email, required int mobile,required String name,String? image}) {
    return userFirebaseSource.checkUserExist(email: email, mobile: mobile,name: name,image: image);
  }
}
