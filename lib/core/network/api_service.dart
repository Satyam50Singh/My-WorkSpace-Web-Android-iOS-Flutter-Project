import 'package:dio/dio.dart';

import 'api_endpoints.dart';
import 'logging_interceptor.dart';
import 'network_intercept.dart';

class ApiService {
  late final Dio dio;

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(NetworkIntercept());
    dio.interceptors.add(LoggingInterceptor());
  }
}
