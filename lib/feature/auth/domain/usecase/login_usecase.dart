import 'package:empire/feature/auth/domain/repositories/auth_repository.dart';

class Login {
  final AuthRepository authRepository;
  Login(this.authRepository);
  Future<void> call(String name,String password){
   return authRepository.login(name, password);
  }
}
