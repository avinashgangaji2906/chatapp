import 'package:chatapp/core/errors/dio_error_handler.dart';
import 'package:chatapp/features/users_list/data/model/user_list_model.dart';
import 'package:dio/dio.dart';

class UserListDatasource {
  final Dio dio;
  UserListDatasource({required this.dio});

  Future<List<UserListModel>> getAllUsers() async {
    try {
      final response = await dio.get("/user/all");

      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['users'] as List;
        return data.map((e) => UserListModel.fromJson(e)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }
}
