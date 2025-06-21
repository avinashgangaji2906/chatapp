import 'dart:io';
import 'package:dio/dio.dart';
import '../errors/app_exception.dart'; // adjust path

class DioErrorHandler {
  static AppException handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return AppException("Connection timed out. Please try again.");

        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode ?? 0;
          final errorData = error.response?.data;

          String message = "Something went wrong.";

          // Backend-specific error message
          if (errorData is Map && errorData['message'] != null) {
            message = errorData['message'];
          }

          return AppException(message, details: "HTTP $statusCode");

        case DioExceptionType.cancel:
          return AppException("Request was cancelled.");

        case DioExceptionType.unknown:
          if (error.error is SocketException) {
            return AppException("No internet connection.");
          }
          return AppException("Unexpected error occurred.");

        default:
          return AppException("Something went wrong.");
      }
    } else if (error is SocketException) {
      return AppException("No internet connection.");
    } else {
      return AppException("Unexpected error occurred.");
    }
  }
}
