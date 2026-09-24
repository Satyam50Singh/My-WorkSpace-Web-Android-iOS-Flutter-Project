import 'package:dio/dio.dart';

import 'api_exceptions.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return _extractData(response);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        queryParameters: queryParameters,
        data: data,
        options: options,
      );
      return _extractData(response);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Map<String, dynamic> _extractData(Response response) {
    if (response.data is Map<String, dynamic>) {
      return response.data as Map<String, dynamic>;
    }
    throw const ApiException(message: 'Unexpected response format');
  }

  ApiException _mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(
          message: 'Weak network detected. Request timed out.',
        );
      case DioExceptionType.connectionError:
        return const ApiException(
          message:
              'Unable to reach server. Please check your internet connection.',
        );
      case DioExceptionType.badResponse:
        return ApiException(
          message:
              _extractErrorMessage(e.response?.data) ?? 'Something went wrong.',
          statusCode: e.response?.statusCode,
        );
      default:
        return ApiException(message: e.message ?? 'Unexpected error occurred.');
    }
  }

  String? _extractErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['Message'] as String? ?? data['message'] as String?;
    }
    return null;
  }
}
