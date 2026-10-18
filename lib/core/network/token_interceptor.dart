import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/presentation/cubit/employee_detail_cubit.dart';

class TokenInterceptor extends Interceptor {
  TokenInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      final employeeDetailCubit = GetIt.instance<EmployeeDetailCubit>();
      final state = employeeDetailCubit.state;
      if (state is EmployeeDetailFetched) {
        final token = state.employeeDetail.jwtToken;
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      }
    } catch (_) {}
    super.onRequest(options, handler);
  }
}
