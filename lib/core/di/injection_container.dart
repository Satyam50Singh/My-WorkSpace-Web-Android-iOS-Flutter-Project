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
import 'package:my_worksphere_web/features/ticketing/data/datasources/add_new_request_data_source.dart';
import 'package:my_worksphere_web/features/ticketing/data/datasources/ticketing_remote_data_source.dart';
import 'package:my_worksphere_web/features/ticketing/data/datasources/view_ticket_detail_remote_data_source.dart';
import 'package:my_worksphere_web/features/ticketing/domain/repositories/add_new_request_repository.dart';
import 'package:my_worksphere_web/features/ticketing/domain/repositories/ticketing_repository.dart';
import 'package:my_worksphere_web/features/ticketing/domain/repositories/view_ticket_detail_repository.dart';
import 'package:my_worksphere_web/features/ticketing/domain/usecases/add_new_request/ticket_location_category_usecase.dart';
import 'package:my_worksphere_web/features/ticketing/domain/usecases/add_new_request/ticket_workflow_details_usecase.dart';
import 'package:my_worksphere_web/features/ticketing/domain/usecases/submit_reopen_review_usecase.dart';
import 'package:my_worksphere_web/features/ticketing/domain/usecases/ticket_action_history_usecase.dart';
import 'package:my_worksphere_web/features/ticketing/domain/usecases/ticket_workflow_usecase.dart';
import 'package:my_worksphere_web/features/ticketing/domain/usecases/ticketing_my_request_usecase.dart';
import 'package:my_worksphere_web/features/ticketing/domain/usecases/view_ticket_detail_v6_usecase.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/blocs/add_new_request_bloc/add_new_ticket_bloc.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/blocs/view_ticket_details_bloc/view_ticket_details_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/ticketing/data/repositories/add_new_request_repository_impl.dart';
import '../../features/ticketing/data/repositories/ticketing_repository_impl.dart';
import '../../features/ticketing/data/repositories/view_ticket_detail_repository_impl.dart';
import '../../features/ticketing/domain/usecases/add_new_request/ticket_sub_category_usecase.dart';
import '../../features/ticketing/presentation/blocs/my_ticket_request_bloc/ticketing_bloc.dart';
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
  sl.registerLazySingleton<TicketingRemoteDataSource>(
    () => TicketingRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ViewTicketDetailRemoteDataSource>(
    () => ViewTicketDetailRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AddNewRequestDataSource>(
    () => AddNewRequestDataSourceImpl(sl()),
  );

  // ---------- Repositories ----------
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<TicketingRepository>(
    () => TicketingRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<ViewTicketDetailRepository>(
    () => ViewTicketDetailRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<AddNewRequestRepository>(
    () => AddNewRequestRepositoryImpl(sl()),
  );

  // ---------- Use cases ----------
  sl.registerLazySingleton<ValidateCompanyCodeUseCase>(
    () => ValidateCompanyCodeUseCase(sl()),
  );
  sl.registerLazySingleton<EmployeeLoginUseCase>(
    () => EmployeeLoginUseCase(sl()),
  );
  sl.registerLazySingleton<TicketingMyRequestUseCase>(
    () => TicketingMyRequestUseCase(sl()),
  );
  sl.registerLazySingleton<ViewTicketDetailV6UseCase>(
    () => ViewTicketDetailV6UseCase(sl()),
  );
  sl.registerLazySingleton<TicketWorkflowUseCase>(
    () => TicketWorkflowUseCase(sl()),
  );
  sl.registerLazySingleton<TicketActionHistoryUseCase>(
    () => TicketActionHistoryUseCase(sl()),
  );
  sl.registerLazySingleton<SubmitReopenReviewUseCase>(
    () => SubmitReopenReviewUseCase(sl()),
  );
  sl.registerLazySingleton<TicketLocationCategoryUseCase>(
    () => TicketLocationCategoryUseCase(sl()),
  );
  sl.registerLazySingleton<TicketSubCategoryUseCase>(
    () => TicketSubCategoryUseCase(sl()),
  );
  sl.registerLazySingleton<TicketWorkFlowDetailsUseCase>(
    () => TicketWorkFlowDetailsUseCase(sl()),
  );

  // ---------- Blocs / Cubits ----------
  sl.registerFactory(() => AuthBloc(sl(), sl()));
  sl.registerFactory(() => EmployeeDetailCubit(sl()));
  sl.registerFactory(() => TicketingBloc(sl()));
  sl.registerFactory(() => ViewTicketDetailsBloc(sl(), sl(), sl(), sl()));
  sl.registerFactory(() => AddNewTicketBloc(sl(), sl(), sl()));
}
