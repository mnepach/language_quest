import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  // Регистрация
  Future<UserModel> register({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.register,
        data: {
          'email': email,
          'password': password,
          'username': username,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Сохраняем токены
        await _apiClient.saveTokens(
          response.data['access_token'],
          response.data['refresh_token'],
        );

        return UserModel.fromJson(response.data['user']);
      } else {
        throw Exception('Registration failed');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw Exception('User already exists');
      }
      throw Exception(e.response?.data['message'] ?? 'Registration failed');
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // Вход
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        // Сохраняем токены
        await _apiClient.saveTokens(
          response.data['access_token'],
          response.data['refresh_token'],
        );

        return UserModel.fromJson(response.data['user']);
      } else {
        throw Exception('Login failed');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Invalid email or password');
      }
      throw Exception(e.response?.data['message'] ?? 'Login failed');
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Выход
  Future<void> logout() async {
    try {
      await _apiClient.post(ApiConstants.logout);
    } catch (e) {
      // Игнорируем ошибки при logout
    } finally {
      // Всегда удаляем токены локально
      await _apiClient.clearTokens();
    }
  }

  // Получение текущего пользователя
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiClient.get(ApiConstants.userProfile);

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception('Failed to get user');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized');
      }
      throw Exception('Failed to get user');
    }
  }

  // Проверка email
  Future<void> verifyEmail(String code) async {
    try {
      await _apiClient.post(
        ApiConstants.verifyEmail,
        data: {'code': code},
      );
    } catch (e) {
      throw Exception('Email verification failed');
    }
  }

  // Восстановление пароля
  Future<void> resetPassword(String email) async {
    try {
      await _apiClient.post(
        '/auth/reset-password',
        data: {'email': email},
      );
    } catch (e) {
      throw Exception('Password reset failed');
    }
  }
}
