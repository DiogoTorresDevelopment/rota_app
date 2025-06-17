import 'package:rota_app/modules/auth/data/login_response.dart';
import 'package:rota_app/modules/auth/data/user_profile.dart';

abstract class AuthRepository {
  Future<LoginResponse> login({
    required String email,
    required String password,
  });

  Future<UserProfile> getProfile();
  
  Future<void> logout();
}

