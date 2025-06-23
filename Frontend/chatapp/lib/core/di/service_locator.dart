import 'package:chatapp/features/auth/cubit/auth_status_cubit.dart';
import 'package:chatapp/features/auth/data/datasource/auth_datasource.dart';
import 'package:chatapp/features/auth/data/repository/auth_repository_impl.dart';
import 'package:chatapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chatapp/features/chat/data/datasource/chat_data_source.dart';
import 'package:chatapp/features/chat/data/datasource/chat_socket_client.dart';
import 'package:chatapp/features/chat/data/repository/chat_repository_impl.dart';
import 'package:chatapp/features/chat/domain/repository/chat_repository.dart';
import 'package:chatapp/features/users_list/data/datasource/user_datasource.dart';
import 'package:chatapp/features/users_list/data/repository/users_repository_impl.dart';
import 'package:chatapp/features/users_list/domain/repository/user_repository.dart';
import 'package:chatapp/features/users_list/presentation/bloc/user_list_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/domain/repository/auth_repository.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  // 1. Initialize Dio and register it
  final dio = await DioClient.getInstance();
  sl.registerLazySingleton(() => dio);

  // Auth Feature
  sl.registerLazySingleton<AuthDatasource>(() => AuthDatasource(dio: sl()));
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authDatasource: sl()),
  );
  sl.registerFactory(() => AuthBloc(authRepository: sl()));

  //   Auth status cubit
  sl.registerLazySingleton<AuthStatusCubit>(
    () => AuthStatusCubit(authRepository: sl()),
  );

  // All Users Feature
  sl.registerLazySingleton(() => UserDatasource(dio: sl()));
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(userDatasource: sl()),
  );
  sl.registerFactory(() => UserListBloc(userRepository: sl()));

  // Chat feature
  sl.registerSingleton<ChatSocketClient>(ChatSocketClient());
  sl.registerLazySingleton(() => ChatDataSource(dio: sl()));
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(client: sl(), chatDataSource: sl()),
  );
}
