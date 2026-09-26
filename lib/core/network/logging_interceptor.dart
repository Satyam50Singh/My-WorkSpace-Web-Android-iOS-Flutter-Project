import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('➡️ ${options.method} ${options.uri}');
      if (options.data != null) {
        if (options.data is FormData) {
          final formData = options.data as FormData;
          final fields = formData.fields
              .map((e) => '${e.key}: ${e.value}')
              .toList();
          final files = formData.files
              .map((e) => '${e.key}: ${e.value.filename}')
              .toList();
          debugPrint('   Body (FormData):');
          if (fields.isNotEmpty) debugPrint('     Fields: $fields');
          if (files.isNotEmpty) debugPrint('     Files: $files');
        } else {
          debugPrint('   Body: ${options.data}');
        }
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('✅ ${response.statusCode} ${response.requestOptions.uri}');
      debugPrint('✅ Response: ${response.data}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('❌ ${err.requestOptions.uri} — ${err.message}');
    }
    handler.next(err);
  }
}
