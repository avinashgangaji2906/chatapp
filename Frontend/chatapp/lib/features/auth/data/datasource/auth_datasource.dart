import 'package:chatapp/core/constants/api_constants.dart';
import 'package:chatapp/core/errors/dio_error_handler.dart';
import 'package:chatapp/core/network/dio_client.dart';
import 'package:dio/dio.dart';
import '../models/auth_model.dart';

class AuthDatasource {
  final Dio dio;

  AuthDatasource({required this.dio});

  Future<AuthModel> login({
    required String username,
    required String password,
  }) async {
    try {
      await DioClient.clearCookies(); // remove stale cookie
      final response = await dio.post(
        ApiConstants.login,
        data: {'username': username, 'password': password},
        options: Options(
          contentType: Headers.jsonContentType,
          // Cookies will be handled automatically by Dio with CookieManager
        ),
      );

      final data = response.data;

      if (response.statusCode == 200 &&
          data['success'] == true &&
          data['user'] != null) {
        return AuthModel.fromJson(data['user']);
      } else {
        throw Exception(data['message'] ?? 'Login failed');
      }
    } catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<AuthModel> signup({
    required String username,
    required String password,
  }) async {
    try {
      await DioClient.clearCookies(); // remove stale cookie

      final response = await dio.post(
        ApiConstants.signup,
        data: {'username': username, 'password': password},
        options: Options(contentType: Headers.jsonContentType),
      );

      final data = response.data;

      if (response.statusCode == 201 &&
          data['success'] == true &&
          data['user'] != null) {
        return AuthModel.fromJson(data['user']);
      } else {
        throw Exception(data['message'] ?? 'Signup failed');
      }
    } catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  // Get User Session
  Future<AuthModel> getUserSession() async {
    try {
      final response = await dio.get(ApiConstants.profile);
      final data = response.data;

      if (response.statusCode == 200 &&
          data['success'] == true &&
          data['user'] != null) {
        return AuthModel.fromJson(data['user']);
      } else {
        throw Exception(data['message'] ?? 'Signup failed');
      }
    } catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  // logout user session from server
  Future<void> logout() async {
    try {
      await dio.post(ApiConstants.logout);
      await DioClient.clearCookies();
    } catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }
}
