import 'package:get_it/get_it.dart';
import 'package:my_worksphere_web/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:my_worksphere_web/features/auth/domain/usecases/validate_company_code_usecase.dart';
import 'package:my_worksphere_web/features/auth/presentation/blocs/auto_bloc/auth_bloc.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  // ---------- Data sources ----------
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  // ---------- Repositories ----------
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // ---------- Use cases ----------
  sl.registerLazySingleton<ValidateCompanyCodeUseCase>(
    () => ValidateCompanyCodeUseCase(sl()),
  );

  // ---------- Blocs / Cubits ----------
  sl.registerFactory(() => AuthBloc(sl()));
}
