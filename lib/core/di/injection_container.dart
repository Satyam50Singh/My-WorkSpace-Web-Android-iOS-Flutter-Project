import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:my_worksphere_web/core/network/api_endpoints.dart';
import 'package:my_worksphere_web/core/network/logging_interceptor.dart';
import 'package:my_worksphere_web/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:my_worksphere_web/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:my_worksphere_web/features/auth/domain/usecases/employee_login_usecase.dart';
import 'package:my_worksphere_web/features/auth/domain/usecases/validate_company_code_usecase.dart';
import 'package:my_worksphere_web/features/auth/presentation/blocs/auto_bloc/auth_bloc.dart';
import 'package:my_worksphere_web/features/auth/presentation/cubit/employee_detail_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../network/api_client.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  // ---------- External ----------
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // ---------- Dio + interceptors ----------
  sl.registerLazySingleton(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    dio.interceptors.add(LoggingInterceptor());
    return dio;
  });

  sl.registerLazySingleton(() => ApiClient(sl()));

  // ---------- Data sources ----------
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );

  // ---------- Repositories ----------
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl(), sl()));

  // ---------- Use cases ----------
  sl.registerLazySingleton<ValidateCompanyCodeUseCase>(
    () => ValidateCompanyCodeUseCase(sl()),
  );
  sl.registerLazySingleton<EmployeeLoginUseCase>(
    () => EmployeeLoginUseCase(sl()),
  );

  // ---------- Blocs / Cubits ----------
  sl.registerFactory(() => AuthBloc(sl(), sl()));
  sl.registerFactory(() => EmployeeDetailCubit(sl()));
}
