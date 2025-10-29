import '../../core/services/firebase_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  // TODO: После Firebase можно добавить custom API
  // final ApiClient _apiClient;
  // AuthRepository(this._apiClient);

  // Регистрация через Firebase
  Future<UserModel> register({
    required String email,
    required String password,
    required String username,
  }) async {
    return await FirebaseService.register(
      email: email,
      password: password,
      username: username,
    );
  }

  // Вход через Firebase
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    return await FirebaseService.login(
      email: email,
      password: password,
    );
  }

  // Выход
  Future<void> logout() async {
    await FirebaseService.logout();
  }

  // Получение текущего пользователя
  Future<UserModel> getCurrentUser() async {
    final user = await FirebaseService.getCurrentUser();
    if (user == null) {
      throw Exception('Unauthorized');
    }
    return user;
  }

  // Обновление профиля
  Future<void> updateProfile(String uid, Map<String, dynamic> data) async {
    await FirebaseService.updateUser(uid, data);
  }
}