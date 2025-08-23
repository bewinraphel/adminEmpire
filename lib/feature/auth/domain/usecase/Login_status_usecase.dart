import 'package:empire/feature/auth/domain/repositories/login_status_auth.dart';

class CheckLoginStatus {
  final LoginStatus respository;
  CheckLoginStatus(this.respository);

  Future<bool> call() async {
    return respository.isLoggedIn();
  }
}
