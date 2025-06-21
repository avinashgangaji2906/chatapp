import 'package:chatapp/features/auth/cubit/auth_status_cubit.dart';
import 'package:chatapp/features/auth/data/datasource/auth_datasource.dart';
import 'package:chatapp/features/auth/data/repository/auth_repository_impl.dart';
import 'package:chatapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/domain/repository/auth_repository.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  // 1. Initialize Dio and register it
  final dio = await DioClient.getInstance();
  sl.registerLazySingleton(() => dio);

  // 2. Data source
  sl.registerLazySingleton<AuthDatasource>(() => AuthDatasource(dio: sl()));

  // 3. Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authDatasource: sl()),
  );

  // 4. Bloc
  sl.registerFactory(() => AuthBloc(authRepository: sl()));

  //  5. Auth status cubit
  sl.registerLazySingleton<AuthStatusCubit>(
    () => AuthStatusCubit(authRepository: sl()),
  );
}
