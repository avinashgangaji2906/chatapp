class ApiConstants {
  static const String baseUrl = 'http://192.168.69.58:3000/api';

  // Auth Endpoints
  static const String login = '$baseUrl/auth/login';
  static const String signup = '$baseUrl/auth/signup';
  static const String logout = '$baseUrl/auth/logout';

  // Profile Endpoint
  static const String profile = '$baseUrl/profile/me';

  // Chat Endpoint
  static const String chatBase = '$baseUrl/chat';

  // Chat All Users
  static const String userBase = '$baseUrl/user';
}
