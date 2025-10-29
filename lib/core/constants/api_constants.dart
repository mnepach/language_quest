class ApiConstants {
  // Base URLs
  static const String baseUrl = 'https://your-api.com/api/v1';
  static const String wsUrl = 'wss://your-api.com/ws';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String verifyEmail = '/auth/verify';

  // User endpoints
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/update';
  static const String userProgress = '/user/progress';
  static const String userStats = '/user/stats';

  // Lessons endpoints
  static const String lessons = '/lessons';
  static const String lessonDetail = '/lessons/{id}';
  static const String lessonComplete = '/lessons/{id}/complete';

  // Games endpoints
  static const String gameStart = '/games/{type}/start';
  static const String gameSubmit = '/games/{type}/submit';
  static const String leaderboard = '/games/leaderboard';

  // Sync endpoints
  static const String syncData = '/sync';
  static const String syncProgress = '/sync/progress';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
