import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:rota_app/modules/auth/data/auth_repository.dart';
import 'package:rota_app/modules/auth/data/login_response.dart';
import 'package:rota_app/core/helpers/token_helper.dart';
import 'package:rota_app/modules/auth/data/user_profile.dart';

class AuthRepositoryMock implements AuthRepository {
  @override
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    // Simula um delay de rede
    await Future.delayed(const Duration(seconds: 1));

    // Simula credenciais inválidas
    if (email != 'motorista1@gmail.com' || password != 'root3001') {
      throw Exception('Credenciais inválidas');
    }

    return LoginResponse(
      token: 'mock_token',
      user: {
        'id': 1,
        'name': 'Motorista 1',
        'email': 'motorista1@gmail.com',
        'type': 'driver',
        'driver': {
          'id': 1,
          'name': 'Motorista 1',
          'phone': '(46) 99292-9292',
          'status': true,
        },
      },
      driver: {
        'id': 1,
        'name': 'Motorista 1',
        'phone': '(46) 99292-9292',
        'status': true,
      },
    );
  }

  @override
  Future<UserProfile> getProfile() async {
    // Simula um delay de rede
    await Future.delayed(const Duration(seconds: 1));

    return UserProfile(
      id: 1,
      name: 'Motorista 1',
      email: 'motorista1@gmail.com',
      type: 'driver',
      driver: DriverProfile(
        id: 1,
        name: 'Motorista 1',
        phone: '(46) 99292-9292',
        status: true,
      ),
    );
  }

  @override
  Future<void> logout() async {
    // Simula um delay de rede
    await Future.delayed(const Duration(seconds: 1));
  }
}
