import 'dart:developer';
import 'dart:io';

import 'package:chatapp/core/constants/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class DioClient {
  static Dio? _dioInstance;
  static PersistCookieJar? _cookieJar;

  /// Use this to get a fully configured Dio instance with cookie support.
  static Future<Dio> getInstance() async {
    if (_dioInstance != null) return _dioInstance!;

    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Logging interceptor only in debug mode
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          responseBody: true,
          requestBody: true,
          responseHeader: false,
        ),
      );
    }

    //  Get platform-safe directory for storing cookies
    Directory dir = await getApplicationDocumentsDirectory();

    _cookieJar = PersistCookieJar(
      ignoreExpires:
          false, // if cookie expires then does not attach it with request
      storage: FileStorage('${dir.path}/.cookies'),
    );

    dio.interceptors.add(CookieManager(_cookieJar!));

    _dioInstance = dio;
    return _dioInstance!;
  }

  /// Clears all stored cookies
  static Future<void> clearCookies() async {
    final dio = await getInstance();
    final cookieManager =
        dio.interceptors.firstWhere(
              (i) => i is CookieManager,
              orElse: () => throw Exception('CookieManager not found'),
            )
            as CookieManager;
    await cookieManager.cookieJar.deleteAll();
    log('Cookie Jar deleted on Logout');
  }
}
